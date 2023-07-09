// To parse this JSON data, do
//
//     final generation = generationFromJson(jsonString);

import 'dart:convert';
String jsonString = '[{"time":"2023-07-07T14:30:55","todaysGeneration":3666,"h6Am":0,"h7Am":0,"h8Am":0,"h9Am":0,"h10Am":0,"h11Am":0,"h12Pm":0,"h1Pm":0,"h2Pm":0,"h3Pm":0,"h4Pm":0,"h5Pm":0,"h6Pm":0,"h7Pm":0},{"time":"2023-07-07T14:30:57","todaysGeneration":3666,"h6Am":0,"h7Am":0,"h8Am":0,"h9Am":0,"h10Am":0,"h11Am":0,"h12Pm":0,"h1Pm":0,"h2Pm":0,"h3Pm":0,"h4Pm":0,"h5Pm":0,"h6Pm":0,"h7Pm":0}]';

List<Generation> generations = generationFromJson(jsonString);

List<Generation> generationFromJson(String str) => List<Generation>.from(json.decode(str).map((x) => Generation.fromJson(x)));

String generationToJson(List<Generation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Generation {
  DateTime? time;
  int? todaysGeneration;
  int? h6Am;
  int? h7Am;
  int? h8Am;
  int? h9Am;
  int? h10Am;
  int? h11Am;
  int? h12Pm;
  int? h1Pm;
  int? h2Pm;
  int? h3Pm;
  int? h4Pm;
  int? h5Pm;
  int? h6Pm;
  int? h7Pm;

  Generation({
    this.time,
    this.todaysGeneration,
    this.h6Am,
    this.h7Am,
    this.h8Am,
    this.h9Am,
    this.h10Am,
    this.h11Am,
    this.h12Pm,
    this.h1Pm,
    this.h2Pm,
    this.h3Pm,
    this.h4Pm,
    this.h5Pm,
    this.h6Pm,
    this.h7Pm,
  });

  factory Generation.fromJson(Map<String, dynamic> json) => Generation(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    todaysGeneration: json["todaysGeneration"],
    h6Am: json["h6Am"],
    h7Am: json["h7Am"],
    h8Am: json["h8Am"],
    h9Am: json["h9Am"],
    h10Am: json["h10Am"],
    h11Am: json["h11Am"],
    h12Pm: json["h12Pm"],
    h1Pm: json["h1Pm"],
    h2Pm: json["h2Pm"],
    h3Pm: json["h3Pm"],
    h4Pm: json["h4Pm"],
    h5Pm: json["h5Pm"],
    h6Pm: json["h6Pm"],
    h7Pm: json["h7Pm"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "todaysGeneration": todaysGeneration,
    "h6Am": h6Am,
    "h7Am": h7Am,
    "h8Am": h8Am,
    "h9Am": h9Am,
    "h10Am": h10Am,
    "h11Am": h11Am,
    "h12Pm": h12Pm,
    "h1Pm": h1Pm,
    "h2Pm": h2Pm,
    "h3Pm": h3Pm,
    "h4Pm": h4Pm,
    "h5Pm": h5Pm,
    "h6Pm": h6Pm,
    "h7Pm": h7Pm,
  };
}
