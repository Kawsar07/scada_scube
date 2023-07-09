import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scada_scube/TimeGraph/linenetwork.dart';
import 'package:scada_scube/home_page/view/inmodel/radiation_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'models/genartion_graph_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({Key? key}) : super(key: key);

  @override
  State<ChartsScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartsScreen> {
  List<Generation> genaration = [];
  List<LiveRadiation> radiation = [];
  bool loading = true;
  NetworkHelper _networkHelper = NetworkHelper();

  @override
  void initState() {
    super.initState();
    getData();
    setData();
  }

  void getData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/GenerationGraph");
    List<Generation> tempdata = generationFromJson(response.body);
    setState(() {
      genaration = tempdata;
      loading = false;
    });
  }

  void setData() async {
    var response = await _networkHelper
        .get("http://103.149.143.33:8081/api/LiveRadiation");
    List<LiveRadiation> tempdatas = liveRadiationFromJson(response.body);
    if (mounted) {
      setState(() {
        radiation = tempdatas;
        loading = false;
      });
    }
  }

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
            primaryXAxis: DateTimeCategoryAxis(
              dateFormat: DateFormat.d(),
              intervalType: DateTimeIntervalType.days,
              interval: 1,
            ),
            primaryYAxis: NumericAxis(title: AxisTitle(text: 'Genaration')),
            axes: <ChartAxis>[
              DateTimeCategoryAxis(
                  name: 'xAxis',
                  // opposedPosition: true,
                  interval: 1,
                  dateFormat: DateFormat.d(),
                  title: AxisTitle(text: 'Radiation')),
              NumericAxis(
                  name: 'yAxis',
                  opposedPosition: true,
                  title: AxisTitle(text: 'Radiation')),
            ],
            enableSideBySideSeriesPlacement: false,
            series: <ChartSeries>[
              // ColumnSeries<Generation, DateTime>(
              //   dataSource: genaration,
              //   xValueMapper: (Generation ch, _) => ch.time,
              //   yValueMapper: (Generation ch, _) => ch.todaysGeneration,
              //   animationDuration: 1000,
              //   enableTooltip: true,
              //   color: Colors.orange,
              //   name: 'Genaration',
              //   // opacity: 1,
              //   // dashArray: const <double>[5, 5],
              //   // splineType: SplineType.cardinal,
              //   // cardinalSplineTension: 2.8,
              //   // dataLabelSettings: const DataLabelSettings(
              //   //   isVisible: true,
              //   // ),
              //   // spacing: 0.3
              // ),
              ColumnSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.east,
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.deepPurple,
                name: 'Radiation East',
                width: 0.9,
                // opacity: 1,
                // dashArray: const <double>[5, 5],
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 2.8,
                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                // ),
                // spacing: 0.3
              ),
              ColumnSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                width: 0.8,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.west,
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.cyan,
                name: 'Radiation West',
                // opacity: 1,
                // dashArray: const <double>[5, 5],
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 2.8,
                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                // ),
                // spacing: 0.3
              ),
              ColumnSeries<LiveRadiation, DateTime>(
                width: 0.6,
                dataSource: radiation,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.north,
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.amberAccent,
                name: 'Radiation North',
                // opacity: 1,
                // dashArray: const <double>[5, 5],
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 2.8,
                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                // ),
                // spacing: 0.3
              ),
              ColumnSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                width: 0.4,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.south,
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.pink,
                name: 'Radiation South',
                // opacity: 1,
                // dashArray: const <double>[5, 5],
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 2.8,
                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                // ),
                // spacing: 0.3
              ),
              ColumnSeries<LiveRadiation, DateTime>(
                dataSource: radiation,
                width: 0.2,
                xValueMapper: (LiveRadiation ch, _) => ch.time,
                yValueMapper: (LiveRadiation ch, _) => ch.southF,
                animationDuration: 1000,
                enableTooltip: true,
                color: Colors.blue,
                name: 'Radiation South 15°',
                // opacity: 1,
                // dashArray: const <double>[5, 5],
                // splineType: SplineType.cardinal,
                // cardinalSplineTension: 2.8,
                // dataLabelSettings: const DataLabelSettings(
                //   isVisible: true,
                // ),
                // spacing: 0.3
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

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var response = await http.get(Uri.parse("http://103.149.143.33:8081/api/GenerationGraph"));
      if (response.statusCode == 200) {
        List<Generation> tempData = generationFromJson(response.body);
        setState(() {
          if (tempData.length >= 5) {
            inverter = tempData.sublist(tempData.length - 5); // Take the last 5 values from the API response
          } else {
            inverter = tempData; // If there are less than 5 values, use all the values from the API response
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
                      name: '6am',
                      // trackBorderWidth: 2,
                      // spacing: 0.2,
                      width: 0.8,
                      // dataLabelSettings: DataLabelSettings(isVisible: true),

                      dataSource: inverter,
                      color: Colors.deepPurple,

                      xValueMapper: (Generation data, _) => data.time,
                      yValueMapper: (Generation data, _) => data.h6Am,
                    ),
                    ColumnSeries<Generation, DateTime>(
                      name: '7am',
                      // trackBorderWidth: 2,
                      // spacing: 0.2,
                      // width: 0.8,
                      // dataLabelSettings: DataLabelSettings(isVisible: true),

                      dataSource: inverter,
                      color: Colors.deepPurple,
                      // isTrackVisible: true,
                      xValueMapper: (Generation data, _) => data.time,
                      yValueMapper: (Generation data, _) => data.h7Am,
                    ),
                    ColumnSeries<Generation, DateTime>(
                        name: '8am',
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),
                        // trackBorderWidth: 2,

                        dataSource: inverter,
                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.deepPurple,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h8Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '9am',
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),


                        dataSource: inverter,
                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.deepPurple,
                        // opacity: 1,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h9Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '10am',
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),
                        // trackBorderWidth: 2,

                        dataSource: inverter,
                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.deepPurple,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h10Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '11am',
                        dataSource: inverter,
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),
                        // animationDuration: 1000,
                        color: Colors.amber,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h11Am),
                    ColumnSeries<Generation, DateTime>(
                        name: '12pm',
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),
                        // trackBorderWidth: 2,
                        dataSource: inverter,
                        animationDuration: 1000,
                        enableTooltip: true,
                        color: Colors.red,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h12Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '1pm',
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),

                        dataSource: inverter,
                        // isTrackVisible: true,
                        // animationDuration: 1000,
                        color: Colors.lightBlueAccent,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h1Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '2pm',
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),

                        dataSource: inverter,

                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.yellow,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h2Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '3pm',
                        dataSource: inverter,
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        width: 1,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),
                        // animationDuration: 1000,

                        color: Colors.cyan,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h3Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '4pm',
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        width: 1,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),


                        dataSource: inverter,
                        animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.deepOrangeAccent,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h4Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '5pm',
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),


                        dataSource: inverter,
                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.green,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h5Pm),
                    ColumnSeries<Generation, DateTime>(
                        name: '6pm',
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),


                        dataSource: inverter,
                        // animationDuration: 1000,
                        // enableTooltip: true,
                        color: Colors.pink,
                        xValueMapper: (Generation data, _) => data.time,
                        yValueMapper: (Generation data, _) => data.h6Pm),
                    ColumnSeries<Generation, DateTime>(
                        dataSource: inverter,
                        // trackBorderWidth: 2,
                        // spacing: 0.2,
                        // width: 0.8,
                        // dataLabelSettings: DataLabelSettings(isVisible: true),

                        color: Colors.deepPurple,

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
      var response = await http.get(Uri.parse("http://103.149.143.33:8081/api/GenerationGraph"));
      if (response.statusCode == 200) {
        List<Generation> tempData = generationFromJson(response.body);
        setState(() {
          if (tempData.length >= 5) {
            inverter = tempData.sublist(tempData.length - 5); // Take the last 5 values from the API response
          } else {
            inverter = tempData; // If there are less than 5 values, use all the values from the API response
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
                yValueMapper: (Generation data, _) => data.todaysGeneration,
              ),

            ],
          ),
        ),
      ),
    );
  }
}