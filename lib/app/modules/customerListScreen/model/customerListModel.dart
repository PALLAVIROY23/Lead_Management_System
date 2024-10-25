import 'dart:convert';

CustomerStatusListModel customerStatusListFromJson(String str) => CustomerStatusListModel.fromJson(json.decode(str));

String customerStatusListToJson(CustomerStatusListModel data) => json.encode(data.toJson());

class CustomerStatusListModel {
  bool? success;
  List<LeadData>? lead;
  String? msg;

  CustomerStatusListModel({
    this.success,
    this.lead,
    this.msg,
  });

  factory CustomerStatusListModel.fromJson(Map<String, dynamic> json) => CustomerStatusListModel(
    success: json["success"],
    lead: json["lead"] == null ? [] : List<LeadData>.from(json["lead"]!.map((x) => LeadData.fromJson(x))),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "lead": lead == null ? [] : List<dynamic>.from(lead!.map((x) => x.toJson())),
    "msg": msg,
  };
}

class LeadData {
  String? the0;
  String? the1;
  String? the2;
  String? the3;
  String? the4;
  String? the5;
  String? the6;
  String? the7;
  String? the8;
  The9? the9; // Using Enum
  String? the10;
  String? the11;
  String? the12;
  String? the13;
  String? the14;
  String? the15;
  String? the16;
  String? id;
  String? name;
  String? email;
  String? mobile;
  String? alternatemobile;
  String? companyname;
  String? websiteurl;
  String? address;
  String? userassigned;
  String? status;
  String? followupdate;
  String? lastupdate;
  String? comments;
  String? industry;
  String? city;
  String? source;
  String? service;

  LeadData({
    this.the0,
    this.the1,
    this.the2,
    this.the3,
    this.the4,
    this.the5,
    this.the6,
    this.the7,
    this.the8,
    this.the9,
    this.the10,
    this.the11,
    this.the12,
    this.the13,
    this.the14,
    this.the15,
    this.the16,
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.alternatemobile,
    this.companyname,
    this.websiteurl,
    this.address,
    this.userassigned,
    this.status,
    this.followupdate,
    this.lastupdate,
    this.comments,
    this.industry,
    this.city,
    this.source,
    this.service,
  });

  factory LeadData.fromJson(Map<String, dynamic> json) => LeadData(
    the0: json["0"],
    the1: json["1"],
    the2: json["2"],
    the3: json["3"],
    the4: json["4"],
    the5: json["5"],
    the6: json["6"],
    the7: json["7"],
    the8: json["8"],
    the9: json["9"] == null ? null : the9Values.map[json["9"]],
    the10: json["10"],
    the11: json["11"],
    the12: json["12"],
    the13: json["13"],
    the14: json["14"],
    the15: json["15"],
    the16: json["16"],
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    alternatemobile: json["alternatemobile"],
    companyname: json["companyname"],
    websiteurl: json["websiteurl"],
    address: json["address"],
    userassigned: json["userassigned"],
    status: json["status"],
    followupdate: json["followupdate"],
    lastupdate: json["lastupdate"],
    comments: json["comments"],
    industry: json["industry"],
    city: json["city"],
    source: json["source"],
    service: json["service"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
    "1": the1,
    "2": the2,
    "3": the3,
    "4": the4,
    "5": the5,
    "6": the6,
    "7": the7,
    "8": the8,
    "9": the9 == null ? null : the9Values.reverse[the9],
    "10": the10,
    "11": the11,
    "12": the12,
    "13": the13,
    "14": the14,
    "15": the15,
    "16": the16,
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "alternatemobile": alternatemobile,
    "companyname": companyname,
    "websiteurl": websiteurl,
    "address": address,
    "userassigned": userassigned,
    "status": status,
    "followupdate": followupdate,
    "lastupdate": lastupdate,
    "comments": comments,
    "industry": industry,
    "city": city,
    "source": source,
    "service": service,
  };
}

enum The9 {
  RINGING,
}

final the9Values = EnumValues({
  "Ringing": The9.RINGING,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
