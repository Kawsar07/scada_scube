import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scada_scube/shedgraph/shed_yesters_energy/shedwise_Model_yesterEnergy.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class YesterTable extends StatefulWidget {
  @override
  _YesterTableState createState() => _YesterTableState();
}

class _YesterTableState extends State<YesterTable> {
  Timer? _timer;
  List<YesterdaysEnergy> productList = [];

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      // Call the method to update the data source and refresh the grid
      _refreshData();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _refreshData() async {
    // Fetch the updated data
    List<YesterdaysEnergy> updatedProductList = await generateProductList();
    setState(() {
      productList = updatedProductList;
    });
  }

  Future<List<YesterdaysEnergy>> generateProductList() async {
    var response =
    await http.get(Uri.parse('http://103.149.143.33:8081/api/YesterdaysEnergy'));
    var decodedProducts =
    json.decode(response.body).cast<Map<String, dynamic>>();
    List<YesterdaysEnergy> productList = await decodedProducts
        .map<YesterdaysEnergy>((json) => YesterdaysEnergy.fromJson(json))
        .toList();
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: FutureBuilder(
                future: getProductDataSource(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: Colors.amber,
                        frozenPaneElevation: 0.0,
                        frozenPaneLineColor: Colors.white,
                        frozenPaneLineWidth: 1.5,
                      ),
                      child: Container(
                        height: 400, // Specify the desired fixed height for the table
                        child: SfDataGrid(
                          frozenColumnsCount: 1,
                          source: snapshot.data,
                          columnWidthCalculationRange:
                          ColumnWidthCalculationRange.allRows,
                          columnWidthMode: ColumnWidthMode.auto,
                          columns: getColumns(),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error fetching data'); // Display error message
                  } else {
                    return const CircularProgressIndicator(); // Display loading indicator
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<ProductDataGridSource> getProductDataSource() async {
    return ProductDataGridSource(productList);
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'ModuleTemperature',
        width: 150,
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Time',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Shed14',
        width: 90,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Shed14',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Shed17',
        width: 80,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Shed17',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Shed18',
        width: 80,
        label: Container(
          alignment: Alignment.center,
          child: const Text(
            'Shed18',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Floating Shed',
        width: 110,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: const Text(
            'FloatingShed',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Todays Generation',
        width: 125,
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Yesterdays Generation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
    ];
  }
}

class ProductDataGridSource extends DataGridSource {
  ProductDataGridSource(this.productList) {
    buildDataGridRow();
  }

  List<DataGridRow> dataGridRows = [];
  List<YesterdaysEnergy> productList = [];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(0, 2, 1, 2),
          child: Text(
            DateFormat('MM/dd/yyyy hh:mm:ss')
                .format(row.getCells()[0].value),
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
          DataGridCell(columnName: 'Shed14', value: dataGridRow.shed14),
          DataGridCell(
              columnName: 'Shed17', value: dataGridRow.shed17),
          DataGridCell(columnName: 'Shed18', value: dataGridRow.shed18),
          DataGridCell(columnName: 'FloatingShed', value: dataGridRow.floatingShed),
          DataGridCell(
              columnName: 'Yesterdays Generation',
              value: dataGridRow.yesterdaysGeneration),




        ],
      );
    }).toList(growable: false);
  }
}
