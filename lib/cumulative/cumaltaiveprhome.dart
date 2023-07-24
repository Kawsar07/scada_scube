import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'model/cumulative.dart';

class CumuPrView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: prcumuTable(title: ''),
    );
  }
}

class prcumuTable extends StatefulWidget {
  prcumuTable({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _prcumuTableState createState() => _prcumuTableState();
}

class _prcumuTableState extends State<prcumuTable> {
  int itemCount = 2;
  late List<Cumulative>? _userModel = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _gotsData();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (_) {
      _gotsData();
    });
  }

  void _gotsData() async {
    var response = await http.get(Uri.parse('http://103.149.143.33:8081/api/CumulativeDatas'));
    if (response.statusCode == 200) {
      var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Cumulative> productList = decodedProducts.map<Cumulative>((json) => Cumulative.fromJson(json)).toList();
      setState(() {
        _userModel = productList;
      });
    } else {
      // Handle error response
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Cumulative>?>(
              future: getProductDataSource(),
              builder: (BuildContext context, AsyncSnapshot<List<Cumulative>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
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
                    child: SfDataGrid(
                      source: ProductDataGridSource(snapshot.data!),
                      columnWidthMode: ColumnWidthMode.fill,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columns: getColumns(),
                    ),
                  );
                } else {
                  return Center(
                    child: Text('No data available.'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<List<Cumulative>> getProductDataSource() async {
    var productList = await generateProductList();
    return productList;
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'DateTime',
        width: 80,
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
        columnName: 'AmbentTemperature',
        width: 95,
        label: Container(
          alignment: Alignment.centerRight,
          child: const Text(
            'cumulativePr',
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
    var response = await http.get(Uri.parse(
        'http://103.149.143.33:8081/api/CumulativeDatas'));
    var decodedProducts =
    json.decode(response.body).cast<Map<String, dynamic>>();
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

  List<DataGridRow> dataGridRows = [];
  List<Cumulative> productList = [];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.fromLTRB(0, 2, 1, 2),
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
          DataGridCell<DateTime>(
              columnName: 'Time', value: dataGridRow.time),
          DataGridCell(
              columnName: 'Temperature', value: dataGridRow.cumulativePr),
        ],
      );
    }).toList(growable: false);
  }
}


