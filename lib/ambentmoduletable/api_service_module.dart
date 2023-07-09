import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scada_scube/ambentmoduletable/modulesmodel.dart';





class ApiModuleService {
  Future<List<ModuleTemperature>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(ApiModule.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<ModuleTemperature> _model = moduleTemperatureFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}


class ApiModule {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/TemperatureData';
}