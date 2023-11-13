class FindFalconeResponseModel {
  String? planetName;
  String? status;
  String? error;

  FindFalconeResponseModel({this.planetName, this.status, this.error});

  FindFalconeResponseModel.fromJson(Map<String, dynamic> json) {
    planetName = json['planet_name'];
    status = json['status'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planet_name'] = planetName;
    data['status'] = status;
    data['error'] = error;
    return data;
  }
}
