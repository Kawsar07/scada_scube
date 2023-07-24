import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';


class FilterApps extends StatelessWidget {
  final String token;

  const FilterApps({required this.token});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FiltersScreen(token: token),
    );
  }
}

class FiltersScreen extends StatefulWidget {
  final String token;

  const FiltersScreen({Key? key, required this.token}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late DateTime startDate;
  late DateTime endDate;
  List<Map<String, dynamic>> filteredData = [];

  Future<void> _filterData() async {
    final url = 'http://103.149.143.33:8000/filter-live-ACDC-power/';

    // Only use the date part of the selected start and end dates
    final start = DateFormat('yyyy-MM-dd').format(startDate);
    final end = DateFormat('yyyy-MM-dd').format(endDate);

    final authorizationToken = widget.token;

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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        endDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59, 999);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Data'),
      ),
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
                    ElevatedButton(
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
                          final time = DateFormat.yMd().add_jm().format(DateTime.parse(data['time']));
                          final acPower = NumberFormat("#,##0.00").format(data['live_ac_power']);
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
