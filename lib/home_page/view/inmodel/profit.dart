class Profit {
  DateTime? time;
  double? grossProfit;
  double? nawabSaving;
  double? co2Savings;

  Profit({
    this.time,
    this.grossProfit,
    this.nawabSaving,
    this.co2Savings,
  });

  factory Profit.fromJson(Map<String, dynamic> json) => Profit(
    time: json["time"] == null ? null : DateTime.parse(json["time"]),
    grossProfit: json["grossProfit"]?.toDouble(),
    nawabSaving: json["nawabSaving"]?.toDouble(),
    co2Savings: json["co2Savings"]?.toDouble(),
  );
}
