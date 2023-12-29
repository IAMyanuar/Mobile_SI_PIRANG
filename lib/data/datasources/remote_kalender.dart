import 'dart:convert';
import 'package:si_pirang/data/model/kalender_model.dart';

import 'api_config.dart';
import 'package:http/http.dart' as http;

class RemoteKalender {
  Future<List<KalenderModel>> getData(token) async {
    final response = await http.get(
      Uri.parse(ApiConfig.getKalenderUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var data = jsonDecode(response.body) as List<dynamic>;

    if (response.statusCode == 200) {
      // print(data);
      List<KalenderModel> kalenderList = data
          .map((item) => KalenderModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return kalenderList;
    } else {
      List<KalenderModel> kalenderList = data
          .map((item) => KalenderModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return kalenderList;
      // print(data);
    }
  }
}
