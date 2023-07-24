import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class FiltertempmonthApp extends StatelessWidget {
  final String token;

  const FiltertempmonthApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FiltertempmonthlyScreen(token: token),
    );
  }
}

class FiltertempmonthlyScreen extends StatefulWidget {
  final String token;

  const FiltertempmonthlyScreen({Key? key, required this.token}) : super(key: key);

  @override
  _FiltertempmonthlyScreenState createState() => _FiltertempmonthlyScreenState();
}

class _FiltertempmonthlyScreenState extends State<FiltertempmonthlyScreen> {
  late DateTime startDate;
  late DateTime endDate;
  List<Map<String, dynamic>> filteredData = [];
  Future<void> _filterData() async {
    final url = 'http://103.149.143.33:8000/filter-temperature-data/';
    final start = '${DateFormat('yyyy-MM-dd').format(startDate)} 00:00:00.000';
    final end = '${DateFormat('yyyy-MM-dd').format(endDate)} 23:59:59.999';

    final authorizationToken = widget.token; // Use the provided token from the widget

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $authorizationToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'start': start, 'end': end}),
    );

    if (response.statusCode == 200) {
      final filteredDataResponse = jsonDecode(response.body) as List<dynamic>;
      final parsedData = filteredDataResponse.map((data) {
        final time = data['time'] as String?;
        final temperature = data['module_temperature'] as num?;

        if (time != null && temperature != null) {
          return {
            'time': time,
            'module_temperature': temperature.toDouble(),
          };
        } else {
          return null;
        }
      }).whereType<Map<String, dynamic>>().toList();

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

      // Handle other error cases here
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    filteredData = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Filter Data'),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Column(
              children: [
                const Text(
                  'Filter Temperature Data',
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
                      xValueMapper: (data, _) => data['time'] ?? '',
                      yValueMapper: (data, _) => data['module_temperature'] ?? 0.0,
                      name: 'Temperature',
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectStartDate(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectEndDate(context),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      transform: Matrix4.translationValues(1.0, -20.0, 0.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: _filterData,
                        child: Text('Filter'),
                      ),
                    ),
                  ],
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
                          DataColumn(label: Text('Temperature')),
                        ],
                        rows: filteredData.map((data) {
                          final time = DateFormat('yyyy-MM-d').format(DateTime.parse(data['time']));

                          final temperature = data['module_temperature'] != null
                              ? NumberFormat("#,##0.00").format(data['module_temperature'])
                              : 'N/A'; // Replace 'N/A' with any string you want to show for null temperature

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
                              DataCell(Text(temperature)),
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
