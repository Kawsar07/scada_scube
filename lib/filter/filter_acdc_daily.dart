import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class FilterAcdcDailyApp extends StatelessWidget {
  final String token;

  const FilterAcdcDailyApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FilterAcdcDailyScreen(token: token),
    );
  }
}

class FilterAcdcDailyScreen extends StatefulWidget {
  final String token;

  const FilterAcdcDailyScreen({Key? key, required this.token}) : super(key: key);

  @override
  _FilterAcdcDailyScreenState createState() => _FilterAcdcDailyScreenState();
}

class _FilterAcdcDailyScreenState extends State<FilterAcdcDailyScreen> {
  late DateTime selectedDate;
  List<Map<String, dynamic>> filteredData = [];

  Future<void> _filterData() async {
    final url = 'http://103.149.143.33:8000/filter-live-ACDC-power-daily/';
    final selectedDateString = '${DateFormat('yyyy-MM-dd').format(selectedDate)}';

    final authorizationToken =
        widget.token; // Use the provided token from the widget

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Token $authorizationToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'date': selectedDateString}),
    );

    if (response.statusCode == 200) {
      final filteredDataResponse = jsonDecode(response.body) as List<dynamic>;
      final parsedData = filteredDataResponse.map((data) {
        return {
          'time': data['time'],
          'live_ac_power': double.parse(data['live_ac_power'].toString()),
          'live_dc_power': double.parse(data['live_dc_power'].toString()),
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
                  'Filter Live ACDC',
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
                      yValueMapper: (data, _) => data['live_ac_power'],
                      name: 'AC Power',
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: filteredData,
                      xValueMapper: (data, _) => data['time'],
                      yValueMapper: (data, _) => data['live_dc_power'],
                      name: 'DC Power',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                    const SizedBox(width: 40),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(

                        ),
                        onPressed: _filterData,
                        child: Text('Filter'),
                      ),

                  ],
                ),
                const SizedBox(height: 16.0),
                const Text('Filtered Data:'),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: FittedBox(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('AC Power')),
                          DataColumn(label: Text('DC Power')),
                        ],
                        rows: filteredData.map((data) {
                          final time = DateFormat('HH:mm:ss').format(DateTime.parse(data['time']));                          final acPower = NumberFormat("#,##0.00").format(data['live_ac_power']);
                          final dcPower = NumberFormat("#,##0.00").format(data['live_dc_power']);

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
                              DataCell(Text(acPower)),
                              DataCell(Text(dcPower)),
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
