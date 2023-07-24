import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scada_scube/TimeGraph/linenetwork.dart';
import 'package:scada_scube/home_page/view/inmodel/radiation_model.dart';
import 'package:scada_scube/live_power/livepowerModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  State<ChartsScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartsScreen> {
  List<Livepower> livepower = [];
  List<LiveRadiation> radiation = [];
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();
  ChartSeriesController? _chartSeriesController;
  Timer? timer;
  int count = 10;

  // Stream<int> _refreshStream = Stream<int>.periodic(
  //   const Duration(seconds: 5), // Change the duration according to your needs
  //       (count) => count,
  // );
  @override
  void initState() {
    super.initState();
    getData();
    setData();
    timer = Timer.periodic(const Duration(seconds: 5), _updateDataSource);
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  void _updateDataSource(Timer timer) async {
    var powerResponse = await _networkHelper.get("http://103.149.143.33:8081/api/LiveAcDcPower");
    var radiationResponse = await _networkHelper.get("http://103.149.143.33:8081/api/LiveRadiation");

    List<Livepower> powerData = livepowerFromJson(powerResponse.body);
    List<LiveRadiation> radiationData = liveRadiationFromJson(radiationResponse.body);

    setState(() {
      final random = math.Random();
      livepower = powerData; // Update the livepower list with the new data
      radiation = radiationData; // Update the radiation list with the new data

      livepower.add(Livepower(
        time: DateTime.now(),
        liveAcPower: (10.0 + random.nextDouble() * (100.0 - 10.0)),
        liveDcPower: (10.0 + random.nextDouble() * (100.0 - 10.0)),
      ));

      radiation.add(LiveRadiation(
        time: DateTime.now(),
        east: (random.nextDouble() * 2000),
        west: (random.nextDouble() * 2000),
        north: (random.nextDouble() * 2000),
        south: (random.nextDouble() * 2000),
        southF: (random.nextDouble() * 2000).toInt(),
      ));

      if (livepower.length > 20) {
        livepower.removeAt(0);
      }

      if (radiation.length > 20) {
        radiation.removeAt(0);
      }

      _chartSeriesController?.updateDataSource();
    });
  }


  void setData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/LiveRadiation");
    List<LiveRadiation> tempdatas = liveRadiationFromJson(response.body);
    setState(() {
      radiation = tempdatas.sublist(tempdatas.length - 14);
      loading = false;
    });
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
              // DateTimeCategoryAxis(
              //   name: 'xAxi',
              //   interval: 1,
              //   dateFormat: DateFormat.d(),
              //   title: AxisTitle(text: 'Power'),
              // ),
              NumericAxis(
                name: 'yAxi',
                numberFormat: NumberFormat('#,##0'),
                minimum: 0,
                maximum: 1650,
                title: AxisTitle(text: 'Power'),
opposedPosition: true,
              ),
            ],
            primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat.d(),
              intervalType: DateTimeIntervalType.days,
              interval: 1,
              name: 'xAxiss',
              maximumLabels: 10, // Show only 20 labels on the X-axis
            ),

            // primaryYAxis: NumericAxis(
            //     name: 'yAxiss',
            //     opposedPosition: true,
            //     minimum: 0,
            //     maximum: 1650,
            //     numberFormat: NumberFormat('#,##0'),
            //
            //     title: AxisTitle(text: 'Radiation')),
            enableSideBySideSeriesPlacement: false,
            series: <ChartSeries>[
              SplineSeries<Livepower, DateTime>(
                  dataSource: livepower,
                  color: Color.fromARGB(255, 126, 184, 253),
                  opacity: 1,
                  splineType: SplineType.cardinal,
                  // cardinalSplineTension: 13.8,
                  xValueMapper: (Livepower ch, _) => ch.time,
                  yValueMapper: (Livepower ch, _) => ch.liveAcPower,
                  name: 'Power',
                  xAxisName: 'xAxi',
                  yAxisName: 'yAxi'),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.east,
                color: Colors.deepPurple,
                name: 'Radiation East',
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.west,
                color: Colors.cyan,
                name: 'Radiation West',
                opacity: 1,
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
              ),
              SplineSeries<LiveRadiation, DateTime>(
                opacity: 1,
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.north,
                color: Colors.amberAccent,
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
                name: 'Radiation North',
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.south,
                color: Colors.pink,
                opacity: 1,
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                name: 'Radiation South',
              ),
              SplineSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                opacity: 1,
                xAxisName: 'xAxiss',
                yAxisName: 'yAxiss',
                splineType: SplineType.cardinal,
                cardinalSplineTension: 13.8,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.southF,
                color: Colors.deepOrange,
                name: 'Radiation South 15°',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Charts2 extends StatefulWidget {
  const Charts2({Key? key}) : super(key: key);

  @override
  State<Charts2> createState() => _Charts2State();
}

