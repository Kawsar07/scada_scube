import 'dart:developer';
import 'package:http/http.dart' as http;


import 'livepowerModel.dart';




class ApipowerLive {
  Future<List<Livepower>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(Apilive.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Livepower> _model = livepowerFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}



class Apilive {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/LivePower';
}