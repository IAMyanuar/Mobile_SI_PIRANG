import 'dart:convert';

class RegisterModel {
  final bool? status;
  final String? message;
  final String? nim;
  final String? nama;
  final String? email;
  final String? password;
  final String? telp;

  RegisterModel({
    this.status,
    this.message,
    required this.nim,
    required this.nama,
    required this.email,
    required this.password,
    required this.telp,
  });

  factory RegisterModel.fromRawJson(String str) =>
      RegisterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        status: json["status"],
        message: json["message"],
        nim: json["nim"],
        nama: json["nama"],
        email: json["email"],
        password: json["password"],
        telp: json["telp"],
      );

  factory RegisterModel.fromJsonFail(Map<String, dynamic> json) =>
      RegisterModel(
        status: json["status"],
        message: json["message"],
        nim: null,
        nama: null,
        email: null,
        password: null,
        telp: null,
      );

  Map<String, dynamic> toJson() => {
        "nim": nim,
        "nama": nama,
        "email": email,
        "password": password,
        "telp": telp,
      };
}
