import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'cumulativepoag.dart';
import 'model/cumulative.dart';

class PoaAvgView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PoaAvgTable(title: ''),
    );
  }
}

class PoaAvgTable extends StatefulWidget {
  PoaAvgTable({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PoaAvgTableState createState() => _PoaAvgTableState();
}

class _PoaAvgTableState extends State<PoaAvgTable> {
  late List<Cumulative>? _userModel = [];

  late Timer _timer;
  int itemCount = 2; // Add itemCount variable and initialize it

  @override
  void initState() {
    super.initState();
    _gotsData(); // Fetch data initially
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
      _getData(); // Fetch data periodically
    });
  }

  void _gotsData() async {
    _userModel = await generateProductList();
    setState(() {});
  }

  void _getData() async {
    List<Cumulative>? data = await generateProductList();
    if (data != null) {
      setState(() {
        _userModel = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                transform: Matrix4.translationValues(7.0, -7.0, 0.0),
                height: 800,
                child: FutureBuilder(
                  future: getProductDataSource(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.hasData
                        ? LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          width: double.infinity,
                          child: SfDataGrid(
                            source: snapshot.data,
                            columnWidthMode: ColumnWidthMode.fill,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            columns: getColumns(),
                          ),
                        );
                      },
                    )

                        : const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'DateTime',
        width: 85,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'ModuleTemperature',
        width: 95,
        label: Container(
          alignment: Alignment.centerRight,
          child: const Text(
            'cumulative Poa Avg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
    ];
  }

  Future<List<Cumulative>> generateProductList() async {
    var response = await http.get(
      Uri.parse('http://103.149.143.33:8081/api/CumulativeDatas'),
    );
    var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Cumulative> productList = decodedProducts
        .map<Cumulative>((json) => Cumulative.fromJson(json))
        .toList();
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }

  late List<DataGridRow> dataGridRows;
  late List<Cumulative> productList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(0, 2, 1, 2),
          // padding: const EdgeInsets.all(2.0),
          child: Text(
            DateFormat('hh:mm:ss').format(row.getCells()[0].value),
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
          DataGridCell(
              columnName: 'Shed1', value: dataGridRow.cumulativePoaAvg),
        ],
      );
    }).toList(growable: false);
  }
}
