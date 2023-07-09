import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../home_page/home_page.dart';
import 'genartion_Table.dart';
import 'genartion_graph.dart';

class GenarationHome extends StatefulWidget {
  @override
  _GenarationHomeState createState() => _GenarationHomeState();
}

class _GenarationHomeState extends State<GenarationHome> {
  int itemCount = 0;

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
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(

                        child: const Text(
                          'ShedWise Generation Graph',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SizedBox(
                        height: 400,
                        width: constraints.maxWidth * 1.0,
                        // Adjust the width as needed
                        child: Genrationgraphs(),
                      ),
                      const Text(
                        'ShedWise Generation Graph Table',

                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9, // Adjust the width factor as needed
                        child: Container(
                          transform: Matrix4.translationValues(-6.0, -45.0, 0.0),
                          height: constraints.maxHeight,
                          // Adjust the height as needed
                          child:GenartionTable(),
                        ),
                      ),
                    ],
                  ),
                );

            },
          ),
        ));
  }
}
