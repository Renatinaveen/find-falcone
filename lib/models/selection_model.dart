import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectionModel extends Model {
  List<PlanetsModel> selectedPlanets = [];
  List<VehiclesModel> selectedVehicles = [];

  SelectionModel({required this.selectedPlanets, required this.selectedVehicles});

  void addSelection(PlanetsModel planet, VehiclesModel vehicle) {
    if(selectedPlanets.length < 4) {
      if(!selectedPlanets.contains(planet)) {
        selectedPlanets.add(planet);
        selectedVehicles.add(vehicle);
        notifyListeners();
      }
    }
  }

  void removeSelection(int index) {
    selectedPlanets.removeAt(index);
    selectedVehicles.removeAt(index);
    notifyListeners();
  }

  void resetSelection() {
    selectedPlanets = [];
    selectedVehicles = [];
    notifyListeners();
  }
}
