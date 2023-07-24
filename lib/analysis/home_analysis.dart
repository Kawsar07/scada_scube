import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page/home_page.dart';
import 'analysis_home.dart';



class AnalysisHome extends StatefulWidget {
  final String token ;
  const AnalysisHome({super.key, required this.token});

  @override
  _AnalysisHomeState createState() => _AnalysisHomeState();
}

class _AnalysisHomeState extends State<AnalysisHome> {
  int itemCount = 0;
  int refreshInterval = 10;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    // Start the timer and set the callback function to refresh the page
    _timer = Timer.periodic(Duration(seconds: refreshInterval), (_) {
      _refreshPage();
    });
  }

  void _cancelTimer() {
    // Cancel the timer if it's running
    _timer?.cancel();
  }

  void _refreshPage() {
    // This function will be called when the timer triggers
    // Implement any logic needed to refresh the page here

    // In this example, we'll increment the itemCount by 1 to simulate changes
    setState(() {
      itemCount++;
    });
  }

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(token: widget.token),
                  ),
                );
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
                          'Radiation Power Temperature Graph',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      SizedBox(
                        height: 500,
                        width: constraints.maxWidth * 1.0,
                        // Adjust the width as needed
                        child: RadiationsScreen(),
                      ),

                    ],
                  ),
                );

            },
          ),
        ));
  }
}
