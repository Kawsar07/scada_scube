// To parse this JSON data, do
//
//     final cumulative = cumulativeFromJson(jsonString);

import 'dart:convert';

List<Cumulative> cumulativeFromJson(String str) => List<Cumulative>.from(json.decode(str).map((x) => Cumulative.fromJson(x)));

String cumulativeToJson(List<Cumulative> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cumulative {
  DateTime? time;
  double? cumulativePr;
  double? cumulativePoaDayAvg;
  double? cumulativePoaAvg;

  Cumulative({
    this.time,
    this.cumulativePr,
    this.cumulativePoaDayAvg,
    this.cumulativePoaAvg,
  });

  factory Cumulative.fromJson(Map<String, dynamic> json) => Cumulative(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    cumulativePr: json["cumulativePr"]?.toDouble(),
    cumulativePoaDayAvg: json["cumulativePoaDayAvg"]?.toDouble(),
    cumulativePoaAvg: json["cumulativePoaAvg"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "cumulativePr": cumulativePr,
    "cumulativePoaDayAvg": cumulativePoaDayAvg,
    "cumulativePoaAvg": cumulativePoaAvg,
  };
}
