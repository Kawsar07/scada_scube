import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scada_scube/ambentmoduletable/modulesmodel.dart';
import 'package:scada_scube/liveRdaition%20table%20/liveradiationModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'api_live_radition.dart';

class RaditionTable extends StatefulWidget {
  const RaditionTable({Key? key}) : super(key: key);

  @override
  _RaditionTableState createState() => _RaditionTableState();
}

class _RaditionTableState extends State<RaditionTable> {
  int itemCount = 2;
  late List<LiveRadiation>? _userModel = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _getsData();
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
      _getsData();
    });
  }

  void _getsData() async {
    var response = await http.get(Uri.parse('http://103.149.143.33:8081/api/LiveRadiation'));
    if (response.statusCode == 200) {
      var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
      List<LiveRadiation> productList = decodedProducts.map<LiveRadiation>((json) => LiveRadiation.fromJson(json)).toList();
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
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Scaffold(
            body: FutureBuilder(
              future: getProductDataSource(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return snapshot.hasData
                    ? RefreshIndicator(
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
                      source: snapshot.data,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: getColumns(constraints.maxWidth),
                      frozenColumnsCount: 1,
                    ),
                  ),
                )
                    : const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    var productList = await generateProductList();
    return ProductDataGridSource(productList);
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
        width: maxWidth * 0.3,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'East',
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
      GridColumn(
        columnName: 'ModuleTemperature',
        width: maxWidth * 0.3,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'West',
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
      GridColumn(
        columnName: 'ModuleTemperature',
        width: maxWidth * 0.3,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'North',
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
      GridColumn(
        columnName: 'ModuleTemperature',
        width: maxWidth * 0.3,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'South',
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
      GridColumn(
        columnName: 'ModuleTemperature',
        width: maxWidth * 0.3,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'South 15°',
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

  Future<List<LiveRadiation>> generateProductList() async {
    var response = await http.get(Uri.parse('http://103.149.143.33:8081/api/LiveRadiation'));
    var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
    List<LiveRadiation> productList = await decodedProducts.map<LiveRadiation>((json) => LiveRadiation.fromJson(json)).toList();
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<LiveRadiation> productList = [];

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
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[4].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toString(),
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
          DataGridCell(columnName: 'East', value: dataGridRow.east),
          DataGridCell(columnName: 'West', value: dataGridRow.west),
          DataGridCell(columnName: 'North', value: dataGridRow.north),
          DataGridCell(columnName: 'South', value: dataGridRow.south),
          DataGridCell(columnName: 'South 15°', value: dataGridRow.southF),
        ],
      );
    }).toList(growable: false);
  }
}
