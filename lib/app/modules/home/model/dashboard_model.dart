// To parse this JSON data, do
//
//     final dashBoardModel = dashBoardModelFromJson(jsonString);

import 'dart:convert';

DashBoardModel dashBoardModelFromJson(String str) => DashBoardModel.fromJson(json.decode(str));

String dashBoardModelToJson(DashBoardModel data) => json.encode(data.toJson());

class DashBoardModel {
  bool? success;
  List<Lead>? lead;
  String? msg;

  DashBoardModel({
    this.success,
    this.lead,
    this.msg,
  });

  factory DashBoardModel.fromJson(Map<String, dynamic> json) => DashBoardModel(
    success: json["success"],
    lead: json["lead"] == null ? [] : List<Lead>.from(json["lead"]!.map((x) => Lead.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lead": lead == null ? [] : List<dynamic>.from(lead!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class Lead {
  String? status;
  String? count;

  Lead({
    this.status,
    this.count,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
    status: json["status"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count,
  };
}
