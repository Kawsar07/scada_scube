
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  final String token;
  const UserHomePage({required this.token}) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the User Home Page'),
      ),
    );
  }
}
