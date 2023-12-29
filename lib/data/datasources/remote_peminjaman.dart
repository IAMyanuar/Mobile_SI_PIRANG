import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:si_pirang/data/datasources/api_config.dart';
import 'package:si_pirang/data/model/peminjaman_model.dart';

class RemoteRiwayat {
  Future<PeminjamanModel> getRiwayat(
      String? token, int? idUser, String? query) async {
    PeminjamanModel? peminjamanModel;

    Uri uri = Uri.parse(ApiConfig.getRiwayatUrl(idUser!));
    Map<String, dynamic> searchData = {
      'keyword': query,
    };

    try {
      final response = await http.get(
        uri.replace(queryParameters: searchData),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        peminjamanModel = PeminjamanModel.fromJson(body);
        // riwayat = peminjamanModel.data!;
        return peminjamanModel;
      } else {
        var body = jsonDecode(response.body);
        peminjamanModel = PeminjamanModel.fromJson(body);
        return peminjamanModel;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class RemoteDetailPeminjaman {
  Future<Datum> detailRiwayat(String? token, int? idPeminjaman) async {
    // print('dcscdc ${idPeminjaman}');
    PeminjamanModel? peminjamanModel;
    final response = await http.get(
      Uri.parse(ApiConfig.getPeminjamanBYIdUrl(idPeminjaman!)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      Datum detail = Datum.fromJson(body['data']);
      return detail;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
