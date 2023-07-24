import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scada_scube/liveRdaition%20table%20/liveradiationModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../TimeGraph/linenetwork.dart';
import 'dart:math' as math;

class RaditionGraphScreen extends StatefulWidget {
  const RaditionGraphScreen({Key? key}) : super(key: key);

  @override
  State<RaditionGraphScreen> createState() => _RaditionGraphScreenState();
}

class _RaditionGraphScreenState extends State<RaditionGraphScreen> {
  List<LiveRadiation> radiation = [];
  Timer? timer;
  late TooltipBehavior _tooltipBehavior;
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startUpdatingData();
    setData();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  void startUpdatingData() {
    setState(() {
      _timer = Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          updateDataSource();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void updateDataSource() async {
    try {
      var response = await _networkHelper.get("http://103.149.143.33:8081/api/LiveRadiation");
      List<LiveRadiation> liveData = liveRadiationFromJson(response.body);

      setState(() {
        radiation = liveData.sublist(liveData.length - 15);
      });

      // Restart the timer for the next update
      _timer?.cancel();
      startUpdatingData();
    } catch (e) {
      print("Error fetching live data: $e");
    }
  }


  void setData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/LiveRadiation");
    List<LiveRadiation> tempdatas =
    liveRadiationFromJson(response.body);
    setState(() {
      radiation = tempdatas.sublist(tempdatas.length - 9);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double containerSize =
            constraints.maxWidth < 600 ? constraints.maxWidth : 400;

            return SizedBox(
              width: double.infinity,
              // Set width to occupy the available space
              height: double.infinity,
              // Set height to occupy the available space
              child: Container(
                height: containerSize,
                width: containerSize,
                child: SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                  ),
                  axes: <ChartAxis>[
                    DateTimeCategoryAxis(
                      name: 'xAxis',
                      interval: 1,
                      dateFormat: DateFormat.d(),
                      title: AxisTitle(text: 'Radiation'),
                    ),
                    NumericAxis(
                      name: 'yAxis',
                      numberFormat: NumberFormat('#,##0'),
                      minimum: radiation.isNotEmpty
                          ? radiation.map((data) => data.east).reduce((a, b) => a! < b! ? a : b)
                          : 0,
                      maximum: radiation.isNotEmpty
                          ? radiation.map((data) => data.east).reduce((a, b) => a! > b! ? a : b)
                          : 100,
                      title: AxisTitle(text: 'Power'),
                    ),
                  ],
                  primaryXAxis: DateTimeCategoryAxis(
                    dateFormat: DateFormat.d(),
                    intervalType: DateTimeIntervalType.days,
                    interval: 1,
                    maximumLabels: 10, // Show only 20 labels on the X-axis
                  ),
                  primaryYAxis: NumericAxis(
                      numberFormat: NumberFormat('#,##0'),
                      title: AxisTitle(text: 'Radiation')),
                  enableSideBySideSeriesPlacement: false,
                  series: <ChartSeries>[
                    SplineSeries<LiveRadiation, DateTime>(
                      dataSource: radiation,
                      // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.east,
                      color: Colors.deepPurple,
                      name: 'Radiation East',
                      opacity: 1,
                      enableTooltip: true,

                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 13.8,
                      // markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    SplineSeries<LiveRadiation, DateTime>(
                      // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      dataSource: radiation,
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.west,
                      color: Colors.blue,
                      name: 'Radiation West',
                      opacity: 1,
                      enableTooltip: true,

                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 13.8,
                      // markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    SplineSeries<LiveRadiation, DateTime>(
                      opacity: 1,
                      // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 13.8,
                      dataSource: radiation,
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.north,
                      color: Colors.amberAccent,
                      name: 'Radiation North',
                      enableTooltip: true,
                      // markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    SplineSeries<LiveRadiation, DateTime>(
                      dataSource: radiation,
                      enableTooltip: true,
                      // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.south,
                      color: Colors.pink,
                      opacity: 1,
                      splineType: SplineType.cardinal,
                      cardinalSplineTension: 13.8,
                      name: 'Radiation South',
                      // markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    SplineSeries<LiveRadiation, DateTime>(
                      dataSource: radiation,
                      opacity: 1,
                      enableTooltip: true,
                      // dataLabelSettings: const DataLabelSettings(isVisible: true),
                      splineType: SplineType.cardinal,
                      // markerSettings: const MarkerSettings(isVisible: true),
                      cardinalSplineTension: 0.8,
                      xValueMapper: (LiveRadiation ch, _) => ch.time,
                      yValueMapper: (LiveRadiation ch, _) => ch.southF?.toDouble(),
                      color: Colors.grey,
                      name: 'Radiation South 15°',
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
