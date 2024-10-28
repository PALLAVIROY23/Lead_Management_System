// To parse this JSON data, do
//
//     final updateDetailModel = updateDetailModelFromJson(jsonString);

import 'dart:convert';

UpdateDetailModel updateDetailModelFromJson(String str) => UpdateDetailModel.fromJson(json.decode(str));

String updateDetailModelToJson(UpdateDetailModel data) => json.encode(data.toJson());

class UpdateDetailModel {
  String? status;
  bool? success;
  String? msg;

  UpdateDetailModel({
    this.status,
    this.success,
    this.msg,
  });

  factory UpdateDetailModel.fromJson(Map<String, dynamic> json) => UpdateDetailModel(
    status: json["status"],
    success: json["success"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "msg": msg,
  };
}
