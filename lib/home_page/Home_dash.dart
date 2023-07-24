import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:scada_scube/ambentmoduletable/modulesmodel.dart';
import 'package:scada_scube/home_page/view/inmodel/profit.dart';
import 'package:scada_scube/home_page/view/inmodel/radiation_model.dart';
import 'package:scada_scube/liveRdaition%20table%20/liveraditionHome.dart';
import '../../TimeGraph/prgraph.dart';
import '../../ambentmoduletable/Module_home_screen.dart';
import '../../live_power/live_power_table.dart';
import '../../live_power/livepowergraph.dart';
import '../cumulative/model/cumulative.dart';
import '../shedgraph/shed_today_energy/shedwise_Model_TodayEnergy.dart';
import '../shedgraph/shed_yesters_energy/shedwise_Model_yesterEnergy.dart';

class HomeDashBroad extends StatefulWidget {
  final String token;

  const HomeDashBroad({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeDashBroad> createState() => _HomeDashBroadState();
}

class _HomeDashBroadState extends State<HomeDashBroad> {
  late String token; // Add a variable to store the token value

  late Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(duration, (_) {
      // Pass the token from the widget to the fetchDatas method
      fetchData();
      fetchLiveradiationData();
      fetchCumulativeData();
      fetchGenerationData();
      fetchTodaysGeneration();
      fetchYesterdaysGeneration();
      String tempToken =
          widget.token; // Use widget.token instead of "YOUR_AUTH_TOKEN"

      fetchDatas(tempToken);
    });
  }

  var currentTemperature;
  var currentWeatherDescription = '';
  var tomorrowTemperature;
  var tomorrowWeatherDescription = '';
  LiveRadiation? liveradiationData;
  Profit? latestProfit;
  List<ModuleTemperature> temperatureData = [];

  Future<void> fetchDatas(String tempToken) async {
    print('Auth Token: $tempToken');

    try {
      final response = await http.get(
        Uri.parse('http://103.149.143.33:8000/temperature-data/'),
        headers: {'Authorization': 'Token $tempToken'},
      );

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

  Future<int?> fetchTodaysGeneration() async {
    final response = await http.get(
      Uri.parse('http://103.149.143.33:8081/api/TodayEnergy'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        final todaysEnergy = TodaysEnergy.fromJson(jsonData.last);
        return todaysEnergy.todaysGeneration;
      } else {
        throw Exception('No Generation Data available');
      }
    } else {
      throw Exception('Failed to fetch today\'s energy data');
    }
  }

  Future<int?> fetchYesterdaysGeneration() async {
    try {
      final response = await http
          .get(Uri.parse('http://103.149.143.33:8081/api/YesterdaysEnergy'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          final yesterdaysEnergy = YesterdaysEnergy.fromJson(jsonData.last);
          return yesterdaysEnergy.yesterdaysGeneration;
        } else {
          throw Exception('No Generation Data available');
        }
      } else {
        throw Exception('Failed to fetch yesterday\'s energy data');
      }
    } catch (e) {
      // Handle exceptions here, you can log them or return a default value.
      print('Error fetching data: $e');
      return null; // Return null or any other default value as needed.
    }
  }

  Future<void> fetchData() async {
    const url = 'http://103.149.143.33:8081/api/SavingAndProfit';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          setState(() {
            latestProfit = Profit.fromJson(jsonResponse.last);
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<LiveRadiation?> fetchLiveradiationData() async {
    try {
      final response = await http
          .get(Uri.parse('http://103.149.143.33:8081/api/LiveRadiation'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        if (jsonList.isNotEmpty) {
          LiveRadiation liveradiation = LiveRadiation.fromJson(jsonList.last);
          return liveradiation;
        } else {
          return null; // No data available, return null instead of throwing an exception
        }
      } else {
        return null; // Failed to fetch data, return null instead of throwing an exception
      }
    } catch (e) {
      return null; // Catch any exception and return null instead of throwing an exception
    }
  }

  Future<List<Generation>> fetchGenerationData() async {
    final response = await http
        .get(Uri.parse('http://103.149.143.33:8081/api/GenerationGraph'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      if (jsonList.isNotEmpty) {
        List<Generation> generationList = generationFromJson(response.body);
        return generationList;
      } else {
        throw Exception('no Generation data available');
      }
    } else {
      throw Exception('Failed to fetch generation data');
    }
  }

  Future<List<Cumulative>> fetchCumulativeData() async {
    final response = await http
        .get(Uri.parse('http://103.149.143.33:8081/api/CumulativeDatas'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);

      if (jsonList.isNotEmpty) {
        List<Cumulative> cumulativeList = cumulativeFromJson(response.body);
        return cumulativeList;
      } else {
        throw Exception('no today\'s data available');
      }
    } else {
      throw Exception(
          'Failed to fetch cumulative data. Status code: ${response.statusCode}');
    }
  }

  int itemCount = 2;

  Future<void> getWeatherData() async {
    try {
      // Get current weather data
      var currentWeatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?id=1185241&APPID=c43eb5a1c0fabde8d4554ae83fc59202';
      var currentWeatherResponse = await http.get(Uri.parse(currentWeatherUrl));
      var currentWeatherData = jsonDecode(currentWeatherResponse.body);
      var kelvinCurrentTemp = currentWeatherData['main']['temp'];
      setState(() {
        currentTemperature = kelvinCurrentTemp - 273.15;
        var currentWeatherConditions = currentWeatherData['weather'];
        currentWeatherDescription = currentWeatherConditions[0]['description'];
      });

      // Get forecast data for the next 5 days
      var forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?id=1185241&APPID=c43eb5a1c0fabde8d4554ae83fc59202';
      var forecastResponse = await http.get(Uri.parse(forecastUrl));
      var forecastData = jsonDecode(forecastResponse.body);

      // Find the forecast for tomorrow
      var tomorrowTimestamp =
          DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;
      var tomorrowDataList = forecastData['list'] as List<dynamic>;

      var tomorrowData = tomorrowDataList.firstWhere(
        (data) =>
            DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000).day ==
            DateTime.now().day + 1,
        orElse: () => null,
      );

      if (tomorrowData == null) {
        print('No forecast data found for tomorrow.');
      } else {
        var kelvinTomorrowTemp = tomorrowData['main']['temp'];
        setState(() {
          tomorrowTemperature = kelvinTomorrowTemp - 273.15;
          var tomorrowWeatherConditions = tomorrowData['weather'];
          tomorrowWeatherDescription =
              tomorrowWeatherConditions[0]['description'];
        });
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    token = widget.token; // Initialize the token variable with widget.token
    fetchData();
    startTimer();
    String tempToken =
        widget.token; // Use widget.token instead of "YOUR_AUTH_TOKEN"

    fetchDatas(tempToken);

    token = widget.token;
    getWeatherData();
    fetchCumulativeData();
    fetchGenerationData();
    fetchTodaysGeneration();

    fetchYesterdaysGeneration();
    fetchLiveradiationData().then((data) {
      setState(() {
        liveradiationData = data;
      });
    });
    // fetchDatas(token); // Pass the token to fetchDatas
  }

  String getWeatherImagePath(String weatherDescription) {
    if (weatherDescription.contains('rain')) {
      return 'assets/image/rain.png';
    } else if (weatherDescription.contains('cloud')) {
      return 'assets/image/cloud.png';
    } else {
      return 'assets/image/sun.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double fontSize = width * 0.05;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF90C126),
              title: const Text("SCADA SCUBE"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            body: SafeArea(
              child: Builder(builder: (BuildContext context) {
                return ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    ResponsiveBuilder(builder: (context, sizingInformation) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 145,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.tablet
                                      ? double.infinity
                                      : 180,
                                  transform:
                                      Matrix4.translationValues(1.0, 4.0, 0.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'REIMBURSEMENT',
                                          style: GoogleFonts.lato(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Divider(thickness: 2),
                                        const SizedBox(height: 5),
                                        ListTile(
                                          visualDensity: const VisualDensity(
                                              horizontal: 0, vertical: -4),
                                          leading: SizedBox(
                                            height: 35,
                                            width: 30,
                                            child: Image.asset(
                                              'assets/image/profit.png',
                                              color: Color(0xFF90C126),
                                            ),
                                          ),
                                          title: Text(
                                            '${latestProfit?.grossProfit ?? ''}৳\nGrossProfit\n',
                                            style: GoogleFonts.lato(
                                              fontSize: 11,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${latestProfit?.nawabSaving ?? ''}৳\nSaving',
                                            style: GoogleFonts.lato(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  transform:
                                      Matrix4.translationValues(1.0, 4.0, 0.0),
                                  height: 145,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.tablet
                                      ? double.infinity
                                      : 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'WEATHER',
                                          style: GoogleFonts.lato(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Divider(thickness: 2),
                                        ListTile(
                                          visualDensity: const VisualDensity(
                                              horizontal: -3, vertical: -3),
                                          leading: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Image.asset(
                                              getWeatherImagePath(
                                                  currentWeatherDescription),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          title: Text(
                                            currentTemperature != null
                                                ? '${currentTemperature.toStringAsFixed(1)}°C\ncurrently'
                                                : 'Loading...',
                                            style: GoogleFonts.lato(
                                              fontSize: 8,
                                            ),
                                          ),
                                          trailing: Text(
                                            currentWeatherDescription != ''
                                                ? currentWeatherDescription
                                                    .toUpperCase()
                                                : 'Loading...',
                                            style: GoogleFonts.lato(
                                              fontSize: 5,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          visualDensity: const VisualDensity(
                                              horizontal: -4, vertical: -2),
                                          leading: Image.asset(
                                            getWeatherImagePath(
                                                tomorrowWeatherDescription),
                                            height: 25,
                                            width: 25,
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            tomorrowTemperature != null
                                                ? '${tomorrowTemperature.toStringAsFixed(1)}°C\ntomorrow'
                                                : 'Loading...',
                                            style: GoogleFonts.lato(
                                              fontSize: 8,
                                            ),
                                          ),
                                          trailing: Text(
                                            tomorrowWeatherDescription != ''
                                                ? tomorrowWeatherDescription
                                                    .toUpperCase()
                                                : 'Loading...',
                                            style: GoogleFonts.lato(
                                              fontSize: 5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 130,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.tablet
                                      ? double.infinity
                                      : 180,
                                  transform:
                                      Matrix4.translationValues(3.0, 5.0, 0.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MyWidget(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'SENSOR DATA',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Divider(thickness: 2),
                                          const SizedBox(height: 3),
                                          if (temperatureData.isNotEmpty)
                                            ListTile(
                                              title: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Image.asset(
                                                  'assets/image/temp.png',
                                                  fit: BoxFit.contain,
                                                  color:
                                                      const Color(0xFF90C126),
                                                ),
                                              ),
                                              trailing: Text(
                                                '${temperatureData[0].moduleTemperature}°C\nModule Temperature\n',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          if (temperatureData.isEmpty)
                                            ListTile(
                                              title: Text(
                                                'No temperature data available',
                                                style: GoogleFonts.lato(
                                                  fontSize: 7,
                                                  color:
                                                      const Color(0xFF90C126),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 130,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.desktop
                                      ? double.infinity
                                      : 180,
                                  transform: Matrix4.translationValues(
                                    MediaQuery.of(context).size.width < 1200
                                        ? 3.0
                                        : 183.0,
                                    MediaQuery.of(context).size.width < 1200
                                        ? 5.0
                                        : -20.0,
                                    0.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RaditionHome()),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'SOLAR IRRADIATION',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          ListTile(
                                            visualDensity: const VisualDensity(
                                              horizontal: 0,
                                              vertical: -4,
                                            ),
                                            leading: Image.asset(
                                              'assets/image/nawabpanel.png',
                                              height: 25,
                                              width: 25,
                                              fit: BoxFit.contain,
                                              color: const Color(0xFF90C126),
                                            ),
                                            title: liveradiationData != null
                                                ? Text(
                                                    'East : ${liveradiationData!.east?.round() ?? "No data available"}\n'
                                                    'West : ${liveradiationData!.west?.round() ?? "No data available"}\n'
                                                    'North : ${liveradiationData!.north?.round() ?? "No data available"}\n'
                                                    'South : ${liveradiationData!.south?.round() ?? "No data available"}\n'
                                                    'South 15° : ${liveradiationData!.southF?.round() ?? "No data available"}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : Text('No data available',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 150,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.tablet
                                      ? double.infinity
                                      : 180,
                                  transform:
                                      Matrix4.translationValues(3.0, 5.0, 0.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyWidget()),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      color: Colors.white,
                                      elevation: 3,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Today\'s Data',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Divider(thickness: 2),
                                          const SizedBox(height: 3),
                                          FutureBuilder<List<Cumulative>>(
                                            future: fetchCumulativeData(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                // Display the data using ListTile or any other widget
                                                Cumulative latestData =
                                                    snapshot.data!.last;
                                                return ListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                          horizontal: 4,
                                                          vertical: -4),
                                                  leading: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Image.asset(
                                                      'assets/image/checked.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    '${latestData.cumulativePr?.toStringAsFixed(3)}\nTotal Pr\n',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    '${latestData.cumulativePoaAvg?.toStringAsFixed(3)}\nCumulative Poa Avg',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return ListTile(
                                                  title: Text(
                                                    'Error: ${snapshot.error}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xFF90C126),
                                                    ),
                                                  ),
                                                );
                                              }
                                              return const SizedBox(); // Show a loading indicator while fetching data
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 150,
                                  width: sizingInformation.deviceScreenType ==
                                          DeviceScreenType.desktop
                                      ? double.infinity
                                      : 180,
                                  transform: Matrix4.translationValues(
                                    MediaQuery.of(context).size.width < 1200
                                        ? 3.0
                                        : 183.0,
                                    MediaQuery.of(context).size.width < 1200
                                        ? 5.0
                                        : -20.0,
                                    0.0,
                                  ),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.white,
                                    elevation: 3,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Generation',
                                            style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          FutureBuilder<int?>(
                                            future: fetchTodaysGeneration(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final todaysGeneration =
                                                    snapshot.data!;
                                                return ListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: 0,
                                                    vertical: -4,
                                                  ),
                                                  leading: Image.asset(
                                                    'assets/image/power.png',
                                                    height: 25,
                                                    width: 25,
                                                    fit: BoxFit.contain,
                                                    color:
                                                        const Color(0xFF90C126),
                                                  ),
                                                  title: Text(
                                                    'Today\'s Generation: $todaysGeneration',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return ListTile(
                                                  title: Text(
                                                    'Error: ${snapshot.error}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return ListTile(
                                                title: Text(
                                                  'Fetching data...',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          FutureBuilder<int?>(
                                            future: fetchYesterdaysGeneration(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final yesterdaysGeneration =
                                                    snapshot.data!;
                                                return ListTile(
                                                  visualDensity:
                                                      const VisualDensity(
                                                    horizontal: 0,
                                                    vertical: -4,
                                                  ),
                                                  leading: Image.asset(
                                                    'assets/image/energy.png',
                                                    height: 25,
                                                    width: 25,
                                                    fit: BoxFit.contain,
                                                    color:
                                                        const Color(0xFF90C126),
                                                  ),
                                                  title: Text(
                                                    'Yesterday\'s Generation: $yesterdaysGeneration',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return ListTile(
                                                  title: Text(
                                                    'Error: ${snapshot.error}',
                                                    style: GoogleFonts.lato(
                                                      fontSize: 10,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return ListTile(
                                                title: Text(
                                                  'Fetching data...',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LiveTable()),
                              );
                            },
                            child: Container(
                              transform: Matrix4.translationValues(
                                MediaQuery.of(context).size.width < 1200
                                    ? 15.0
                                    : 50.0,
                                MediaQuery.of(context).size.width < 1200
                                    ? 20.0
                                    : -80.0,
                                0.0,
                              ),
                              child: Text(
                                "Energy and power - PV",
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LiveTable()),
                              );
                            },
                            child: Container(
                              transform: Matrix4.translationValues(
                                MediaQuery.of(context).size.width < 600
                                    ? 100.0
                                    : MediaQuery.of(context).size.width < 1200
                                        ? 150.0
                                        : 50.0,
                                MediaQuery.of(context).size.width < 600
                                    ? 35.0
                                    : MediaQuery.of(context).size.width < 1200
                                        ? 50.0
                                        : -50.0,
                                0.0,
                              ),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final containerSize =
                                      constraints.maxWidth < 600
                                          ? 250.0
                                          : constraints.maxWidth < 1200
                                              ? 300.0
                                              : 250.0;

                                  return Container(
                                    transform: Matrix4.translationValues(
                                        -19.0, 5.0, 0.0),
                                    height: containerSize,
                                    width: containerSize,
                                    child: GaugeScreen(),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(
                              MediaQuery.of(context).size.width < 1200
                                  ? 15.0
                                  : 50.0,
                              MediaQuery.of(context).size.width < 1200
                                  ? 15.0
                                  : 190.0,
                              0.0,
                            ),
                            child: Text(
                              "Daily Generation 6am To 7pm Data",
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            transform: Matrix4.translationValues(
                              MediaQuery.of(context).size.width < 600
                                  ? -10.0
                                  : 0.0,
                              MediaQuery.of(context).size.width < 600
                                  ? 12.0
                                  : 15.0,
                              0.0,
                            ),
                            height: MediaQuery.of(context).size.width < 1200
                                ? 400
                                : 400,
                            width: MediaQuery.of(context).size.width < 1200
                                ? 400
                                : 500,
                            child: const Charts2(),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // Container(
                          //   transform: Matrix4.translationValues(
                          //     MediaQuery.of(context).size.width < 1200
                          //         ? 30.0
                          //         : 50.0,
                          //     MediaQuery.of(context).size.width < 1200
                          //         ? -25.0
                          //         : 5.0,
                          //     0.0,
                          //   ),
                          //   child: Text(
                          //     "Radiation And Power Last 30 Days Data",
                          //     style: GoogleFonts.lato(
                          //       fontSize: 16,
                          //       color: Colors.deepPurple,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   transform: Matrix4.translationValues(
                          //     MediaQuery.of(context).size.width < 600
                          //         ? 0.0
                          //         : 0.0,
                          //     MediaQuery.of(context).size.width < 600
                          //         ? -20.0
                          //         : -10.0,
                          //     0.0,
                          //   ),
                          //   height: MediaQuery.of(context).size.width < 600
                          //       ? 400
                          //       : 400,
                          //   width: MediaQuery.of(context).size.width < 600
                          //       ? 500
                          //       : 500,
                          //   child: const ChartsScreen(),
                          // ),
                          // Container(
                          //   transform: Matrix4.translationValues(
                          //     MediaQuery.of(context).size.width < 600
                          //         ? 0.0
                          //         : 0.0,
                          //     MediaQuery.of(context).size.width < 600
                          //         ? -20.0
                          //         : -10.0,
                          //     0.0,
                          //   ),
                          //   height: MediaQuery.of(context).size.width < 600
                          //       ? 400
                          //       : 400,
                          //   width: MediaQuery.of(context).size.width < 600
                          //       ? 500
                          //       : 500,
                          //   child: const Charts3(),
                          // ),
                          Center(
                            child: Container(
                              transform: Matrix4.translationValues(
                                MediaQuery.of(context).size.width < 600
                                    ? 15.0
                                    : 10.0,
                                MediaQuery.of(context).size.width < 600
                                    ? -5.0
                                    : 20.0,
                                0.0,
                              ),
                              child: const Text(
                                '©2023 [Scube Technologies Ltd]. All rights reserved.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }),
            )));
  }
}
