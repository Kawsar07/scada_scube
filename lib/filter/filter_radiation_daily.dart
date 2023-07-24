import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class FilterRadiationDailyApp extends StatelessWidget {
  final String token;

  const FilterRadiationDailyApp({Key? key, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FilterRadiationDailyScreen(token: token),
    );
  }
}

class FilterRadiationDailyScreen extends StatefulWidget {
  final String token;

  const FilterRadiationDailyScreen({Key? key, required this.token})
      : super(key: key);

  @override
  _FilterRadiationDailyScreenState createState() =>
      _FilterRadiationDailyScreenState();
}

class _FilterRadiationDailyScreenState
    extends State<FilterRadiationDailyScreen> {
  late DateTime selectedDate;
  List<Map<String, dynamic>> filteredData = [];

  Future<void> _filterData() async {
    final url = 'http://103.149.143.33:8000/filter-live-radiation-daily/';
    final date = '${DateFormat('yyyy-MM-dd').format(selectedDate)}';

    final authorizationToken = widget.token;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $authorizationToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'date': date}),
    );

    if (response.statusCode == 200) {
      final filteredDataResponse = jsonDecode(response.body) as List<dynamic>;
      final parsedData = filteredDataResponse.map((data) {
        final time = data['time'];
        final east = data['east'] != null
            ? double.tryParse(data['east'].toString())
            : null;
        final west = data['west'] != null
            ? double.tryParse(data['west'].toString())
            : null;
        final north = data['north'] != null
            ? double.tryParse(data['north'].toString())
            : null;
        final south = data['south'] != null
            ? double.tryParse(data['south'].toString())
            : null;
        final southF = data['south_f'] != null
            ? double.tryParse(data['south_f'].toString())
            : null;

        return {
          'time': time,
          'east': east,
          'west': west,
          'north': north,
          'south': south,
          'south_f': southF,
        };
      }).toList();

      // Limit the data to the last 50 elements
      final limitedData = parsedData.length <= 50
          ? parsedData
          : parsedData.sublist(parsedData.length - 50);

      setState(() {
        filteredData = limitedData;
      });

      print('Filter successful!');
    } else if (response.statusCode == 401) {
      print('Filter failed! Invalid token');
      // Handle invalid token error here
    } else {
      print('Filter failed! Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Handle other error cases here
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Column(
              children: [
                const Text(
                  'Filter Live Radiation Daily',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isVisible: false,
                  ),
                  series: <LineSeries<Map<String, dynamic>, String>>[
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['east'],
                      name: 'Radiation East',
                      color: Colors.blue,
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['west'],
                      name: 'Radiation West',
                      color: Colors.grey,
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['north'],
                      name: 'Radiation North',
                      color: Colors.deepPurple,
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['south'],
                      name: 'Radiation South',
                      color: Colors.green,
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['south_f'],
                      name: 'Radiation South 15 Degree',
                      color: Colors.cyan,
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                          'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                      const SizedBox(width: 40),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(),
                        onPressed: _filterData,
                        child: Text('Filter'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Filtered Data:'),
                SizedBox(
                  height: 300, // Constrain the height using SizedBox
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FittedBox(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('East')),
                          DataColumn(label: Text('West')),
                          DataColumn(label: Text('North')),
                          DataColumn(label: Text('South')),
                          DataColumn(label: Text('South F')),
                        ],
                        rows: filteredData.map((data) {
                          final time = DateFormat('HH:mm:ss')
                              .format(DateTime.parse(data['time']));

                          final east = data['east'] != null
                              ? NumberFormat("#,##0.00").format(data['east'])
                              : 'N/A';
                          final west = data['west'] != null
                              ? NumberFormat("#,##0.00").format(data['west'])
                              : 'N/A';
                          final north = data['north'] != null
                              ? NumberFormat("#,##0.00").format(data['north'])
                              : 'N/A';
                          final south = data['south'] != null
                              ? NumberFormat("#,##0.00").format(data['south'])
                              : 'N/A';
                          final southF = data['south_f'] != null
                              ? NumberFormat("#,##0.00").format(data['south_f'])
                              : 'N/A';

                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    time,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(Text(east)),
                              DataCell(Text(west)),
                              DataCell(Text(north)),
                              DataCell(Text(south)),
                              DataCell(Text(southF)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
