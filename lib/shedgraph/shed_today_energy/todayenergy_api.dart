import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scada_scube/shedgraph/shed_today_energy/shedwise_Model_TodayEnergy.dart';

class ApiEnergyService {
  Future<List<TodaysEnergy>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(TodayenergyApiNew.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<TodaysEnergy> _model =
            todaysEnergyFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class TodayenergyApiNew {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/TodayEnergy';
}
