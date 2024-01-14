import 'dart:convert';
import 'package:si_pirang/data/model/register.dart';

import 'api_config.dart';
import 'package:http/http.dart' as http;

class RemoteRegister {
  //coba
  Future<RegisterModel> register(RegisterModel newUser) async {
    // print(jsonEncode(newUser.toJson()));
    final response = await http.post(
      Uri.parse(ApiConfig.postRegisterUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser.toJson()),
    );
    var data = jsonDecode(response.body);
    RegisterModel? newUser1;

    if (response.statusCode == 201) {
      // print('berhasil');
      newUser1 = RegisterModel.fromJson(data);
    } else {
      // print('gagal');
      newUser1 = RegisterModel.fromJsonFail(data);
    }

    if (newUser1.status == true) {
      return newUser1;
    } else {
      newUser1.status == false;
      return newUser1;
    }
  }
}
