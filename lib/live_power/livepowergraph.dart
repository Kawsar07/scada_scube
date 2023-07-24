import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class GaugeScreen extends StatefulWidget {
  @override
  _GaugeScreenState createState() => _GaugeScreenState();
}

class _GaugeScreenState extends State<GaugeScreen> {
  double _gaugeValue = 0;
  late Timer _timer;
  late bool _isTimerActive;

  @override
  void initState() {
    super.initState();
    _isTimerActive = true;
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _isTimerActive = false;
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 2);
    _timer = Timer.periodic(duration, (_) {
      if (_isTimerActive) {
        fetchData();
      }
    });
  }

  void fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://103.149.143.33:8081/api/LiveAcDcPower'));
      final List<dynamic> dataList = jsonDecode(response.body);

      if (dataList.isNotEmpty) {
        final double newValue = dataList.last['liveAcPower'].toDouble();
        if (_gaugeValue != newValue) {
          setState(() {
            _gaugeValue = newValue;
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: 280,
        child: SizedBox(
          width: 250,
          height: 250,
          child: SfRadialGauge(
            title: const GaugeTitle(text: "Live Power"),
            enableLoadingAnimation: true,
            animationDuration: 1000,
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 1650.00,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: 0,
                    endValue: 1650.00,
                    color: Colors.deepPurple,
                    startWidth: 15,
                    endWidth: 15,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(
                    lengthUnit: GaugeSizeUnit.factor,
                    needleLength: 0.90,
                    needleStartWidth: 1,
                    needleEndWidth: 5,
                    knobStyle: const KnobStyle(
                      knobRadius: 10,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: Colors.black,
                    ),
                    value: _gaugeValue,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      '${_gaugeValue.toStringAsFixed(2)} kW', // Limit decimal points
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}