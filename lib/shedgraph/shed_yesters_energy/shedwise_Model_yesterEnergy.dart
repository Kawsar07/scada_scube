// To parse this JSON data, do
//
//     final yesterdaysEnergy = yesterdaysEnergyFromJson(jsonString);

import 'dart:convert';

List<YesterdaysEnergy> yesterdaysEnergyFromJson(String str) => List<YesterdaysEnergy>.from(json.decode(str).map((x) => YesterdaysEnergy.fromJson(x)));

String yesterdaysEnergyToJson(List<YesterdaysEnergy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YesterdaysEnergy {
  DateTime? time;
  int? shed14;
  int? shed18;
  int? shed17;
  int? floatingShed;
  int? yesterdaysGeneration;

  YesterdaysEnergy({
    this.time,
    this.shed14,
    this.shed18,
    this.shed17,
    this.floatingShed,
    this.yesterdaysGeneration,
  });

  factory YesterdaysEnergy.fromJson(Map<String, dynamic> json) => YesterdaysEnergy(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    shed14: json["shed14"],
    shed18: json["shed18"],
    shed17: json["shed17"],
    floatingShed: json["floatingShed"],
    yesterdaysGeneration: json["yesterdaysGeneration"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "shed14": shed14,
    "shed18": shed18,
    "shed17": shed17,
    "floatingShed": floatingShed,
    "yesterdaysGeneration": yesterdaysGeneration,
  };
}
