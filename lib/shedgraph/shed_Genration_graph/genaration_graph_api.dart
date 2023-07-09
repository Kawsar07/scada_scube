import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scada_scube/shedgraph/shed_Genration_graph/shedwise_Model_genration_graph.dart';
import 'package:scada_scube/shedgraph/shed_today_energy/shedwise_Model_TodayEnergy.dart';

class ApiGenarationService {
  Future<List<GenarationGraph>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(GenartionApiNew.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<GenarationGraph> _model =
            genarationGraphFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class GenartionApiNew {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/GraphShed';
}
