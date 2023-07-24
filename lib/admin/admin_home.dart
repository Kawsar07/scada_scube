// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:scada_scube/Spalsh_screen/splash_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
//
// import '../main.dart';
//
// class AdminHomePage extends StatelessWidget {
//   final String token;
//
//   const AdminHomePage({required this.token}) : super();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF90C126),
//         title: const Text('SCADA SCUBE'),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => LoginPage(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           if (constraints.maxWidth >= 600) {
//             // For iPad and desktop devices
//             return buildDesktopCardLayout(context);
//           } else {
//             // For phone devices
//             return buildPhoneCardLayout(context);
//           }
//         },
//       ),
//     );
//   }
//
//   Widget buildPhoneCardLayout(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.all(16.0),
//       children: [
//         Center(
//           child: Text(
//             'Admin Dashboard',
//             style: GoogleFonts.lato(
//               fontSize: 30,
//               color: Colors.blue,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'Dashboard',
//
//
//                   () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => SplashScreen(token: token),
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'User account created', () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => RegPage(token: token),
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'Log out', () {
//             _logoutUser(context);
//           }),
//         ),
//       ],
//     );
//   }
//
//
//   Widget buildDesktopCardLayout(BuildContext context) {
//     return GridView.count(
//       padding: EdgeInsets.all(16.0),
//       crossAxisCount: 2,
//       crossAxisSpacing: 16.0,
//       mainAxisSpacing: 16.0,
//       children: [
//         Center(
//           child: Text(
//             'Admin Dashboard',
//             style: TextStyle(
//               fontSize: 30,
//             ),
//           ),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'Dashboard', () {
//             // Handle Dashboard button pressed
//           }),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'User account created', () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => RegPage(token: token),
//               ),
//             );
//           }),
//         ),
//         SizedBox(height: 16.0),
//         Container(
//           color: Color(0xFF90C126), // Set the background color here
//           child: buildCard(context, 'Log out', () {
//             _logoutUser(context);
//           }),
//         ),
//       ],
//     );
//   }
//
//
//   Widget buildCard(BuildContext context, String title, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: () {
//         if (title == 'Log out') {
//           _logoutUser(context);
//         } else {
//           onPressed();
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         primary: Color(0xFF90C126), // Set the background color here
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Text(
//           title,
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
//
//
//   void _logoutUser(BuildContext context) async {
//     // Retrieve the token from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? token = prefs.getString('token');
//
//     final url = Uri.parse('http://192.168.68.33:8000/user-api/logout/');
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
//
//       // Show a success dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Logout Successful'),
//             content: Text('You have been successfully logged out.'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => LoginPage()),
//                   );
//                 },
//               ),
//             ],
//           );
//         },
//       );
//
//       // Navigate to the login page or perform any other necessary action
//       // For example:
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
//     } else {
//       // Logout failed
//       print('Logout failed');
//       print(response.body);
//       // Handle the error in an appropriate way
//
//       // Show an error dialog
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Logout Failed'),
//             content: Text(
//               'An error occurred during logout. Please try again later.',
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('OK'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scada_scube/admin/profile_page.dart';
import 'package:scada_scube/home_page/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Spalsh_screen/splash_screen.dart';
import '../main.dart';

class AdminHomePage extends StatelessWidget {
  final String token;

  const AdminHomePage({required this.token}) : super();

  void _logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse('http://103.149.143.33:8000/user-api/logout/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      print('Logout successful');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Successful'),
            content: Text('You have been successfully logged out.'),
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
    } else {
      print('Logout failed');
      print(response.body);
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

  Widget buildCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Card(
      color: Color(0xFF90C126),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Log Out') {
            _logoutUser(context);
          } else {
            onPressed();
          }
        },
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48.0,
                color: Colors.white,
              ),
              SizedBox(height: 16.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhoneCardLayout(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Center(
          child: Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        buildCard(context, 'Dashboard', Icons.dashboard, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(token: token),
            ),
          );
        }),
        SizedBox(height: 16.0),
        buildCard(context, 'User Account Created', Icons.person_add, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RegPage(token: token),
            ),
          );
        }),
        SizedBox(height: 16.0),
        buildCard(context, 'Log Out', Icons.logout, () {
          _logoutUser(context);
        }),
      ],
    );
  }

  Widget buildDesktopCardLayout(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.all(16.0),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      children: [
        Center(
          child: Text(
            'Admin Dashboard',
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        buildCard(context, 'Dashboard', Icons.dashboard, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(token: token),
            ),
          );
        }),
        SizedBox(height: 16.0),
        buildCard(context, 'User Account Created', Icons.person_add, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => RegPage(token: token),
            ),
          );
        }),
        SizedBox(height: 16.0),
        buildCard(context, 'Log Out', Icons.logout, () {
          _logoutUser(context);
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF90C126),
        title: Text(
          'SCADA SCUBE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(),
              ),
            );
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 600) {
            return buildDesktopCardLayout(context);
          } else {
            return buildPhoneCardLayout(context);
          }
        },
      ),
    );
  }
}



class MyWidget extends StatefulWidget {
  final String token ;
  const MyWidget({super.key, required this.token});

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<ModuleTemperature> temperatureData = [];

  Future<void> fetchDatas(String tempToken) async {
    print('Auth Token: $tempToken');

    try {
      final response = await http.get(
        Uri.parse('http://103.149.143.33:8000/temperature-data/'),
        headers: {'Authorization': 'Token $tempToken'},
      );

      print('Response Status Code: ${response.statusCode}');
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final List<ModuleTemperature> data = responseData
            .map((item) => ModuleTemperature.fromJson(item))
            .toList();

        print('Data Length: ${data.length}');

        setState(() {
          if (data.isNotEmpty) {
            temperatureData = [data.last];
          } else {
            // temperatureData = [ModuleTemperature(/* Set your default value here */)];
          }
        });
      } else {
        setState(() {
          // temperatureData = [ModuleTemperature(/* Set your default value here */)];
        });
      }
    } catch (error) {
      print('Error fetching temperature data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the fetchDatas function with your authorization token here
    String tempToken = widget.token; // Use widget.token instead of "YOUR_AUTH_TOKEN"

    fetchDatas(tempToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Data'),
      ),
      body: Center(
        child: temperatureData.isNotEmpty
            ? ListTile(
          title: Text(
            '${temperatureData[0].moduleTemperature}°C',
            style: TextStyle(fontSize: 24),
          ),
          subtitle: Text(
            'Module Temperature',
            style: TextStyle(fontSize: 16),
          ),
        )
            : Text(
          'No temperature data available',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class ModuleTemperature {
  final double moduleTemperature;

  ModuleTemperature({required this.moduleTemperature});

  factory ModuleTemperature.fromJson(Map<String, dynamic> json) {
    return ModuleTemperature(moduleTemperature: json['module_temperature'] ?? 0.0);
  }
}


// void main() {
//   runApp(MaterialApp(
//     home: MyWidget(),
//   ));
// }
