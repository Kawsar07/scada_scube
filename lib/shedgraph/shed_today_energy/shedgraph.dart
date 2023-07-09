import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scada_scube/shedgraph/shed_today_energy/shedwise_Model_TodayEnergy.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../TimeGraph/linenetwork.dart';
import 'package:intl/intl.dart';

class ShedWisegraphs extends StatefulWidget {
  const ShedWisegraphs({Key? key}) : super(key: key);

  @override
  State<ShedWisegraphs> createState() => _ShedWisegraphsState();
}

class _ShedWisegraphsState extends State<ShedWisegraphs> {
  List<TodaysEnergy> inverter = [];
  bool loading = true;
  bool showShed1 = true;
  NetworkHelper _networkHelper = NetworkHelper();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data initially
    startTimer(); // Start automatic refresh timer
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 5); // Set the refresh interval
    _timer = Timer.periodic(duration, (_) {
      getData(); // Fetch data periodically
    });
  }

  Future<void> getData() async {
    var response =
    await _networkHelper.get("http://103.149.143.33:8081/api/TodayEnergy");
    List<TodaysEnergy> tempdata = todaysEnergyFromJson(response.body);
    setState(() {
      inverter = tempdata;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: Container(
        height: 500,
        width: 600,
        child: SfCartesianChart(
              legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              primaryXAxis: DateTimeCategoryAxis(
                interval: 1,
                dateFormat: DateFormat('dd/MM/yyyy'),
              ),
              palette: const <Color>[Colors.teal, Colors.orange, Colors.brown],
              series: <ChartSeries>[
                ColumnSeries<TodaysEnergy, DateTime>(
                  dataSource: inverter,
                  xValueMapper: (TodaysEnergy ch, _) => ch.time,
                  yValueMapper: (TodaysEnergy ch, _) => ch.shed14,
                  animationDuration: 1000,
                  name: 'Shed14',
                  color: Colors.greenAccent[900],
                ),
                ColumnSeries<TodaysEnergy, DateTime>(
                  dataSource: inverter,
                  name: 'Shed17',
                  xValueMapper: (TodaysEnergy ch, _) => ch.time,
                  yValueMapper: (TodaysEnergy ch, _) => ch.shed17,
                  animationDuration: 1000,
                  color: Colors.orange[800],
                ),
                ColumnSeries<TodaysEnergy, DateTime>(
                  dataSource: inverter,
                  name: 'shed18',
                  xValueMapper: (TodaysEnergy ch, _) => ch.time,
                  yValueMapper: (TodaysEnergy ch, _) => ch.shed18,
                  animationDuration: 1000,
                  color: Colors.pink,
                ),
                ColumnSeries<TodaysEnergy, DateTime>(
                  dataSource: inverter,
                  xValueMapper: (TodaysEnergy ch, _) => ch.time,
                  yValueMapper: (TodaysEnergy ch, _) => ch.todaysGeneration,
                  animationDuration: 1000,
                  color: Colors.blue[800],
                  name: 'FloatingShed',
                ),
                ColumnSeries<TodaysEnergy, DateTime>(
                  dataSource: inverter,
                  xValueMapper: (TodaysEnergy ch, _) => ch.time,
                  yValueMapper: (TodaysEnergy ch, _) => ch.todaysGeneration,
                  animationDuration: 1000,
                  color: Colors.amberAccent,
                  name: 'TodaysGeneration',
                ),
              ],
            ),
          ),

        ),
    );
  }
}
