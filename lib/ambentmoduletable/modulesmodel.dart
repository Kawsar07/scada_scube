// To parse this JSON data, do
//
//     final moduleTemperature = moduleTemperatureFromJson(jsonString);

import 'dart:convert';

List<ModuleTemperature> moduleTemperatureFromJson(String str) => List<ModuleTemperature>.from(json.decode(str).map((x) => ModuleTemperature.fromJson(x)));

String moduleTemperatureToJson(List<ModuleTemperature> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleTemperature {
  DateTime? time;
  int? moduleTemperature;

  ModuleTemperature({
    this.time,
    this.moduleTemperature,
  });

  factory ModuleTemperature.fromJson(Map<String, dynamic> json) => ModuleTemperature(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    moduleTemperature: json["moduleTemperature"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "moduleTemperature": moduleTemperature,
  };
}
