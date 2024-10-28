// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

import 'dart:convert';

CustomerCitiesModel citiesModelFromJson(String str) => CustomerCitiesModel.fromJson(json.decode(str));

String citiesModelToJson(CustomerCitiesModel data) => json.encode(data.toJson());

class CustomerCitiesModel {
  bool? success;
  List<CitiesData>? cities;
  String? msg;

  CustomerCitiesModel({
    this.success,
    this.cities,
    this.msg,
  });

  factory CustomerCitiesModel.fromJson(Map<String, dynamic> json) => CustomerCitiesModel(
    success: json["success"],
    cities: json["cities"] == null ? [] : List<CitiesData>.from(json["cities"]!.map((x) => CitiesData.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "cities": cities == null ? [] : List<dynamic>.from(cities!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class CitiesData {
  String? id;
  String? name;
  String? stateId;

  CitiesData({
    this.id,
    this.name,
    this.stateId,
  });

  factory CitiesData.fromJson(Map<String, dynamic> json) => CitiesData(
    id: json["id"],
    name: json["name"],
    stateId: json["state_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state_id": stateId,
  };
}
