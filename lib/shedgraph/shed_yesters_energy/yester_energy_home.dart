import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'yesterTable.dart';
import 'yestergraph.dart';

class YesterenergyHome extends StatefulWidget {
  @override
  _YesterenergyHomeState createState() => _YesterenergyHomeState();
}

class _YesterenergyHomeState extends State<YesterenergyHome> {
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
                          'ShedWise Yesterdays Energy  Graph',
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
                        child: YesterEnergyGraph(),
                      ),
                      const Text(
                        'ShedWise Yesterdays Energy Table',

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
                          child:YesterTable(),
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
