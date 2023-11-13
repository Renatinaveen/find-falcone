import 'package:equatable/equatable.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/selection_model.dart';

import '../../models/vehicle_model.dart';

abstract class FalconeStates extends Equatable {
  const FalconeStates();

  @override
  List<Object> get props => [];
}

class UnInitialized extends FalconeStates {}

class FetchingPlanetsNVehicles extends FalconeStates {}

class FailedToFetchPlanetsNVehicles extends FalconeStates {}

class FetchedPlanetsNVehicles extends FalconeStates {
  final List<PlanetsModel> planets;
  final List<VehiclesModel> vehicles;
  final SelectionModel selectionModel;
  const FetchedPlanetsNVehicles(
      {required this.planets,
      required this.vehicles,
      required this.selectionModel});

  @override
  List<Object> get props => [planets, vehicles, selectionModel];
}

class SearchingForFalcone extends FalconeStates {}

class FalconeResponse extends FalconeStates {
  final String? planetName, status, error;

  const FalconeResponse(
      {required this.planetName, required this.status, required this.error});

  @override
  List<Object> get props => [
        planetName!,
        status!,
        error!,
      ];
}

class AddingSearchSelection extends FalconeStates {}

class AddedSearchSelection extends FalconeStates {
  final SelectionModel selectionModel;

  const AddedSearchSelection({required this.selectionModel});

  @override
  List<Object> get props => [selectionModel];
}

class NotEnoughRange extends FalconeStates {}

class PlanetAlreadySelected extends FalconeStates {}

class VehicleNotAvailable extends FalconeStates {}

class SelectedMaxPlanets extends FalconeStates {}

class RemovingSearchSelection extends FalconeStates {}

class RemovedSearchSelection extends FalconeStates {
  final SelectionModel selectionModel;

  const RemovedSearchSelection({required this.selectionModel});

  @override
  List<Object> get props => [selectionModel];
}

class CalculatingTimeToReach extends FalconeStates {}

class CalculatedTimeToReach extends FalconeStates {
  final int timeTaken;

  const CalculatedTimeToReach({required this.timeTaken});

  @override
  List<Object> get props => [timeTaken];
}

class SomeThingWentWrong extends FalconeStates {}