class _Charts2State extends State<Charts2> {
  List<Generation> inverter = [];
  ChartSeriesController? _chartSeriesController;
  Timer? timer;
  int count = 10;
  late SelectionBehavior _selectionBehavior;
  List<Generation> generation = [];
  bool loading = true;
  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);

    getData();
    _selectionBehavior = SelectionBehavior(
        // Enables the selection
        enable: true);

  }



  Future<void> getData() async {
    try {
      var response = await http
          .get(Uri.parse("http://103.149.143.33:8081/api/GenerationGraph"));
      if (response.statusCode == 200) {
        List<Generation> allData = generationFromJson(response.body);
        List<Generation> lastTwoData = allData.sublist(allData.length - 1);

        setState(() {
          inverter =
              lastTwoData; // Assign the last two data from the API response to the inverter variable
          loading = false;
        });

        print('Last two API data: $lastTwoData');
        // Use the last two data in your application as needed
      } else {
        // Handle API error
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server error
      print('Error occurred while making API request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime startDate = DateTime(now.year, now.month, now.day, 6, 0, 0);
    // DateTime endDate = DateTime(now.year, now.month, now.day, 19, 0, 0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,

                  // legend: Legend(
                  //   position: LegendPosition.top,
                  //   isVisible: true,
                  // ),
                  selectionType: SelectionType.cluster,
                  primaryYAxis: NumericAxis(
                    isVisible: true, // Hide the y-axis line and labels
                    labelFormat:
                        '{value}', // Remove any formatting for the y-axis labels
                  ),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('hh:mm'),
                    isVisible: false, // Set the X-axis to be invisible
                    interval: 1,
                    // Set the interval to 1 hour
                  ),

                  series: <ChartSeries<Generation, DateTime>>[
                    ColumnSeries<Generation, DateTime>(
                      enableTooltip: true,
                      name: '6am',
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      color: Colors.deepPurple,
                      selectionBehavior: _selectionBehavior,
                      dataSource: inverter,
                      xValueMapper: (Generation data, _) => data.time,
                      yValueMapper: (Generation data, _) => data.h6Am,
                    ),
                    ColumnSeries<Generation, DateTime>(
                      name: '7am',
                      enableTooltip: true,

                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      selectionBehavior: _selectionBehavior,
                      dataSource: inverter,
                      color: Colors.deepPurple,
                      xValueMapper: (Generation data, _) => data.time,
                      yValueMapper: (Generation data, _) => data.h7Am,
                    ),
                    ColumnSeries<Generation, DateTime>(
                        name: '8am',
                        enableTooltip: true,

                        selectionBehavior: _selectionBehavior,
                        dataSource: inverter,
                        color: Colors.orange,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h8Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '9am',
                        color: Colors.deepPurple,
                        dataSource: inverter,
                        enableTooltip: true,

                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        selectionBehavior: _selectionBehavior,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h9Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '10am',
                        enableTooltip: true,

                        color: Colors.deepOrange,
                        selectionBehavior: _selectionBehavior,
                        dataSource: inverter,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h10Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '11am',
                        enableTooltip: true,
                        dataLabelSettings:
                        const DataLabelSettings(isVisible: true),
                        dataSource: inverter,
                        color: Colors.blue,
                        selectionBehavior: _selectionBehavior,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h11Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '12pm',
                        enableTooltip: true,

                        color: Colors.deepPurple,
                        opacity: 1,
                        selectionBehavior: _selectionBehavior,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: inverter,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h12Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '1pm',
                        enableTooltip: true,

                        color: Colors.purpleAccent,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: inverter,
                        selectionBehavior: _selectionBehavior,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h1Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '2pm',
                        enableTooltip: true,

                        color: Colors.green,
                        selectionBehavior: _selectionBehavior,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: inverter,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h2Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '3pm',
                        enableTooltip: true,

                        dataSource: inverter,
                        selectionBehavior: _selectionBehavior,
                        color: Colors.deepPurple,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h3Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '4pm',
                        enableTooltip: true,

                        selectionBehavior: _selectionBehavior,
                        color: Colors.blue,
                        opacity: 1,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: inverter,

                        // enableTooltip: true,

                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h4Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '5pm',
                        enableTooltip: true,

                        dataSource: inverter,
                        color: Colors.deepPurple,
                        selectionBehavior: _selectionBehavior,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h5Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '6pm',
                        enableTooltip: true,

                        color: Colors.lime,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: inverter,
                        selectionBehavior: _selectionBehavior,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h6Pm),
                    ColumnSeries<Generation, DateTime>(
                        dataSource: inverter,
                        enableTooltip: true,

                        selectionBehavior: _selectionBehavior,
                        color: Colors.deepPurple,
                        name: '7pm',
                        // splineType: SplineType.cardinal,
                        // cardinalSplineTension: 13.8,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h7Pm),
                  ],
                ),
              ),
      ),
    );
  }
}

