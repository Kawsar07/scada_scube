import 'package:flutter/material.dart';
import 'dart:async';
import '../home_page/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double screenHeight = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Container(
                                  transform: Matrix4.translationValues(
                                    screenWidth < 600 ? 4.0 : 20.0,
                                    screenHeight < 600 ? 30.0 : 50.0,
                                    0.0,
                                  ),
                                  child: Image.asset(
                                    "assets/image/robinlogo.png",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  transform: Matrix4.translationValues(
                                    screenWidth < 600 ? -2.0 : 0.0,
                                    screenHeight < 600 ? 25.0 : 40.0,
                                    0.0,
                                  ),
                                  child: Image.asset(
                                    "assets/image/jpllogo.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 190.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: screenHeight < 600 ? 10 : 20,
                          ),
                          width: screenWidth * 0.4,
                          height: 6,
                          child: const LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                            backgroundColor: Color(0xffD6D6D6),
                          ),
                        ),
                        const Text(
                          "SCADA SCUBE",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          '©Scube Technologies Limited',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
