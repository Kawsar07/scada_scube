import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scada_scube/TimeGraph/linenetwork.dart';
import 'package:scada_scube/ambentmoduletable/modulesmodel.dart';
import 'package:scada_scube/analysis/planacdc_model.dart';
import 'package:scada_scube/cumulative/model/cumulative.dart';
import 'package:scada_scube/home_page/view/inmodel/radiation_model.dart';
import 'package:scada_scube/live_power/livepowerModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadiationsScreen extends StatefulWidget {
  const RadiationsScreen({Key? key}) : super(key: key);

  @override
  State<RadiationsScreen> createState() => _RadiationsScreenState();
}

class _RadiationsScreenState extends State<RadiationsScreen> {
  List<Livepower> livepower = [];
  List<LiveRadiation> radiation = [];
  TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

  List<ModuleTemperatureNew> temp = [];
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();
  ChartSeriesController? _chartSeriesController;
  Timer? timer;
  int count = 10;
  bool isLegendVisible = true;

  // Stream<int> _refreshStream = Stream<int>.periodic(
  //   const Duration(seconds: 5), // Change the duration according to your needs
  //       (count) => count,
  // );
  @override
  void initState() {
    super.initState();
    getData();
    setData();
    setDatas();
    _tooltipBehavior = TooltipBehavior(enable: true);
    // timer =
    //     Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
    // timer =
    //     Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource2);
  }

  void getData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/LiveAcDcPower");
    List<Livepower> tempdata = livepowerFromJson(response.body);
    setState(() {
      livepower = tempdata;
      loading = false;
    });
  }

  void setData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/LiveRadiation");
    List<LiveRadiation> tempdatas = liveRadiationFromJson(response.body);

    if (tempdatas.length >= 15) {
      setState(() {
        radiation = tempdatas.sublist(tempdatas.length - 15);
        loading = false;
      });
    } else {
      // Handle the case when there are fewer than 15 elements in tempdatas.
      // For example, you could set radiation to the entire tempdatas list:
      setState(() {
        radiation = tempdatas;
        loading = false;
      });
    }
  }

  Future<void> setDatas() async {
    try {
      var response = await _networkHelper
          .get("http://103.149.143.33:8081/api/TemperatureData");

      List<ModuleTemperatureNew> tempData =
          moduleTemperatureNewFromJson(response.body);

      setState(() {
        temp = tempData
            .sublist(tempData.length - 20); // Get the last 15 data points
        loading = false; // Set 'loading' variable to false
      });
    } catch (e) {}
  }

  // void setData() async {
  //   var response = await _networkHelper
  //       .get("http://103.149.143.33:8081/api/LiveRadiation");
  //   List<LiveRadiation> tempdatas = liveRadiationFromJson(response.body);
  //
  //   if (tempdatas.length > 20) {
  //     tempdatas = tempdatas.sublist(tempdatas.length - 20);
  //   }
  //
  //   if (mounted) {
  //     setState(() {
  //       radiation = tempdatas;
  //       loading = false;
  //     });
  //   }
  // }

  // void _updateDataSource(Timer timer) {
  //   setState(() {
  //     final random = math.Random();
  //     radiation.add(LiveRadiation(
  //       time: DateTime.now(),
  //     ));
  //     if (radiation.length == 21) {
  //       radiation.removeAt(0);
  //       _chartSeriesController?.updateDataSource(
  //         addedDataIndexes: <int>[radiation.length - 1],
  //         removedDataIndexes: <int>[0],
  //       );
  //     }
  //     count++;
  //   });
  // }
  //
  // void _updateDataSource2(Timer timer) {
  //   setState(() {
  //     final random = math.Random();
  //     livepower.add(Livepower(
  //       time: DateTime.now(),
  //       liveAcPower: 10.0 + random.nextDouble() * (100.0 - 10.0),
  //
  //     ));
  //     if (livepower.length == 21) {
  //       livepower.removeAt(0);
  //       _chartSeriesController?.updateDataSource(
  //         addedDataIndexes: <int>[livepower.length - 1],
  //         removedDataIndexes: <int>[0],
  //       );
  //     }
  //     count++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          height: 500,
          width: 550,
          child:  SfCartesianChart(
            tooltipBehavior: _tooltipBehavior,

            legend: Legend(
              isVisible: isLegendVisible,
              position: LegendPosition.top,
            ),
            axes: <ChartAxis>[
              DateTimeCategoryAxis(
                name: 'xAxis',
                isVisible: false,
                dateFormat: DateFormat.d(),
                desiredIntervals: 6, // Dynamically calculate the interval based on data
                title: AxisTitle(text: 'Time'),
              ),
              if (isLegendVisible)
                NumericAxis(
                  name: 'yAxiss',
                  opposedPosition: true,
                  numberFormat: NumberFormat('#,##0'),
                  desiredIntervals: 6, // Dynamically calculate the interval based on data
                  title: AxisTitle(text: 'Temperature'),
                ),
            ],
            primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat.d(),
              intervalType: DateTimeIntervalType.days,
              interval: 1,
              maximumLabels: 15,
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat('#,##0'),
              title: AxisTitle(text: 'Radiation And Power'),
            ),
            enableSideBySideSeriesPlacement: false,
            annotations: <CartesianChartAnnotation>[
              CartesianChartAnnotation(
                widget: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLegendVisible = !isLegendVisible;
                    });
                  },
                  child: Text(
                    isLegendVisible ? 'Hide Legend' : 'Show Legend',
                  ),
                ),
                region: AnnotationRegion.chart,
                x: 0, // X-coordinate of the annotation
                y: 0, // Y-coordinate of the annotation
              ),
            ],
            series: <ChartSeries>[
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                enableTooltip: true,

                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.east,
                color: Colors.deepPurple,
                name: 'Radiation East',
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 0.8,
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                enableTooltip: true,

                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.west,
                color: Colors.cyan,
                name: 'Radiation West',
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
              ),
              SplineSeries<LiveRadiation, DateTime>(
                opacity: 1,
                enableTooltip: true,

                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.north,
                color: Colors.amberAccent,
                name: 'Radiation North',
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                enableTooltip: true,

                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.south,
                color: Colors.pink,
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                name: 'Radiation South',
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                opacity: 1,
                enableTooltip: true,

                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.southF,
                color: Colors.deepOrange,
                name: 'Radiation South 15°',
              ),
              SplineSeries<Livepower, DateTime>(
                dataSource: livepower,
                color: Color.fromARGB(255, 126, 184, 253),
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 0.8,
                xValueMapper: (Livepower ch, _) => ch.time,
                yValueMapper: (Livepower ch, _) => ch.liveAcPower,
                name: 'Power',
                xAxisName: 'xAxis',
                enableTooltip: true,

                yAxisName: 'yAxis',
              ),
              SplineSeries<ModuleTemperatureNew, DateTime>(
                dataSource: temp,
                color: Colors.indigo,
                opacity: 1,
                enableTooltip: true,

                splineType: SplineType.cardinal,
                cardinalSplineTension: 0.8,
                xValueMapper: (ModuleTemperatureNew ch, _) => ch.time,
                yValueMapper: (ModuleTemperatureNew ch, _) =>
                ch.moduleTemperature,
                name: 'Temperature',
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
              ),
            ],
          ),
        ),
      ])),
    );
  }
}

