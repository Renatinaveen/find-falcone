class PlanetsModel {
  String? name;
  int? distance;

  PlanetsModel({String? name, int? distance}) {
    if (name != null) {
      name = name;
    }
    if (distance != null) {
      distance = distance;
    }
  }

  PlanetsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['distance'] = distance;
    return data;
  }
}