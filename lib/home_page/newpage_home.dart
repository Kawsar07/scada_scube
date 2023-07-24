import 'package:flutter/material.dart';
import 'package:scada_scube/filter/filter_acdc.dart';
import 'package:scada_scube/filter/filter_acdc_daily.dart';
import 'package:scada_scube/filter/filter_radation_month.dart';
import 'package:scada_scube/filter/filter_temp_daily.dart';
import 'package:scada_scube/home_page/view/newpage_1.dart';

import '../filter/filter_radiation_daily.dart';
import '../filter/filter_temp_month.dart';

class TabBarApp extends StatelessWidget {
  final String token;

  TabBarApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: TabBarExample(
        token: token,
      ),
    );
  }
}

class TabBarExample extends StatelessWidget {
  final String token;

  TabBarExample({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nawab Monitoring Data Filter'),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: 'Ac Dc Power',
                icon: ImageIcon(
                  AssetImage('assets/image/energy.png'),
                  color: Color(0xFF90C126),
                ),
              ),
              Tab(
                text: 'Temperature',
                icon: ImageIcon(
                  AssetImage('assets/image/temp.png'),
                  color: Color(0xFF90C126),
                ),
              ),
              Tab(
                text: 'Radiation',
                icon: ImageIcon(
                  AssetImage('assets/image/nawabpanel.png'),
                  color: Color(0xFF90C126),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            NestedTabBar(
              'Trips',
              token: token,
            ),
            NestedTabBar2(
              'Trips',
              token: token,
            ),
            NestedTabBar3(
              'Explore',
              token: token,
            ),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  final String token;

  const NestedTabBar(this.outerTab, {super.key, required this.token});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(16.0),
                child: FilterAcdcDailyApp(
                  token: widget.token,
                ),


                // NewPage(),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  child: FilterApp(
                    token: widget.token,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NestedTabBar2 extends StatefulWidget {
  final String token;

  const NestedTabBar2(this.outerTab, {super.key, required this.token});

  final String outerTab;

  @override
  State<NestedTabBar2> createState() => _NestedTabBar2State();
}

class _NestedTabBar2State extends State<NestedTabBar2>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(16.0),
                child: FiltertempdayApp(
                  token: widget.token,
                ),


                // NewPage(),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  child: FiltertempmonthApp(
                    token: widget.token,
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class NestedTabBar3 extends StatefulWidget {
  final String token;

  const NestedTabBar3(this.outerTab, {super.key, required this.token});

  final String outerTab;

  @override
  State<NestedTabBar3> createState() => _NestedTabBar3State();
}

class _NestedTabBar3State extends State<NestedTabBar3>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar.secondary(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Card(
                margin: const EdgeInsets.all(16.0),
                child: FilterRadiationDailyApp(
                  token: widget.token,
                ),


                // NewPage(),
              ),
              Card(
                margin: const EdgeInsets.all(16.0),
                child: Center(
                  child: FilterRadiationApp(
                    token: widget.token,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
