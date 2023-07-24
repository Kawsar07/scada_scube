import 'dart:convert';

List<TotalPr> totalPrFromJson(String str) => List<TotalPr>.from(json.decode(str).map((x) => TotalPr.fromJson(x)));

String totalPrToJson(List<TotalPr> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TotalPr {
  DateTime? time;
  double? shed14;
  double? shed18;
  double? shed17;
  double? floatingShed;
  double? allInverters;

  TotalPr({
    this.time,
    this.shed14,
    this.shed18,
    this.shed17,
    this.floatingShed,
    this.allInverters,
  });

  factory TotalPr.fromJson(Map<String, dynamic> json) => TotalPr(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    shed14: json["shed14"]?.toDouble(),
    shed18: json["shed18"]?.toDouble(),
    shed17: json["shed17"]?.toDouble(),
    floatingShed: json["floatingShed"]?.toDouble(),
    allInverters: json["allInverters"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "shed14": shed14,
    "shed18": shed18,
    "shed17": shed17,
    "floatingShed": floatingShed,
    "allInverters": allInverters,
  };
}
