import 'dart:convert';

class LoginModel {
  final bool? status;
  final String? message;
  final String? nama;
  final int? idUser;
  final String? token;
  final String? role;
  final String? nim;
  final String? password;

  LoginModel(
      {this.status,
      this.message,
      this.nama,
      this.idUser,
      this.token,
      this.role,
      this.nim,
      this.password});

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      status: json["status"],
      message: json["message"],
      nama: json["nama"],
      idUser: json["id_user"],
      token: json["token"],
      role: json["role"],
      nim: json["nim"],
      password: json["password"]);

  factory LoginModel.fromJsonFail(Map<String, dynamic> json) => LoginModel(
      status: json["status"],
      message: json["message"],
      nama: null,
      idUser: null,
      token: null,
      role: null,
      nim: null,
      password: null);

  Map<String, dynamic> toJson() => {"nim": nim, "password": password};
}
