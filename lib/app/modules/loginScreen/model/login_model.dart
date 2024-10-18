// To parse this JSON data, do
//
//     final loginApi = loginApiFromJson(jsonString);

import 'dart:convert';

LoginApi loginApiFromJson(String str) => LoginApi.fromJson(json.decode(str));

String loginApiToJson(LoginApi data) => json.encode(data.toJson());

class LoginApi {
  bool? success;
  UserDetail? userdetail;
  String? msg;

  LoginApi({
    this.success,
    this.userdetail,
    this.msg,
  });

  factory LoginApi.fromJson(Map<String, dynamic> json) => LoginApi(
    success: json["success"],
    userdetail: json["userdetail"] == null ? null : UserDetail.fromJson(json["userdetail"]),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "userdetail": userdetail?.toJson(),
    "msg": msg,
  };
}

class UserDetail {
  String? the0;
  String? the1;
  String? the2;
  String? the3;
  String? the4;
  String? id;
  String? userfullname;
  String? username;
  String? userpassword;
  String? usertype;

  UserDetail({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.id,
    this.userfullname,
    this.username,
    this.userpassword,
    this.usertype,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    the0: json["0"],
    the1: json["1"],
    the2: json["2"],
    the3: json["3"],
    the4: json["4"],
    id: json["id"],
    userfullname: json["userfullname"],
    username: json["username"],
    userpassword: json["userpassword"],
    usertype: json["usertype"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
    "1": the1,
    "2": the2,
    "3": the3,
    "4": the4,
    "id": id,
    "userfullname": userfullname,
    "username": username,
    "userpassword": userpassword,
    "usertype": usertype,
  };
}
