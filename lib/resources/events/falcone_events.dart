import 'package:equatable/equatable.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/selection_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';

abstract class FalconeEvents extends Equatable {
  const FalconeEvents();

  @override
  List<Object> get props => [];
}

class FetchPlanetsNVehicles extends FalconeEvents {}

class FetchVehicles extends FalconeEvents {}

class SearchFalcone extends FalconeEvents {
  final SelectionModel selectionModel;

  const SearchFalcone({required this.selectionModel});

  @override
  List<Object> get props => [selectionModel];
}

class AddSearchSelection extends FalconeEvents {
  final PlanetsModel planet;
  final VehiclesModel vehicle;
  final SelectionModel selectionModel;

  const AddSearchSelection(
      {required this.planet,
      required this.vehicle,
      required this.selectionModel});

  @override
  List<Object> get props => [planet, vehicle, selectionModel];
}

class RemoveSearchSelection extends FalconeEvents {
  final int index;

  const RemoveSearchSelection({required this.index});

  @override
  List<Object> get props => [index];
}

class CalculateTimeToReach extends FalconeEvents {
  final int distance;
  final int speed;

  const CalculateTimeToReach({required this.distance, required this.speed});

  @override
  List<Object> get props => [distance, speed];
}

class FindTheFalcone extends FalconeEvents {
  final SelectionModel selectionModel;

  const FindTheFalcone({required this.selectionModel});

  @override
  List<Object> get props => [selectionModel];
}
