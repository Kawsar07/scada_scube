// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:scada_scube/login_page/regestrion_page.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // void main() {
// //   runApp(const MaterialApp(
// //     home: Loginscreen(),
// //   ));
// // }
//
// class Loginscreen extends StatelessWidget {
//   const Loginscreen({Key? key}) : super(key: key);
//
//   static const String _title = 'Sample App';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF90C126),
//           title: const Text("SCADA SCUBE"),
//           centerTitle: true,
//         ),
//         body: MyStatefulWidget(),
//       ),
//     );
//   }
// }
//
// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//
//     final double containerHeight =
//     isPortrait ? screenHeight * 0.2 : screenHeight * 0.4;
//     final double containerWidth =
//     isPortrait ? screenWidth * 0.3 : screenWidth * 0.15;
//     final double fontSize = isPortrait ? 20 : 30;
//
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: ListView(
//         children: <Widget>[
//           Container(
//             height: containerHeight,
//             width: containerWidth,
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(10),
//             child: Image.asset(
//               "assets/image/nawablogo.png",
//             ),
//           ),
//           Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(10),
//             child: Text(
//               'Nawab Sign',
//               style: GoogleFonts.lato(
//                 fontSize: fontSize,
//                 color: const Color(0xFF90C126),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(10),
//             child: TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'User Email',
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//             child: TextField(
//               obscureText: true,
//               controller: passwordController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Password',
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               //forgot password screen
//             },
//             child: const Text(
//               'Forgot Password',
//               style: TextStyle(
//                 color: const Color(0xFF90C126),
//               ),
//             ),
//           ),
//           Container(
//             height: 50,
//             padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//             child: ElevatedButton(
//               child:  Text('Login'),
//               style: ElevatedButton.styleFrom(
//                 primary: const Color(0xFF90C126), // Background color
//               ),
//               onPressed: () {
//                 _loginUser(context);
//               },
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               const Text('Does not have an account?'),
//               TextButton(
//                 child: const Text(
//                   'Sign in',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: const Color(0xFF90C126),
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => RegPages()),
//                   );
//                 },
//               )
//             ],
//             mainAxisAlignment: MainAxisAlignment.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _loginUser(BuildContext context) async {
//     final url = Uri.parse('http://192.168.68.19:8000/user-api/login/');
//
//     // Prepare the request body
//     final requestBody = {
//       'email': nameController.text,
//       'password': passwordController.text,
//     };
//
//     // Prepare the request headers
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//
//     // Send the POST request
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: jsonEncode(requestBody),
//     );
//
//     // Check the response status code
//     if (response.statusCode == 200) {
//       // Login successful, you can handle the response here
//       print('Login successful');
//       print(response.body);
//
//       // Extract the token from the response
//       final token = jsonDecode(response.body)['token'];
//
//       // Store the token locally
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', token);
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LogoutPage()),
//       );
//     } else {
//       // Login failed, handle the error
//       print('Login failed');
//       print(response.body);
//
//       // Check if the response body is in HTML format
//       if (response.headers['content-type']?.contains('text/html') ?? false) {
//         print('Error message: The API returned an HTML response.');
//         // Handle the error by displaying a generic error message to the user
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Login Failed'),
//               content: Text('Invalid email or password.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         print('Error message: Unable to parse the response.');
//         // Handle the error in an appropriate way
//       }
//     }
//   }
// }
//
// class RegPage extends StatelessWidget {
//   const RegPage({Key? key}) : super(key: key);
//
//   static const String _title = 'Sample App';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: _title,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF90C126),
//           title: const Text("SCADA SCUBE"),
//           centerTitle: true,
//         ),
//         body: Container(), // Add your registration form here
//       ),
//     );
//   }
// }
//
// class LogoutPage extends StatelessWidget {
//   const LogoutPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Logout Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _logoutUser(context);
//           },
//           child: const Text('Log Out'),
//         ),
//       ),
//     );
//   }
//
//   void _logoutUser(BuildContext context) async {
//     // Retrieve the token from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//
//     if (token == null) {
//       print('Token not found');
//       // Handle the error in an appropriate way, such as showing an error message
//       return;
//     }
//
//     final url = Uri.parse('http://192.168.68.19:8000/user-api/logout/');
//
//     // Prepare the request headers
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Token $token',
//     };
//
//     final response = await http.post(url, headers: headers);
//
//     if (response.statusCode == 200) {
//       // Logout successful
//       print('Logout successful');
//       // Handle the response or perform any additional actions
//     } else {
//       // Logout failed
//       print('Logout failed');
//       print(response.body);
//       // Handle the error in an appropriate way
//     }
//
//     // Clear the token from SharedPreferences
//     await prefs.remove('token');
//
//     // Navigate to the login screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => Loginscreen()),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scada_scube/main.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPageNawab extends StatelessWidget {
  const LoginPageNawab({Key? key}) : super(key: key);

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
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              "assets/image/nawablogo.png",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'Nawab Sign In',
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
            height: 70,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: ElevatedButton(
              child: const Text('Sign In'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90C126), // Background color
              ),
              onPressed: () {
                _loginUser();
              },
            ),
          ),
          Row(
            children: <Widget>[
              const Text('Don\'t have an account?'),
              TextButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF90C126),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegPages()),
                  );
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  void _loginUser() async {
    final url = Uri.parse('http://192.168.68.33:8000/user-api/login/');

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

    // Check the response status code
    if (response.statusCode == 200) {
      // Login successful, you can handle the response here
      print('Login successful');
      print(response.body);

      // Extract the token from the response
      final token = jsonDecode(response.body)['token'];

      // Store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RegPage(token: token),
        ),
      );

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
              content: Text(
                'An error occurred during login. Please try again later.',
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

class RegPages extends StatelessWidget {
  const RegPages({Key? key}) : super(key: key);

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
        body: MyStatefulWidgets(),
      ),
    );
  }
}

class MyStatefulWidgets extends StatefulWidget {
  const MyStatefulWidgets({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidgets> createState() => _MyStatefulWidgetsState();
}

class _MyStatefulWidgetsState extends State<MyStatefulWidgets> {
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
              "assets/image/nawablogo.png",
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Text(
              'Nawab Sign Up',
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
          Row(
            children: <Widget>[
              const Text('Already have an account?'),
              TextButton(
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF90C126),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    );
  }

  void _registerUser() async {
    final url = Uri.parse('http://192.168.68.19:8000/user-api/register/');

    // Prepare the request body
    final requestBody = {
      'first_name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'phone_no': phnnoController.text,
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

    // Check the response status code
    if (response.statusCode == 200) {
      // Registration successful, you can handle the response here
      print('Registration successful');
      print(response.body);

      // Extract the token from the response
      final token = jsonDecode(response.body)['token'];

      // Store the token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LogoutPage(token: token)),
      );
    } else {
      // Registration failed, handle the error
      print('Registration failed');
      print(response.body);

      // Check if the response body is in HTML format
      if (response.headers['content-type']?.contains('text/html') ?? false) {
        print('Error message: The API returned an HTML response.');
        // Handle the error by displaying a generic error message to the user
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
        // Handle the error in an appropriate way
      }
    }
  }
}

class LogoutPage extends StatelessWidget {
  final String token;

  const LogoutPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _logoutUser();
          },
          child: const Text('Log Out'),
        ),
      ),
    );
  }

  void _logoutUser() async {
    final url = Uri.parse('http://192.168.68.19:8000/user-api/logout/');

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
    } else {
      // Logout failed
      print('Logout failed');
      print(response.body);
      // Handle the error in an appropriate way
    }
  }
}
