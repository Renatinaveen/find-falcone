import 'package:find_falcone/models/find_falcone_response_model.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/selection_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';
import 'package:find_falcone/resources/events/falcone_events.dart';
import 'package:find_falcone/resources/states/falcone_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources/repositories/falcone_repo.dart';

class FalconeBloc extends Bloc<FalconeEvents, FalconeStates> {
  SelectionModel selectionModel =
      SelectionModel(selectedPlanets: [], selectedVehicles: []);

  FalconeBloc() : super(UnInitialized()) {
    on<FetchPlanetsNVehicles>(_fetchPlanetsNVehicles);
    on<SearchFalcone>(_searchFalcone);
    on<AddSearchSelection>(_addSearchSelection);
    on<RemoveSearchSelection>(_removeSearchSelection);
    on<CalculateTimeToReach>(_calculateTimeToReach);
  }

  _fetchPlanetsNVehicles(
      FetchPlanetsNVehicles event, Emitter<FalconeStates> emit) async {
    try {
      emit(FetchingPlanetsNVehicles());
      List<PlanetsModel> planetsModel =
          await FalconeRepository().fetchPlanets();
      List<VehiclesModel> vehiclesModel =
          await FalconeRepository().fetchVehicles();
      if(kDebugMode) {
        debugPrint('planets $planetsModel');
      }
      if (planetsModel.isEmpty || vehiclesModel.isEmpty) {
        emit(FailedToFetchPlanetsNVehicles());
      } else {
        emit(FetchedPlanetsNVehicles(
            planets: planetsModel,
            vehicles: vehiclesModel,
            selectionModel: selectionModel));
      }
    } catch (e) {
      emit(FailedToFetchPlanetsNVehicles());
    }
  }

  _searchFalcone(SearchFalcone event, Emitter<FalconeStates> emit) async {
    try {
      emit(SearchingForFalcone());
      List<String?> planets = [];
      List<String?> vehicles = [];
      for (var element in event.selectionModel.selectedPlanets) {
        planets.add(element.name);
      }
      for (var element in event.selectionModel.selectedVehicles) {
        vehicles.add(element.name);
      }
      FindFalconeResponseModel response = await FalconeRepository()
          .findFalcone(planets: planets, vehicles: vehicles);
      if (response.status == 'success') {
        emit(FalconeResponse(
          planetName: response.planetName,
          status: response.status,
          error: '',
        ));
      } else {
        emit(FalconeResponse(
          planetName: '',
          status: response.status,
          error: response.error,
        ));
      }
    } catch (e) {
      emit(SomeThingWentWrong());
    }
  }

  _addSearchSelection(
      AddSearchSelection event, Emitter<FalconeStates> emit) async {
    try {
      emit(AddingSearchSelection());
      if(kDebugMode) {
        debugPrint('add selection $selectionModel');
      }
      selectionModel = event.selectionModel;
      if (event.selectionModel.selectedPlanets.length == 4) {
        emit(SelectedMaxPlanets());
      } else {
        if (event.vehicle.totalNo! > 0) {
          if (!selectionModel.selectedPlanets.contains(event.planet)) {
            if (event.vehicle.maxDistance! >= event.planet.distance!) {
              selectionModel.addSelection(event.planet, event.vehicle);
              event.vehicle.totalNo = event.vehicle.totalNo! - 1;
              emit(AddedSearchSelection(
                selectionModel: selectionModel,
              ));
            } else {
              emit(NotEnoughRange());
            }
          } else {
            emit(PlanetAlreadySelected());
          }
        } else {
          emit(VehicleNotAvailable());
        }
      }
    } catch (e) {
      emit(SomeThingWentWrong());
    }
  }

  _removeSearchSelection(
      RemoveSearchSelection event, Emitter<FalconeStates> emit) async {
    try {
      emit(RemovingSearchSelection());

      selectionModel.removeSelection(event.index);

      emit(RemovedSearchSelection(
        selectionModel: selectionModel,
      ));
    } catch (e) {
      emit(SomeThingWentWrong());
    }
  }

  _calculateTimeToReach(
      CalculateTimeToReach event, Emitter<FalconeStates> emit) async {
    try {
      emit(CalculatingTimeToReach());
      int timeTaken = event.distance ~/ event.speed;
      emit(CalculatedTimeToReach(
        timeTaken: timeTaken,
      ));
    } catch (e) {
      emit(SomeThingWentWrong());
    }
  }
}
