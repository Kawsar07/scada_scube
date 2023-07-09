import 'package:flutter/material.dart';
import 'package:scada_scube/liveRdaition%20table%20/liveradionGraph.dart';
import '../home_page/home_page.dart';
import 'liveraditiontable.dart';

class RaditionHome extends StatefulWidget {
  @override
  _RaditionHomeState createState() => _RaditionHomeState();
}

class _RaditionHomeState extends State<RaditionHome> {
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
                child: const RaditionGraphScreen(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.width < 600 ? 700 : 700,
                width: MediaQuery.of(context).size.width < 600 ? 400 : 500,
                child: const RaditionTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