class Generation {
  DateTime time;
  int todaysGeneration;
  int h6Am;
  int h7Am;
  int h8Am;
  int h9Am;
  int h10Am;
  int h11Am;
  int h12Pm;
  int h1Pm;
  int h2Pm;
  int h3Pm;
  int h4Pm;
  int h5Pm;
  int h6Pm;
  int h7Pm;

  Generation({
    required this.time,
    required this.todaysGeneration,
    required this.h6Am,
    required this.h7Am,
    required this.h8Am,
    required this.h9Am,
    required this.h10Am,
    required this.h11Am,
    required this.h12Pm,
    required this.h1Pm,
    required this.h2Pm,
    required this.h3Pm,
    required this.h4Pm,
    required this.h5Pm,
    required this.h6Pm,
    required this.h7Pm,
  });
}

List<Generation> generationFromJson(String jsonString) {
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData
      .map((item) => Generation(
            time: DateTime.parse(item['time']),
            todaysGeneration: item['todaysGeneration'],
            h6Am: item['h6Am'],
            h7Am: item['h7Am'],
            h8Am: item['h8Am'],
            h9Am: item['h9Am'],
            h10Am: item['h10Am'],
            h11Am: item['h11Am'],
            h12Pm: item['h12Pm'],
            h1Pm: item['h1Pm'],
            h2Pm: item['h2Pm'],
            h3Pm: item['h3Pm'],
            h4Pm: item['h4Pm'],
            h5Pm: item['h5Pm'],
            h6Pm: item['h6Pm'],
            h7Pm: item['h7Pm'],
          ))
      .toList();
}

class Charts3 extends StatefulWidget {
  const Charts3({Key? key}) : super(key: key);

  @override
  State<Charts3> createState() => _Charts3State();
}

class _Charts3State extends State<Charts3> {
  List<Generation> inverter = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var response = await http
          .get(Uri.parse("http://103.149.143.33:8081/api/GenerationGraph"));
      if (response.statusCode == 200) {
        List<Generation> tempData = generationFromJson(response.body);
        setState(() {
          if (tempData.length >= 5) {
            inverter = tempData.sublist(tempData.length -
                5); // Take the last 5 values from the API response
          } else {
            inverter =
                tempData; // If there are less than 5 values, use all the values from the API response
          }
          loading = false;
        });
      } else {
        // Handle API error
        print('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or server error
      print('Error occurred while making API request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // DateTime now = DateTime.now();
    // DateTime startDate = DateTime(now.year, now.month, now.day, 6, 0, 0);
    // DateTime endDate = DateTime(now.year, now.month, now.day, 19, 0, 0);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: SfCartesianChart(
                  legend: Legend(isVisible: true, position: LegendPosition.top),
                  primaryYAxis: CategoryAxis(
                    labelRotation: -45,
                    title: AxisTitle(text: ' '),
                  ),
                  primaryXAxis: DateTimeAxis(
                    // minimum: startDate,
                    // maximum: endDate,
                    dateFormat: DateFormat('hh:mm'),
                    interval: 1, // Set the interval to 1 hour
                  ),
                  series: <ChartSeries<Generation, DateTime>>[
                    ColumnSeries<Generation, DateTime>(
                      name: 'Todays Generation',
                      // trackBorderWidth: 2,
                      // spacing: 0.2,

                      // dataLabelSettings: DataLabelSettings(isVisible: true),

                      dataSource: inverter,
                      color: Colors.deepPurple,

                      xValueMapper: (Generation data, _) => data.time,
                      yValueMapper: (Generation data, _) =>
                          data.todaysGeneration,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
