import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:find_falcone/models/find_falcone_response_model.dart';
import 'package:find_falcone/models/planets_model.dart';
import 'package:find_falcone/models/vehicle_model.dart';

import '../api_class.dart';

class FalconeRepository {
  Future<List<PlanetsModel>> fetchPlanets() async {
    try {
      final response = await http.get(Uri.parse(Apis().planets));
      if (!kReleaseMode) {
        debugPrint('res ${response.body}');
      }
      if (response.statusCode == 200) {
        final planets = jsonDecode(response.body) as List;
        return planets.map((e) => PlanetsModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on SocketException {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<VehiclesModel>> fetchVehicles() async {
    try {
      final response = await http.get(Uri.parse(Apis().vehicles));
      if (!kReleaseMode) {
        debugPrint('res ${response.body}');
      }
      if (response.statusCode == 200) {
        final vehicles = jsonDecode(response.body) as List;
        return vehicles.map((e) => VehiclesModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } on SocketException {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<String> getToken() async {
    String tokenResponse;
    try {
      final response = await http.post(
        Uri.parse(Apis().token),
        headers: {'Accept': 'application/json'},
      );
      if (!kReleaseMode) {
        debugPrint('res ${response.body}');
      }
      tokenResponse = response.body;
    } on SocketException {
      tokenResponse = "error";
    } catch (e) {
      tokenResponse = "error";
    }
    return tokenResponse;
  }

  Future<FindFalconeResponseModel> findFalcone(
      {required List<String?> planets, required List<String?> vehicles}) async {
    try {
      var token = await getToken();
      final response = await http.post(
        Uri.parse(Apis().find),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": jsonDecode(token)['token'],
          "planet_names": planets,
          "vehicle_names": vehicles,
        }),
      );
      if (!kReleaseMode) {
        debugPrint('res ${response.body}');
      }
      if (response.statusCode == 200) {
        return FindFalconeResponseModel.fromJson(jsonDecode(response.body));
      } else {
        return FindFalconeResponseModel(
          status: response.body,
          planetName: "",
          error: "error",
        );
      }
    } on SocketException {
      return FindFalconeResponseModel(
        status: "No Network",
        planetName: "",
        error: "error",
      );
    } catch (e) {
      return FindFalconeResponseModel(
        status: "$e",
        planetName: "",
        error: "error",
      );
    }
  }
}
