import 'dart:convert';

class RuanganModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  RuanganModel({
    this.status,
    this.message,
    this.data,
  });

  factory RuanganModel.fromRawJson(String str) =>
      RuanganModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RuanganModel.fromJson(Map<String, dynamic> json) => RuanganModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? id;
  final String? nama;
  final String? fasilitas;
  final String? foto;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.nama,
    this.fasilitas,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        nama: json["nama"],
        fasilitas: json["fasilitas"],
        foto: json["foto"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "fasilitas": fasilitas,
        "foto": foto,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
