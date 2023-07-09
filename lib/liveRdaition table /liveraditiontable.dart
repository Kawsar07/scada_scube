import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scada_scube/liveRdaition%20table%20/liveradiationModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../TimeGraph/linenetwork.dart';

class RaditionGraphScreen extends StatefulWidget {
  const RaditionGraphScreen({Key? key}) : super(key: key);

  @override
  State<RaditionGraphScreen> createState() => _RaditionGraphScreenState();
}

class _RaditionGraphScreenState extends State<RaditionGraphScreen> {
  List<LiveRadiation> radition = [];
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
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (_) {
      _setData();
    });
  }

  Future<void> _setData() async {
    try {
      var response = await _networkHelper.get("http://103.149.143.33:8081/api/LiveRadiation");
      List<LiveRadiation> tempData = liveRadiationFromJson(response.body);
      setState(() {
        radition = tempData;
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
              // Set width to occupy the available space
              height: double.infinity,
              // Set height to occupy the available space
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
                  tooltipBehavior: TooltipBehavior(enable: true),
                  palette: const <Color>[
                    Colors.teal,
                    Colors.orange,
                    Colors.brown
                  ],
                  primaryXAxis: DateTimeCategoryAxis(
                    dateFormat: DateFormat('h:mm '),
                    visibleMinimum: DateTime.now().subtract(Duration(minutes: 2)), // Set visibleMinimum to 2 minutes behind the current time
                    interval: 1,
                    majorGridLines: const MajorGridLines(width: 0),
                    labelPlacement: LabelPlacement.onTicks,
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 12,
                    maximum: 75,
                    axisLine: const AxisLine(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    majorTickLines: const MajorTickLines(size: 0),
                  ),
                  series: <ChartSeries>[
                 SplineAreaSeries<LiveRadiation, DateTime>(
                // borderWidth: 3,
                // borderColor: Colors.orange,
                dataSource: radition,
                // borderWidth: 3,
                // borderColor: Colors.orange,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.east,
                markerSettings: const MarkerSettings(isVisible: true),
                name: 'East',
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.red,
                opacity: 1,
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 13.8,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                    ColumnSeries<LiveRadiation, DateTime>(
                    // borderWidth: 3,
                    // borderColor: Colors.orange,
                    dataSource: radition,
                    xValueMapper: (LiveRadiation ch, _) => ch.time,
                    yValueMapper: (LiveRadiation ch, _) => ch.west,
                    markerSettings: const MarkerSettings(isVisible: true),
                    name: 'West',
                    // animationDuration: 1000,
                    // enableTooltip: true,
                    color: Colors.blue,

                    // opacity: 1,
                    // splineType: SplineType.cardinal,
                    // cardinalSplineTension: 13.8,
                    // dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                    ColumnSeries<LiveRadiation, DateTime>(
                    // borderWidth: 3,
                    // borderColor: Colors.orange,
                      dataSource: radition,
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.north,
                      markerSettings: const MarkerSettings(isVisible: true),
                      name: 'North',
                      animationDuration: 1000,
                      enableTooltip: true,
                      color: Colors.lime,
                      opacity: 1,

                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                    ColumnSeries<LiveRadiation, DateTime>(
                  // borderWidth: 3,
                  // borderColor: Colors.orange,
                  dataSource: radition,
                  xValueMapper: (LiveRadiation ch, _) => ch.time,
                  yValueMapper: (LiveRadiation ch, _) => ch.south,
                  markerSettings: const MarkerSettings(isVisible: true),
                  name: 'South',
                  animationDuration: 1000,
                  enableTooltip: true,
                  color: Colors.red,
                  opacity: 1,
                  // splineType: SplineType.cardinal,
                  // cardinalSplineTension: 13.8,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
                   ColumnSeries<LiveRadiation, DateTime>(
                  // borderWidth: 3,
                  // borderColor: Colors.orange,
                  dataSource: radition,
                  xValueMapper: (LiveRadiation ch, _) => ch.time,
                  yValueMapper: (LiveRadiation ch, _) => ch.southF,
                  markerSettings: const MarkerSettings(isVisible: true),
                  name: 'South 15°',
                  animationDuration: 1000,
                  enableTooltip: true,
                  color: Colors.green,
                  opacity: 1,
                  // splineType: SplineType.cardinal,
                  // cardinalSplineTension: 13.8,
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