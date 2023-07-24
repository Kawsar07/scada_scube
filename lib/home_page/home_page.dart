import 'package:flutter/material.dart';
import 'package:scada_scube/analysis/analysis_home.dart';
import 'package:scada_scube/home_page/Home_dash.dart';
import 'package:scada_scube/main.dart';
import '../admin/profile_page.dart';
import '../ambentmoduletable/Module_home_screen.dart';
import '../analysis/home_analysis.dart';
import '../cumulative/CumuHomeViews.dart';
import '../shedgraph/shed_Genration_graph/genaration_graph_home.dart';
import '../shedgraph/shed_today_energy/today_energy_home.dart';
import '../shedgraph/shed_yesters_energy/yester_energy_home.dart';
import 'newpage_home.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool isFlipped = false;

  bool value1 = true;

  List<Widget> get screen {
    return [
      HomeDashBroad(token: widget.token),
      TabBarApp(token: widget.token),
       // FilterApp(token: widget.token),
      AnalysisHome(token: widget.token),
      ProfilePage(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: Color(0xFF90C126),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  child: UserAccountsDrawerHeader(
                    accountName: const Text(
                      'Scada Scube',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    accountEmail: const Text(
                      'Solar Monitoring System',
                      style: TextStyle(color: Colors.black),
                    ),
                    currentAccountPicture: Stack(
                      children: [
                        Image.asset("assets/image/jpllogo.png"),
                        Container(
                          transform:
                              Matrix4.translationValues(100.0, -5.0, 0.0),
                          height: 150,
                          width: 200,
                          child: Image.asset("assets/image/img.png",
                              height: 150, width: 200),
                        ),
                        Container(
                          transform:
                              Matrix4.translationValues(200.0, -5.0, 0.0),
                          height: 200,
                          width: 200,
                          child: Image.asset("assets/image/robinlogo.png",
                              height: 200, width: 200),
                        ),
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyWidget()));
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.cloud,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Temperature',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {},
                  child: ExpansionTile(
                    trailing: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      Icons.cabin,
                      size: 25.0,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'ShedWise',
                      style: TextStyle(color: Colors.white),
                    ),
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GenarationHome()));
                        },
                        child: const ListTile(
                          leading: Padding(
                            padding: EdgeInsets.fromLTRB(55.0, 5.0, 2.0, 5.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.4, 0),
                            child: Text(
                              'ShedWise Generation Graph',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TodayenergyHome()));
                        },
                        child: const ListTile(
                          leading: Padding(
                            padding: EdgeInsets.fromLTRB(55.0, 5.0, 2.0, 5.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.2, 0),
                            child: Text(
                              'ShedWise Todays Energy',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => YesterenergyHome()));
                        },
                        child: const ListTile(
                          leading: Padding(
                            padding: EdgeInsets.fromLTRB(55.0, 5.0, 2.0, 5.0),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          title: Align(
                            alignment: Alignment(-1.3, 0),
                            child: Text(
                              'ShedWise Yesterdays Energy',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 300,
                ),
                const Divider(
                  thickness: 2,
                ),
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    title: Text(
                      'Developed By Scube Technologies Ltd.',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedFontSize: 12,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF90C126),
          selectedFontSize: 15,
          currentIndex: currentIndex,
          onTap: (index) => setState(
            () => currentIndex = index,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Analysis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',

            ),
          ],
        ),
        body: Center(
          child: screen[currentIndex],
        ),
      ),
    );
  }
}
