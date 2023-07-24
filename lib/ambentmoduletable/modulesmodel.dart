
// To parse this JSON data, do
//
//     final moduleTemperatureNew = moduleTemperatureNewFromJson(jsonString);

import 'dart:convert';

List<ModuleTemperatureNew> moduleTemperatureNewFromJson(String str) => List<ModuleTemperatureNew>.from(json.decode(str).map((x) => ModuleTemperatureNew.fromJson(x)));

String moduleTemperatureNewToJson(List<ModuleTemperatureNew> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleTemperatureNew {
  DateTime? time;
  int? moduleTemperature;

  ModuleTemperatureNew({
    this.time,
    this.moduleTemperature,
  });

  factory ModuleTemperatureNew.fromJson(Map<String, dynamic> json) => ModuleTemperatureNew(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    moduleTemperature: json["moduleTemperature"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "moduleTemperature": moduleTemperature,
  };
}

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
    moduleTemperature: json["module_temperature"] is double
        ? (json["module_temperature"] as double).toInt()
        : json["module_temperature"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "module_temperature": moduleTemperature,
  };
}


// To parse this JSON data, do
//
//     final moduleTemperature1 = moduleTemperature1FromJson(jsonString);



List<ModuleTemperature1> moduleTemperature1FromJson(String str) => List<ModuleTemperature1>.from(json.decode(str).map((x) => ModuleTemperature1.fromJson(x)));

String moduleTemperature1ToJson(List<ModuleTemperature1> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModuleTemperature1 {
  DateTime? time;
  int? moduleTemperature;

  ModuleTemperature1({
    this.time,
    this.moduleTemperature,
  });

  factory ModuleTemperature1.fromJson(Map<String, dynamic> json) => ModuleTemperature1(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    moduleTemperature: json["moduleTemperature"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "moduleTemperature": moduleTemperature,
  };
}
