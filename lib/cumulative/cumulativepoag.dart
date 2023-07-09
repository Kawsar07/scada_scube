import 'dart:developer';
import 'package:http/http.dart' as http;
import 'model/cumulative.dart';

class ApiCumupoa {
  Future<List<Cumulative>?>getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(Api.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Cumulative> _model = cumulativeFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class Api {
  static String baseUrl = 'http://103.149.143.33:8081/api';
  static String customerStatusTotal = '$baseUrl/CumulativeDatas';
}
