import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_core/theme.dart';


class ModuleTable extends StatefulWidget {
  ModuleTable({Key? key}) : super(key: key);

  @override
  _ModuleTableState createState() => _ModuleTableState();
}

class _ModuleTableState extends State<ModuleTable> {
  int itemCount = 2;
  List<ModuleTemperature> _userModel = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getData(); // Fetch data initially
    startTimer(); // Start automatic refresh timer
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    const refreshInterval = Duration(seconds: 10); // Set the refresh interval
    _timer = Timer.periodic(refreshInterval, (_) {
      _getData(); // Fetch data periodically
    });
  }

  void _getData() async {
    try {
      var response = await http.get(Uri.parse('http://103.149.143.33:8081/api/TemperatureData'));
      var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
      List<ModuleTemperature> productList = decodedProducts
          .map<ModuleTemperature>((json) => ModuleTemperature.fromJson(json))
          .toList();
      setState(() {
        _userModel = productList;
      });
    } catch (e) {
      // Handle error or show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: FutureBuilder<List<ModuleTemperature>>(
              future: generateProductList(),
              builder: (BuildContext context, AsyncSnapshot<List<ModuleTemperature>> snapshot) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    displacement: 250,
                    backgroundColor: Colors.white,
                    color: Colors.black,
                    strokeWidth: 3,
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 1500));
                      setState(() {
                        itemCount = itemCount + 1;
                      });
                    },
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: Colors.deepPurple,
                        frozenPaneElevation: 0.0,
                        frozenPaneLineColor: Colors.white,
                        frozenPaneLineWidth: 1.5,
                      ),
                      child: SfDataGrid(
                        source: ProductDataGridSource(snapshot.data ?? []),
                        columnWidthMode: ColumnWidthMode.fill,
                        columns: getColumns(constraints.maxWidth),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  List<GridColumn> getColumns(double maxWidth) {
    return <GridColumn>[
      GridColumn(
        columnName: 'Date Time',
        width: maxWidth * 0.4,
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'ModuleTemperature',
        width: maxWidth * 0.6,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'ModuleTemperature',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
    ];
  }

  Future<List<ModuleTemperature>> generateProductList() async {
    return _userModel;
  }
}

class ModuleTemperature {
  final DateTime time;
  final double moduleTemperature;

  ModuleTemperature({
    required this.time,
    required this.moduleTemperature,
  });

  factory ModuleTemperature.fromJson(Map<String, dynamic> json) {
    return ModuleTemperature(
      time: DateTime.parse(json['time']),
      moduleTemperature: json['moduleTemperature'].toDouble(),
    );
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  final List<ModuleTemperature> productList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(0, 2, 1, 2),
          child: Text(
            DateFormat('MM/dd/yyyy hh:mm:ss').format(row.getCells()[0].value),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[1].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = productList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(
        cells: [
          DataGridCell<DateTime>(columnName: 'Time', value: dataGridRow.time),
          DataGridCell(columnName: 'ModuleTemperature', value: dataGridRow.moduleTemperature),
        ],
      );
    }).toList(growable: false);
  }
}
