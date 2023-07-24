import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scada_scube/main.dart';

import '../home_page/home_page.dart';

class ChangePasswordApp extends StatelessWidget {
  final String token;

  const ChangePasswordApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Change Password',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: ChangePasswordPage(token: token),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  final String token;

  ChangePasswordPage({required this.token});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();

  final String apiUrl = 'http://103.149.143.33:8000/user-api/change-password/';

  Future<void> changePassword(BuildContext context) async {
    final Uri url = Uri.parse(apiUrl);
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ${widget.token}',
    };
    final Map<String, String> requestBody = {
      'new password': _newPasswordController.text,
      'old password': _oldPasswordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Password change successful
        print('Password changed successfully!');
        _showAlertDialog(context, 'Password Changed Successfully!');
      } else {
        // Handle error scenario
        print('Failed to change password. Status code: ${response.statusCode}');
        _showAlertDialog(context, 'Failed to change password.');
      }
    } catch (error) {
      // Handle network or API error
      print('Error occurred while changing password: $error');
      _showAlertDialog(context, 'Error occurred while changing password.');
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Change Status'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF90C126),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(token: widget.token),
              ),
            );
          },
        ),
        title: Text("SCADA SCUBE"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Old Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_open),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: ElevatedButton(
                child: const Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF90C126), // Background color
                ),
                onPressed: () {
                  changePassword(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
