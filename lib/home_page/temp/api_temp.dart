import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const _apiKey = 'c43eb5a1c0fabde8d4554ae83fc59202';
  static const _apiUrl = 'https://api.openweathermap.org/data/2.5';

  static Future<Map<String, dynamic>> getCurrentWeatherData(int cityId) async {
    final response = await http.get(Uri.parse('$_apiUrl/weather?id=$cityId&APPID=$_apiKey'));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getForecastData(int cityId) async {
    final response = await http.get(Uri.parse('$_apiUrl/forecast?id=$cityId&APPID=$_apiKey'));
    return json.decode(response.body);
  }
}
