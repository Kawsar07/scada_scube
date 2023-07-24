import 'package:flutter/material.dart';
import 'cumaltaiveprhome.dart';
import 'cumulativepoahome.dart';


class MyWidgets extends StatefulWidget {
  @override
  _MyWidgetsState createState() => _MyWidgetsState();
}

class _MyWidgetsState extends State<MyWidgets> {
  double _opacity1 = 1.0;
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 3),
              Row(
                children: [
                  const SizedBox(width: 2),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _opacity1 = 1.0 - _opacity1;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                        ),
                        child: const Text(
                          'Cumulative PR',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _opacity2 = 1.0 - _opacity2;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange,
                          ),
                        ),
                        child: const Text(
                          'Cumulative Poa Avg',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;

                    return Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: double.infinity,
                            width: availableWidth < 600 ? double.infinity : availableWidth * 0.4,
                            child: AnimatedOpacity(
                              opacity: _opacity1,
                              duration: const Duration(seconds: 1),
                              child: CumuPrView(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: double.infinity,
                            width: availableWidth < 600 ? double.infinity : availableWidth * 0.4,
                            child: AnimatedOpacity(
                              opacity: _opacity2,
                              duration: const Duration(seconds: 1),
                              child: PoaAvgView(),
                            ),
                          ),
                        ),
                      ],
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
}

