// To parse this JSON data, do
//
//     final livepower = livepowerFromJson(jsonString);

import 'dart:convert';

List<Livepower> livepowerFromJson(String str) => List<Livepower>.from(json.decode(str).map((x) => Livepower.fromJson(x)));

String livepowerToJson(List<Livepower> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Livepower {
  DateTime? time;
  double? liveAcPower;
  double? liveDcPower;

  Livepower({
    this.time,
    this.liveAcPower,
    this.liveDcPower,
  });

  factory Livepower.fromJson(Map<String, dynamic> json) => Livepower(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    liveAcPower: json["liveAcPower"]?.toDouble(),
    liveDcPower: json["liveDcPower"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "time": time?.toIso8601String(),
    "liveAcPower": liveAcPower,
    "liveDcPower": liveDcPower,
  };
}
