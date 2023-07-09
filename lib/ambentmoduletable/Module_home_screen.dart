import 'package:flutter/material.dart';
import 'package:scada_scube/ambentmoduletable/table_module.dart';
import '../home_page/home_page.dart';
import 'graph.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double _opacity1 = 0.0;
  double _opacity2 = 1.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

          backgroundColor: Color(0xFF90C126),
          title: const Text("SCADA SCUBE"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),



        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width < 600 ? 400 : 400,
                width: MediaQuery.of(context).size.width < 600 ? 400 : 500,
                child: TempGraphScreen(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.width < 600 ? 700 : 700,
                width: MediaQuery.of(context).size.width < 600 ? 400 : 500,
                child: ModuleTable(),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
