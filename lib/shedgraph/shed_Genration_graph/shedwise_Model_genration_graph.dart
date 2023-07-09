// To parse this JSON data, do
//
//     final genarationGraph = genarationGraphFromJson(jsonString);

import 'dart:convert';

List<GenarationGraph> genarationGraphFromJson(String str) => List<GenarationGraph>.from(json.decode(str).map((x) => GenarationGraph.fromJson(x)));

String genarationGraphToJson(List<GenarationGraph> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GenarationGraph {
  DateTime? time;
  int? shed14;
  int? shed18;
  int? shed17;
  int? floatingShed;

  GenarationGraph({
    this.time,
    this.shed14,
    this.shed18,
    this.shed17,
    this.floatingShed,
  });

  factory GenarationGraph.fromJson(Map<String, dynamic> json) => GenarationGraph(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    shed14: json["shed14"],
    shed18: json["shed18"],
    shed17: json["shed17"],
    floatingShed: json["floatingShed"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "shed14": shed14,
    "shed18": shed18,
    "shed17": shed17,
    "floatingShed": floatingShed,
  };
}
