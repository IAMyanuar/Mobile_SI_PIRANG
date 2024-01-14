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
  Future<DataPeminjaman> detailRiwayat(String? token, int? idPeminjaman) async {
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
      DataPeminjaman detail = DataPeminjaman.fromJson(body['data']);
      return detail;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class RemoteListPengajuan {
  Future<PeminjamanModel> listPengajuan(String? token, int? idUser) async {
    PeminjamanModel? peminjamanModel;
    final response = await http.get(
      Uri.parse(ApiConfig.getListPengajuanUrl(idUser!)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      peminjamanModel = PeminjamanModel.fromJson(body);
      return peminjamanModel;
    } else {
      var body = jsonDecode(response.body);
      peminjamanModel = PeminjamanModel.fromJson(body);
      return peminjamanModel;
    }
  }
}

class RemoteFormPengajuan {
  Future<PeminjamanModel?> formPengajuan(token, namaLembaga, kegiatan,
      waktuMulai, waktuSelesai, idUser, idRuangan, image) async {
    final url = ApiConfig.postPeminjamanUrl();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..fields.addAll({
        'nama_lembaga': namaLembaga,
        'kegiatan': kegiatan,
        'tgl_mulai': waktuMulai.toString(),
        'tgl_selesai': waktuSelesai.toString(),
        'user_id': idUser!.toString(),
        'id_ruangan': idRuangan!.toString(),
      });

// Menambahkan file sebagai MultipartFile
    if (image != null) {
      final imageFile =
          await http.MultipartFile.fromPath('dokumen_pendukung', image!);
      request.files.add(imageFile);
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      // Sukses
      final responseData = jsonDecode(responseString);
      final newPeminjaman = PeminjamanModel.fromJson(responseData);
      return newPeminjaman;
    } else {
      // Gagal
      final responseData = jsonDecode(responseString);
      final newPeminjaman = PeminjamanModel.fromJson(responseData);
      return newPeminjaman;
    }
  }
}

class RemoteDeletePengajuan {
  Future deleteData(token, id) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.deletePeminjamanUrl(id)),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class RemoteFeedbackPengajuan {
  Future feedbackPengajuan(token, id, feedback) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token'
    };
    var request =
        http.Request('POST', Uri.parse(ApiConfig.patchFeedbackUrl(id)));
    request.bodyFields = {
      '_method': 'patch',
      'feedback': feedback,
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      // print(await response.stream.bytesToString());
      return true;
    } else {
      // print(response.reasonPhrase);
      // print(response.statusCode);
      return false;
    }
  }
}
