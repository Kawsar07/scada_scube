import 'package:flutter/material.dart';

class NewPAge extends StatelessWidget {
  const NewPAge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Feature is Coming Soon',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
