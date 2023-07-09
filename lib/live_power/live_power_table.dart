import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scada_scube/live_power/livepowernetwork.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'livepowerModel.dart';
import 'livepowergraph.dart';

class liveTable extends StatefulWidget {
  liveTable({Key? key}) : super(key: key);

  @override
  _liveTableState createState() => _liveTableState();
}

class _liveTableState extends State<liveTable> {
  int itemCount = 2;
  late List<Livepower>? _userModel = [];
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
    _userModel = await ApipowerLive().getTotalCustomerStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF90C126),
          title: const Text('SCADA SCUBE'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: GaugeScreen(),
              ),
              SizedBox(
                height: 700,
                child: FutureBuilder(
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
                          onQueryRowHeight: (details) {
                            return details.rowIndex == 0 ? 35.0 : 30.0;
                          },
                          source: snapshot.data,
                          frozenColumnsCount: 2,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                          columnWidthMode: ColumnWidthMode.auto,
                          columns: getColumns(),
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
        columnName: 'ModuleTemperature',
        width: 200,
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Time',
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
        columnName: 'live power',
        width: 200,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Live Power',
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

  Future<List<Livepower>> generateProductList() async {
    var response = await http.get(Uri.parse('http://103.149.143.33:8081/api/LiveAcDcPower'));
    var decodedProducts = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Livepower> productList = decodedProducts.map<Livepower>((json) => Livepower.fromJson(json)).toList();
    return productList;
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<Livepower> productList = [];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.center,
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
          DataGridCell(columnName: 'Shed1', value: dataGridRow.liveAcPower),
        ],
      );
    }).toList(growable: false);
  }
}
