import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:scada_scube/ambentmoduletable/modulesmodel.dart';
import 'liveradiationModel.dart';

class ApiRaditionService {
  Future<List<LiveRadiation>?> getTotalCustomerStatus() async {
    try {
      var url = Uri.parse(ApiModule.customerStatusTotal);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<LiveRadiation> _model = liveRadiationFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class ApiModule {
  static String baseUrl = 'http://103.149.143.33:8081/api';

  static String customerStatusTotal = '$baseUrl/LiveRadiation';
}
