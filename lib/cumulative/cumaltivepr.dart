import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scada_scube/cumulative/model/cumulative.dart';

class ApiCumu {
  Future<List<Cumulative>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(ApiCumative.customerStatusTotal);
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

class ApiCumative {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/CumulativeDatas';
}
