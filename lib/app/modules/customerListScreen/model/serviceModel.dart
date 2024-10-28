

import 'dart:convert';

CustomerServiceModel serviceModelFromJson(String str) => CustomerServiceModel.fromJson(json.decode(str));

String serviceModelToJson(CustomerServiceModel data) => json.encode(data.toJson());

class CustomerServiceModel {
  bool? success;
  List<CustomerService >? services;
  String? msg;

  CustomerServiceModel({
    this.success,
    this.services,
    this.msg,
  });

  factory CustomerServiceModel.fromJson(Map<String, dynamic> json) => CustomerServiceModel(
    success: json["success"],
    services: json["services"] == null ? [] : List<CustomerService >.from(json["services"]!.map((x) => CustomerService .fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class CustomerService  {
  String? id;
  String? name;

  CustomerService ({
    this.id,
    this.name,
  });

  factory CustomerService .fromJson(Map<String, dynamic> json) => CustomerService (
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
