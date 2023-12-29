import 'dart:convert';

class PeminjamanModel {
  final bool? status;
  final String? message;
  final List<Datum>? data;

  PeminjamanModel({
    this.status,
    this.message,
    this.data,
  });

  factory PeminjamanModel.fromRawJson(String str) =>
      PeminjamanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PeminjamanModel.fromJson(Map<String, dynamic> json) =>
      PeminjamanModel(
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
  final String? namaUser;
  final String? namaLembaga;
  final String? kegiatan;
  final DateTime? tglMulai;
  final String? jamMulai;
  final DateTime? tglSelesai;
  final String? jamSelesai;
  final String? status;
  final String? feedback;
  final String? dokumenPendukung;
  final String? namaRuangan;
  final String? nim;
  final String? email;
  final String? telp;

  Datum({
    this.id,
    this.namaUser,
    this.namaLembaga,
    this.kegiatan,
    this.tglMulai,
    this.jamMulai,
    this.tglSelesai,
    this.jamSelesai,
    this.status,
    this.feedback,
    this.dokumenPendukung,
    this.namaRuangan,
    this.nim,
    this.email,
    this.telp,
  });

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaUser: json["nama_user"],
        namaLembaga: json["nama_lembaga"],
        kegiatan: json["kegiatan"],
        tglMulai: json["tgl_mulai"] == null
            ? null
            : DateTime.parse(json["tgl_mulai"]),
        jamMulai: json["jam_mulai"],
        tglSelesai: json["tgl_selesai"] == null
            ? null
            : DateTime.parse(json["tgl_selesai"]),
        jamSelesai: json["jam_selesai"],
        status: json["status"],
        feedback: json["feedback"],
        dokumenPendukung: json["dokumen_pendukung"],
        namaRuangan: json["nama_ruangan"],
        nim: json["nim"],
        email: json["email"],
        telp: json["telp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_user": namaUser,
        "nama_lembaga": namaLembaga,
        "kegiatan": kegiatan,
        "tgl_mulai":
            "${tglMulai!.day.toString().padLeft(2, '0')}-${tglMulai!.month.toString().padLeft(2, '0')}-${tglMulai!.year.toString().padLeft(4, '0')}",
        "jam_mulai": jamMulai,
        "tgl_selesai":
            "${tglSelesai!.year.toString().padLeft(4, '0')}-${tglSelesai!.month.toString().padLeft(2, '0')}-${tglSelesai!.day.toString().padLeft(2, '0')}",
        "jam_selesai": jamSelesai,
        "status": status,
        "feedback": feedback,
        "dokumen_pendukung": dokumenPendukung,
        "nama_ruangan": namaRuangan,
        "nim": nim,
        "email": email,
        "telp": telp,
      };
}
