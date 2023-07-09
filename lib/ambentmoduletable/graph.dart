import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../TimeGraph/linenetwork.dart';
import 'modulesmodel.dart';
 // Import your ModuleTemperature model

class TempGraphScreen extends StatefulWidget {
  const TempGraphScreen({Key? key}) : super(key: key);

  @override
  State<TempGraphScreen> createState() => _TempGraphScreenState();
}

class _TempGraphScreenState extends State<TempGraphScreen> {
  List<ModuleTemperature> module = [];
  late TooltipBehavior _tooltipBehavior;
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _setData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const refreshInterval = Duration(seconds: 10); // Set the refresh interval
    _timer = Timer.periodic(refreshInterval, (_) {
      _setData(); // Fetch new data periodically
    });
  }

  Future<void> _setData() async {
    try {
      var response = await _networkHelper.get("http://103.149.143.33:8081/api/TemperatureData");
      List<ModuleTemperature> tempData = moduleTemperatureFromJson(response.body);
      setState(() {
        module = tempData;
        loading = false;
      });
    } catch (e) {
      // Handle error or show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double containerSize = constraints.maxWidth < 600 ? constraints.maxWidth : 400;

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                height: containerSize,
                width: containerSize,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  legend: const Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    position: LegendPosition.top,
                  ),
                  tooltipBehavior: _tooltipBehavior,
                  palette: const <Color>[Colors.teal, Colors.orange, Colors.brown],
                  primaryXAxis: DateTimeCategoryAxis(
                    dateFormat: DateFormat('h:mm '),
                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                    labelPlacement: LabelPlacement.onTicks,
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 12,
                    maximum: 75,
                    axisLine: const AxisLine(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    labelFormat: '{value}°C',
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  series: <ChartSeries>[
                    SplineAreaSeries<ModuleTemperature, DateTime>(
                      borderWidth: 3,
                      borderColor: Colors.orange,
                      dataSource: module.length > 30 ? module.sublist(module.length - 30) : module,
                      xValueMapper: (ModuleTemperature ch, _) => ch.time,
                      yValueMapper: (ModuleTemperature ch, _) => ch.moduleTemperature,
                      markerSettings: const MarkerSettings(isVisible: true),
                      name: 'Module Temperature',
                      animationDuration: 1000,
                      enableTooltip: true,
                      color: Colors.deepPurple,
                      opacity: 1,
                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 13.8,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
