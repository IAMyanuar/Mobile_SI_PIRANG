import 'dart:convert';
import 'package:si_pirang/data/model/register.dart';

import 'api_config.dart';
import 'package:http/http.dart' as http;

class RemoteRegister {
  // Future register(nim, nama, email, password, telp) async {
  //   var request =
  //       http.MultipartRequest('POST', Uri.parse(ApiConfig.getRegisterUrl()));
  //   request.fields.addAll({
  //     'nim': '$nim',
  //     'nama': '$nama',
  //     'email': '$email',
  //     'password': '$password',
  //     'telp': '$telp'
  //   });

  //coba
  Future<RegisterModel> register(RegisterModel newUser) async {
    print(jsonEncode(newUser.toJson()));
    final response = await http.post(
      Uri.parse(ApiConfig.getRegisterUrl()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser.toJson()),
    );
    var data = jsonDecode(response.body);
    RegisterModel? newUser1;

    if (response.statusCode == 201) {
      print('berhasil');
      newUser1 = RegisterModel.fromJson(data);
    } else {
      print('gagal');
      newUser1 = RegisterModel.fromJsonFail(data);
    }

    if (newUser1.status == true) {
      return newUser1;
    } else {
      newUser1.status == false;
      return newUser1;
    }
  }

  //   var response = await request.send();

  //   if (response.statusCode == 201) {
  //     // print(await response.stream.bytesToString());
  //     return true;
  //   } else {
  //     // print(await response.stream.bytesToString());
  //     return false;
  //   }
  // }
}