class ChartsScreens extends StatefulWidget {
  const ChartsScreens({Key? key}) : super(key: key);

  @override
  State<ChartsScreens> createState() => _ChartsScreensState();
}

class _ChartsScreensState extends State<ChartsScreens> {
  List<PlantAcdc> plantAcdc = [];
  List<Cumulative> cumulative = [];
  List<ModuleTemperatureNew> temp = [];
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();
  ChartSeriesController? _chartSeriesController;
  Timer? timer;
  int count = 10;
  bool isLegendVisible = true;

  // Stream<int> _refreshStream = Stream<int>.periodic(
  //   const Duration(seconds: 5), // Change the duration according to your needs
  //       (count) => count,
  // );
  @override
  void initState() {
    super.initState();
    getPlant();
    getcumu();
    gettemp();
    // timer =
    //     Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
    // timer =
    //     Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource2);
  }

  void getPlant() async {
    var response =
        await _networkHelper.get("http://103.149.143.33:8081/api/PlantAcdc");
    List<PlantAcdc> temp = plantAcdcFromJson(response.body);
    if (temp.isNotEmpty) {
      setState(() {
        plantAcdc = temp
            .sublist(max(0, temp.length - 10)); // Show the last 10 data points
        loading = false;
      });
    }
  }

  void getcumu() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/CumulativeDatas");
    List<Cumulative> tempdatas = cumulativeFromJson(response.body);
    if (tempdatas.isNotEmpty) {
      setState(() {
        cumulative = tempdatas.sublist(
            max(0, tempdatas.length - 10)); // Show the last 10 data points
        loading = false;
      });
    }
  }

  Future<void> gettemp() async {
    try {
      var response = await _networkHelper
          .get("http://103.149.143.33:8081/api/TemperatureData");
      List<ModuleTemperatureNew> tempData =
          moduleTemperatureNewFromJson(response.body);
      if (tempData.isNotEmpty) {
        setState(() {
          temp = tempData.sublist(
              max(0, tempData.length - 10)); // Show the last 10 data points
          loading = false;
        });
      }
    } catch (e) {
      // Handle error or show error message
    }
  }

  // void setData() async {
  //   var response = await _networkHelper
  //       .get("http://103.149.143.33:8081/api/LiveRadiation");
  //   List<LiveRadiation> tempdatas = liveRadiationFromJson(response.body);
  //
  //   if (tempdatas.length > 20) {
  //     tempdatas = tempdatas.sublist(tempdatas.length - 20);
  //   }
  //
  //   if (mounted) {
  //     setState(() {
  //       radiation = tempdatas;
  //       loading = false;
  //     });
  //   }
  // }

  // void _updateDataSource(Timer timer) {
  //   setState(() {
  //     final random = math.Random();
  //     radiation.add(LiveRadiation(
  //       time: DateTime.now(),
  //     ));
  //     if (radiation.length == 21) {
  //       radiation.removeAt(0);
  //       _chartSeriesController?.updateDataSource(
  //         addedDataIndexes: <int>[radiation.length - 1],
  //         removedDataIndexes: <int>[0],
  //       );
  //     }
  //     count++;
  //   });
  // }
  //
  // void _updateDataSource2(Timer timer) {
  //   setState(() {
  //     final random = math.Random();
  //     livepower.add(Livepower(
  //       time: DateTime.now(),
  //       liveAcPower: 10.0 + random.nextDouble() * (100.0 - 10.0),
  //
  //     ));
  //     if (livepower.length == 21) {
  //       livepower.removeAt(0);
  //       _chartSeriesController?.updateDataSource(
  //         addedDataIndexes: <int>[livepower.length - 1],
  //         removedDataIndexes: <int>[0],
  //       );
  //     }
  //     count++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 550,
          child: SfCartesianChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.top,
            ),
            axes: <ChartAxis>[
              DateTimeCategoryAxis(
                name: 'xAxis',
                // opposedPosition: true,

                interval: 1,
                dateFormat: DateFormat.d(),
                title: AxisTitle(text: 'Radiation'),
              ),
              NumericAxis(
                name: 'yAxis',
                numberFormat: NumberFormat('#,##0'),
                minimum: 0,
                maximum: 2000,
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
                opposedPosition: true,
                numberFormat: NumberFormat('#,##0'),
                title: AxisTitle(text: 'Radiation')),
            enableSideBySideSeriesPlacement: false,
            series: <ChartSeries>[
              SplineSeries<ModuleTemperatureNew, DateTime>(
                dataSource: temp,
                xValueMapper: (ModuleTemperatureNew ch, _) => ch.time,
                yValueMapper: (ModuleTemperatureNew ch, _) =>
                    ch.moduleTemperature,
                color: Colors.deepPurple,
                name: 'Module Temperature',
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
              ),
              SplineSeries<PlantAcdc, DateTime>(
                  dataSource: plantAcdc,
                  xValueMapper: (PlantAcdc ch, _) => ch.time,
                  yValueMapper: (PlantAcdc ch, _) => ch.plantAcPower,
                  color: Colors.cyan,
                  name: 'Plant Ac Power',
                  opacity: 1,
                  splineType: SplineType.cardinal,
                  cardinalSplineTension: 13.8,
                  xAxisName: 'xAxiss',
                  yAxisName: 'yAxiss'),
              SplineSeries<Cumulative, DateTime>(
                  opacity: 1,
                  splineType: SplineType.cardinal,
                  cardinalSplineTension: 13.8,
                  dataSource: cumulative,
                  xValueMapper: (Cumulative ch, _) => ch.time,
                  yValueMapper: (Cumulative ch, _) => ch.cumulativePoaAvg,
                  color: Colors.amberAccent,
                  name: 'Radiation',
                  xAxisName: 'xAxis',
                  yAxisName: 'yAxis'),
            ],
          ),
        ),
      ),
    );
  }
}
