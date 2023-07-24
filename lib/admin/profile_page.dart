// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:scada_scube/main.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../login_page/login_reg.dart';
//
//
// class ProfilePage extends StatefulWidget {
//   final String token;
//
//   const ProfilePage({Key? key, required this.token}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String name = '';
//   String email = '';
//   String phone = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     String? token = widget.token;
//
//     if (token == null) {
//       print('Token is null');
//       return;
//     }
//
//     String url = 'http://192.168.68.33:8000/user-api/user-profile/';
//     Map<String, String> headers = {
//       'Authorization': 'Token $token',
//     };
//
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       print('Response: ${response.statusCode} ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           name = data['name'];
//           email = data['email'];
//           phone = data['phone no']; // Update the key to 'phone no'
//         });
//       } else {
//         print('API request failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error during API request: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     final double nameFontSize = screenWidth > 600 ? 24 : 18;
//     final double detailsFontSize = screenWidth > 600 ? 20 : 16;
//
//     final double containerPadding = screenWidth > 600 ? 16 : 8;
//     final double containerHeight = screenWidth > 600 ? 56 : 40;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//       ),
//       body: Container(
//         color: Colors.grey[200], // Set background color
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Name:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Email:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 email,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Phone No:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 phone,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 300.0),
//             OutlinedButton(
//               onPressed: () {
//                 _logoutUser(context);
//               },
//               child: Text('Logout'),
//             ),
//             OutlinedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => FilterScreen(token: widget.token),
//                   ),
//                 );
//               },
//               child: Text('Filter'),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void _logoutUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('token');
//
//   final url = Uri.parse('http://192.168.68.33:8000/user-api/logout/');
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Token $token',
//   };
//
//   final response = await http.post(url, headers: headers);
//
//   if (response.statusCode == 200) {
//     print('Logout successful');
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Logout Successful'),
//           content: Text('You have been successfully logged out.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginPageNawab()),
//                 );
//               },
//
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     print('Logout failed');
//     print(response.body);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Logout Failed'),
//           content: Text(
//             'An error occurred during logout. Please try again later.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scada_scube/admin/change_password.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page/login_reg.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({Key? key, required this.token}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchData() async {
    String? token = await getToken();

    if (token == null) {
      print('Token is null');
      return;
    }

    String url = 'http://103.149.143.33:8000/user-api/user-profile/';
    Map<String, String> headers = {
      'Authorization': 'Token $token',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      // print('Response: ${response.statusCode} ${response.body}');

      if (mounted) {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            name = data['name'];
            email = data['email'];
            phone = data['phone no'];
          });
        } else {
          // print('API request failed with status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error during API request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double nameFontSize = screenWidth > 600 ? 24 : 18;
    final double detailsFontSize = screenWidth > 600 ? 20 : 16;

    final double containerPadding = screenWidth > 600 ? 16 : 8;
    final double containerHeight = screenWidth > 600 ? 56 : 40;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF90C126),
        title: const Text("SCADA SCUBE"),
        centerTitle: true,

      ),
      body: Container(
        color: Colors.grey[200], // Set the background color
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name:',
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Set the name text color
              ),
            ),
            SizedBox(height: 4.0),
            Container(
              padding: EdgeInsets.all(containerPadding),
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: detailsFontSize,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Email:',
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Set the email text color
              ),
            ),
            SizedBox(height: 4.0),
            Container(
              padding: EdgeInsets.all(containerPadding),
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                email,
                style: TextStyle(
                  fontSize: detailsFontSize,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Phone No:',
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple, // Set the phone number text color
              ),
            ),
            SizedBox(height: 4.0),
            Container(
              padding: EdgeInsets.all(containerPadding),
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                phone,
                style: TextStyle(
                  fontSize: detailsFontSize,
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(), // Added Spacer to push the buttons to the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _logoutUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Set the button background color
                      onPrimary: Colors.white, // Set the button text color
                    ),
                    child: Text('Logout'),
                  ),
                  // SizedBox(width: 16.0), // Added spacing between the buttons
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => FilterScreen(token: widget.token),
                  //       ),
                  //     );
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.deepPurple, // Set the button background color
                  //     onPrimary: Colors.white, // Set the button text color
                  //   ),
                  //   child: Text('Filter'),
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  ChangePasswordApp(token: widget.token),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Set the button background color
                      onPrimary: Colors.white, // Set the button text color
                    ),
                    child: Text('Change Password'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _logoutUser(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent users from dismissing the dialog
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(), // Circular Progress Indicator
      );
    },
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token == null) {
    print('Token is null');
    Navigator.of(context).pop(); // Close the circular progress indicator dialog
    return;
  }

  final url = Uri.parse('http://192.168.68.33:8000/user-api/logout/');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token',
  };

  final response = await http.post(url, headers: headers);

  Navigator.of(context).pop(); // Close the circular progress indicator dialog

  if (response.statusCode == 200) {
    print('Logout successful');

    // Remove the token from SharedPreferences
    await prefs.remove('token');

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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false, // Remove all previous routes
                );
              },
            ),
          ],
        );
      },
    );
  } else if (response.statusCode == 401) {
    print('Invalid token');

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
                Navigator.of(context).pop();
                // Redirect to the login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                      (route) => false, // Remove all previous routes
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
          content: Text('An error occurred during logout. Please try again later.'),
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


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// import '../login_page/login_reg.dart';
// import '../main.dart';
// import 'change_password.dart';
//
// class ProfilePage extends StatefulWidget {
//   final String token;
//
//   const ProfilePage({Key? key, required this.token}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   String name = '';
//   String email = '';
//   String phone = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   Future<void> fetchData() async {
//     String? token = widget.token;
//
//     if (token == null) {
//       print('Token is null');
//       return;
//     }
//
//     String url = 'http://192.168.68.33:8000/user-api/user-profile/';
//     Map<String, String> headers = {
//       'Authorization': 'Token $token',
//     };
//
//     try {
//       final response = await http.get(Uri.parse(url), headers: headers);
//       print('Response: ${response.statusCode} ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           name = data['name'];
//           email = data['email'];
//           phone = data['phone_no']; // Update the key to 'phone_no'
//         });
//       } else {
//         print('API request failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error during API request: $e');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     final double nameFontSize = screenWidth > 600 ? 24 : 18;
//     final double detailsFontSize = screenWidth > 600 ? 20 : 16;
//
//     final double containerPadding = screenWidth > 600 ? 16 : 8;
//     final double containerHeight = screenWidth > 600 ? 56 : 40;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF90C126),
//         title: const Text("SCADA SCUBE"),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.grey[200], // Set the background color
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Name:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple, // Set the name text color
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 name,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Email:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple, // Set the email text color
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 email,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Phone No:',
//               style: TextStyle(
//                 fontSize: nameFontSize,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepPurple, // Set the phone number text color
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Container(
//               padding: EdgeInsets.all(containerPadding),
//               height: containerHeight,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: Text(
//                 phone,
//                 style: TextStyle(
//                   fontSize: detailsFontSize,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Spacer(), // Added Spacer to push the buttons to the bottom
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       _logoutUser(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.deepPurple, // Set the button background color
//                       onPrimary: Colors.white, // Set the button text color
//                     ),
//                     child: Text('Logout'),
//                   ),
//                   SizedBox(width: 16.0), // Added spacing between the buttons
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => FilterScreen(token: widget.token),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.deepPurple, // Set the button background color
//                       onPrimary: Colors.white, // Set the button text color
//                     ),
//                     child: Text('Filter'),
//                   ),
//                   SizedBox(width: 16.0), // Added spacing between the buttons
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => ChangePasswordApp(token: widget.token),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.deepPurple, // Set the button background color
//                       onPrimary: Colors.white, // Set the button text color
//                     ),
//                     child: Text('Change Password'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void _logoutUser(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('token');
//
//   if (token == null) {
//     print('Token is null');
//     return;
//   }
//
//   final url = Uri.parse('http://192.168.68.33:8000/user-api/logout/');
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Token $token',
//   };
//
//   final response = await http.post(url, headers: headers);
//
//   if (response.statusCode == 200) {
//     print('Logout successful');
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Logout Successful'),
//           content: Text('You have been successfully logged out.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => LoginPageNawab()),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     print('Logout failed');
//     print(response.body);
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Logout Failed'),
//           content: Text(
//             'An error occurred during logout. Please try again later.',
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
