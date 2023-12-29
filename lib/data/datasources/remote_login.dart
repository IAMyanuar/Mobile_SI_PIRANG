import 'dart:convert';
import 'api_config.dart';
import 'package:http/http.dart' as http;
import 'package:si_pirang/data/model/login_model.dart';

class RemoteLogin {
  Future<LoginModel> login(LoginModel user) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.getLoginUrl()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == true && data['role'] == "user") {
          return LoginModel.fromJson(data); // Login berhasil
        } else {
          throw Exception('Failed to load data'); // Login gagal
        }
      } else {
        // Handle jika request tidak berhasil (response status code bukan 200 OK)
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle jika terjadi error selama proses request
      print('Error: $e');
      return LoginModel.fromJsonFail(
          {'status': false, 'message': 'Username Or Password incorrect'});
    }
  }
}
