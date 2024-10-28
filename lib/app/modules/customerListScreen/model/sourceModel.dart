// To parse this JSON data, do
//
//     final sourceModel = sourceModelFromJson(jsonString);

import 'dart:convert';

CustomerSourceModel sourceModelFromJson(String str) => CustomerSourceModel.fromJson(json.decode(str));

String sourceModelToJson(CustomerSourceModel data) => json.encode(data.toJson());

class CustomerSourceModel {
  bool? success;
  List<SourceList>? source;
  String? msg;

  CustomerSourceModel({
    this.success,
    this.source,
    this.msg,
  });

  factory CustomerSourceModel.fromJson(Map<String, dynamic> json) => CustomerSourceModel(
    success: json["success"],
    source: json["source"] == null ? [] : List<SourceList>.from(json["source"]!.map((x) => SourceList.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "source": source == null ? [] : List<dynamic>.from(source!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class SourceList {
  String? id;
  String? sourcename;

  SourceList({
    this.id,
    this.sourcename,
  });

  factory SourceList.fromJson(Map<String, dynamic> json) => SourceList(
    id: json["id"],
    sourcename: json["sourcename"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sourcename": sourcename,
  };
}
