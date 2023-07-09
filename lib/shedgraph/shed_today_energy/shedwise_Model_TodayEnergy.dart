// To parse this JSON data, do
//
//     final shedWiseTodaysEnergy = shedWiseTodaysEnergyFromJson(jsonString);

// To parse this JSON data, do
//
//     final todaysEnergy = todaysEnergyFromJson(jsonString);

import 'dart:convert';

List<TodaysEnergy> todaysEnergyFromJson(String str) => List<TodaysEnergy>.from(json.decode(str).map((x) => TodaysEnergy.fromJson(x)));

String todaysEnergyToJson(List<TodaysEnergy> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodaysEnergy {
  DateTime? time;
  int? shed14;
  int? shed18;
  int? shed17;
  int? floatingShed;
  int? todaysGeneration;

  TodaysEnergy({
    this.time,
    this.shed14,
    this.shed18,
    this.shed17,
    this.floatingShed,
    this.todaysGeneration,
  });

  factory TodaysEnergy.fromJson(Map<String, dynamic> json) => TodaysEnergy(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    shed14: json["shed14"],
    shed18: json["shed18"],
    shed17: json["shed17"],
    floatingShed: json["floatingShed"],
    todaysGeneration: json["todaysGeneration"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "shed14": shed14,
    "shed18": shed18,
    "shed17": shed17,
    "floatingShed": floatingShed,
    "todaysGeneration": todaysGeneration,
  };
}
