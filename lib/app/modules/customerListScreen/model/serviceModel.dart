// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  bool? success;
  List<Service>? services;
  String? msg;

  ServiceModel({
    this.success,
    this.services,
    this.msg,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    success: json["success"],
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class Service {
  String? id;
  String? name;

  Service({
    this.id,
    this.name,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
