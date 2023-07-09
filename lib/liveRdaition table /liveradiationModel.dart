// To parse this JSON data, do
//
//     final liveRadiation = liveRadiationFromJson(jsonString);

// To parse this JSON data, do
//
//     final liveRadiation = liveRadiationFromJson(jsonString);

import 'dart:convert';

List<LiveRadiation> liveRadiationFromJson(String str) => List<LiveRadiation>.from(json.decode(str).map((x) => LiveRadiation.fromJson(x)));

String liveRadiationToJson(List<LiveRadiation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LiveRadiation {
  DateTime? time;
  double? east;
  double? west;
  double? north;
  double? south;
  int? southF;

  LiveRadiation({
    this.time,
    this.east,
    this.west,
    this.north,
    this.south,
    this.southF,
  });

  factory LiveRadiation.fromJson(Map<String, dynamic> json) => LiveRadiation(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    east: json["east"]?.toDouble(),
    west: json["west"]?.toDouble(),
    north: json["north"]?.toDouble(),
    south: json["south"]?.toDouble(),
    southF: json["southF"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "east": east,
    "west": west,
    "north": north,
    "south": south,
    "southF": southF,
  };
}
