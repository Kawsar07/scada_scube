class TempData {
  final DateTime? time;
  final double? moduleTemperature;

  TempData({
    this.time,
    this.moduleTemperature,
  });

  factory TempData.fromJson(Map<String, dynamic> json) {
    return TempData(
      time: json["time"] == null ? null : DateTime.parse(json["time"]),
      moduleTemperature: (json["module_temperature"] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time?.toIso8601String(),
      "module_temperature": moduleTemperature,
    };
  }
}
