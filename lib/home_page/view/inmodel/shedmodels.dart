// To parse this JSON data, do
//
//     final shedWiseGenerationGraph = shedWiseGenerationGraphFromJson(jsonString);

import 'dart:convert';

List<ShedWiseGenerationGraph> shedWiseGenerationGraphFromJson(String str) => List<ShedWiseGenerationGraph>.from(json.decode(str).map((x) => ShedWiseGenerationGraph.fromJson(x)));

String shedWiseGenerationGraphToJson(List<ShedWiseGenerationGraph> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShedWiseGenerationGraph {
  ShedWiseGenerationGraph({
    this.time,
    this.shed1,
    this.shed2,
    this.shed3And4,
    this.shed5,
    this.shed6,
    this.shed7,
    this.shed8,
    this.shed10,
    this.shed11,
    this.shed12,
  });

  DateTime? time;
  int? shed1;
  int? shed2;
  int? shed3And4;
  int? shed5;
  int? shed6;
  int? shed7;
  int? shed8;
  int? shed10;
  int? shed11;
  int? shed12;

  factory ShedWiseGenerationGraph.fromJson(Map<String, dynamic> json) => ShedWiseGenerationGraph(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    shed1: json["shed1"],
    shed2: json["shed2"],
    shed3And4: json["shed3And4"],
    shed5: json["shed5"],
    shed6: json["shed6"],
    shed7: json["shed7"],
    shed8: json["shed8"],
    shed10: json["shed10"],
    shed11: json["shed11"],
    shed12: json["shed12"],
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "shed1": shed1,
    "shed2": shed2,
    "shed3And4": shed3And4,
    "shed5": shed5,
    "shed6": shed6,
    "shed7": shed7,
    "shed8": shed8,
    "shed10": shed10,
    "shed11": shed11,
    "shed12": shed12,
  };
}