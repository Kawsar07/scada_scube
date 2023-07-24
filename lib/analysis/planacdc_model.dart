import 'dart:convert';

List<PlantAcdc> plantAcdcFromJson(String str) => List<PlantAcdc>.from(json.decode(str).map((x) => PlantAcdc.fromJson(x)));

String plantAcdcToJson(List<PlantAcdc> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlantAcdc {
  DateTime? time;
  double? plantDcPower;
  double? plantAcPower;

  PlantAcdc({
    this.time,
    this.plantDcPower,
    this.plantAcPower,
  });

  factory PlantAcdc.fromJson(Map<String, dynamic> json) => PlantAcdc(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    plantDcPower: json["plantDcPower"]?.toDouble(),
    plantAcPower: json["plantAcPower"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "plantDcPower": plantDcPower,
    "plantAcPower": plantAcPower,
  };
}
