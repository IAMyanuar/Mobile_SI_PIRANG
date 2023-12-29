import 'dart:convert';

import 'package:intl/intl.dart';

class KalenderModel {
  final String? title;
  final DateTime? start;
  final DateTime? end;
  final String? ruangan;
  final String? acaraMulai; // Variabel baru untuk waktu mulai
  final String? acaraSelesai; // Variabel baru untuk waktu selesai

  KalenderModel({
    this.title,
    this.start,
    this.end,
    this.ruangan,
    this.acaraMulai,
    this.acaraSelesai,
  });

  factory KalenderModel.fromRawJson(String str) =>
      KalenderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KalenderModel.fromJson(Map<String, dynamic> json) => KalenderModel(
        title: json["title"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        ruangan: json["ruangan"],
        acaraMulai: json["start"] == null
            ? null
            : DateFormat('HH:mm').format(DateTime.parse(json["start"])),
        acaraSelesai: json["end"] == null
            ? null
            : DateFormat('HH:mm').format(DateTime.parse(json["end"])),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "ruangan": ruangan,
        "acaraMulai": acaraMulai,
        "acaraSelesai": acaraSelesai,
      };
}
