import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:scada_scube/Spalsh_screen/splash_screen.dart';

import 'package:scada_scube/home_page/home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'admin/admin_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          // HomeDashBroad(),
          SplashScreen(),

      // SplashScreen(token: '',),
    );
    //);
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF90C126),
          title: const Text("SCADA SCUBE"),
          centerTitle: true,
        ),
        body: MyLoginWidget(),
      ),
    );
  }
}

class MyLoginWidget extends StatefulWidget {
  const MyLoginWidget({Key? key}) : super(key: key);

  @override
  State<MyLoginWidget> createState() => _MyLoginWidgetState();
}

class _MyLoginWidgetState extends State<MyLoginWidget> {
  bool _disposed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final double containerHeight =
        isPortrait ? screenHeight * 0.2 : screenHeight * 0.4;
    final double containerWidth =
        isPortrait ? screenWidth * 0.3 : screenWidth * 0.1;
    final double fontSize = isPortrait ? 20 : 30;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            height: containerHeight,
            width: containerWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/image/jpllogo.png",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'JPL Login',
              style: GoogleFonts.lato(
                color: const Color(0xFF90C126),
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(180, 10, 10, 0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgetPasswordPage()),
                  );
                },
                child: const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: const Color(0xFF90C126),
                  ),
                )),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90C126), // Background color
              ),
              onPressed: () {
                _loginUser(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser(BuildContext context) async {
    final url = Uri.parse('http://103.149.143.33:8000/user-api/login/');

    // Prepare the request body
    final requestBody = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    // Prepare the request headers
    final headers = {
      'Content-Type': 'application/json',
    };

    // Send the POST request
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (!mounted) {
      return; // Exit if the widget is no longer active
    }

    // Check the response status code
    if (response.statusCode == 200) {
      // Login successful, you can handle the response here
      print('Login successful');
      print(response.body);

      // Extract the token from the response
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      // Store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (emailController.text == 'nawabadmin1234@gmail.com') {
        // Redirect to the admin page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminHomePage(token: token),
          ),
        );
      } else {
        // Redirect to the user page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(token: token),
          ),
        );
      }

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Successful'),
            content: Text('You have been successfully logged in.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Login failed, handle the error
      print('Login failed');
      print(response.body);

      // Check if the response body is in HTML format
      if (response.headers['content-type']?.contains('text/html') ?? false) {
        print('Error message: The API returned an HTML response.');

        // Show an error dialog for HTML response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid email or password.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Error message: Unable to parse the response.');

        // Show an error dialog for other response types
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid credentials'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class RegPage extends StatelessWidget {
  final String token;

  const RegPage({Key? key, required this.token}) : super(key: key);

  static const String _title = 'Sample App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF90C126),
          title: const Text("SCADA SCUBE"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminHomePage(token: token),
                ),
              ); // Go back to the previous screen
            },
          ),
        ),
        body: MyRegisterWidget(token: token),
      ),
    );
  }
}

class MyRegisterWidget extends StatefulWidget {
  final String token;

  const MyRegisterWidget({Key? key, required this.token}) : super(key: key);

  @override
  State<MyRegisterWidget> createState() => _MyRegisterWidgetState();
}

class _MyRegisterWidgetState extends State<MyRegisterWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phnnoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final double containerHeight =
        isPortrait ? screenHeight * 0.2 : screenHeight * 0.4;
    final double containerWidth =
        isPortrait ? screenWidth * 0.3 : screenWidth * 0.1;
    final double fontSize = isPortrait ? 20 : 30;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
            height: containerHeight,
            width: containerWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              "assets/image/jpllogo.png",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'JPL Sign Up',
              style: TextStyle(
                fontSize: fontSize,
                color: const Color(0xFF90C126),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: phnnoController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone no',
              ),
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              child: const Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90C126), // Background color
              ),
              onPressed: () {
                _registerUser();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    final url = Uri.parse('http://103.149.143.33:8000/user-api/register/');

    // Prepare the request body
    final requestBody = {
      'first_name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone_no': phnnoController.text,
    };

    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    // Prepare the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    // Send the POST request
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Registration successful, you can handle the response here
      print('Registration successful');
      print(response.body);

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Registration Successful'),
            content: Text('You have been successfully registered.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminHomePage(token: ''),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );

      // Handle the success in an appropriate way
    } else {
      // Registration failed, handle the error
      print('Registration failed');
      print(response.body);

      // Check if the response body is in HTML format
      if (response.headers['content-type']?.contains('text/html') ?? false) {
        print('Error message: The API returned an HTML response.');

        // Show an error dialog for HTML response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(
                'An error occurred during registration. Please try again later.',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Error message: Unable to parse the response.');

        // Show an error dialog for other response types
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(
                'An error occurred during registration. Please try again later.',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                _logoutUser(context);
              },
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  void _logoutUser(BuildContext context) async {
    // Retrieve the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse('http://103.149.143.33:8000/user-api/logout/');

    // Prepare the request headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      // Logout successful
      print('Logout successful');
      // Handle the response or perform any additional actions

      // Show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Successful'),
            content: Text('You have been successfully log out.'),
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

      // Navigate to the login page or perform any other necessary action
      // For example:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } else {
      // Logout failed
      print('Logout failed');
      print(response.body);
      // Handle the error in an appropriate way

      // Show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Failed'),
            content: Text(
              'An error occurred during logout. Please try again later.',
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _emailController = TextEditingController();

  Future<void> _submitEmail() async {
    String email = _emailController.text;

    // Make an HTTP POST request to your API endpoint
    var url = Uri.parse('http://103.149.143.33:8000/user-api/forget-password/');
    var response = await http.post(url, body: {'email': email});

    // Handle the API response here (e.g., show success/error message)
    if (response.statusCode == 200) {
      // Successful request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Password reset instructions sent to your email.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Request failed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SCADA SCUBE'),
        centerTitle: true,
        backgroundColor: const Color(0xFF90C126),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'Reset Your Password',
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xFF90C126),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitEmail();
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90C126), // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
