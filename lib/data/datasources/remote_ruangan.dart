import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pirang/data/datasources/api_config.dart';
import 'package:si_pirang/data/model/ruangan_model.dart';

class RemoteRuangan {
  Future<List<Datum>> getData(token) async {
    // print(token);
    List<Datum> ruangan = [];
    RuanganModel? ruanganModel;
    final response = await http.get(
      Uri.parse(ApiConfig.getAllRuanganUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // print('berhasil');
      var body = jsonDecode(response.body);

      ruanganModel = RuanganModel.fromJson(body);

      ruangan = ruanganModel.data!;
      return ruangan;
    } else {
      throw (response.statusCode);
    }
  }
}
