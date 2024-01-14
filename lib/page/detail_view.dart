import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_peminjaman.dart';
import 'package:si_pirang/data/model/peminjaman_model.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class DetailPengajuan extends StatefulWidget {
  const DetailPengajuan({Key? key}) : super(key: key);

  @override
  State<DetailPengajuan> createState() => _DetailPengajuanState();
}

class _DetailPengajuanState extends State<DetailPengajuan> {
  int? idPeminjaman;
  DataPeminjaman? detail;
  String? token;
  bool isLoading = false;
  bool? status;

  final TextEditingController searchController = TextEditingController();

  Future<void> detailRiwayat(int? idPeminjaman) async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });

    DataPeminjaman response =
        await RemoteDetailPeminjaman().detailRiwayat(token, idPeminjaman);

    setState(() {
      detail = response;
      isLoading = false;
    });
  }

  Future initFunction() async {
    await Future.delayed(Duration.zero, () {
      var args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        idPeminjaman = args['idPeminjaman'];
        detailRiwayat(idPeminjaman);
      });
    });
  }

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff5e6ac0),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 0),
            Text(
              'Detail Pengajuan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 0.0,
                  child: CircularProgressIndicator(),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Colors.grey[200],
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextRow('Nama Peminjam', '${detail?.namaUser}'),
                          buildTextRow('Nim Peminjam', '${detail?.nim}'),
                          buildTextRow(
                              'Nama Lembaga', '${detail?.namaLembaga}'),
                          buildTextRow('Kegiatan', '${detail?.kegiatan}'),
                          buildTextRow(
                              'Nama Ruangan', '${detail?.namaRuangan}'),
                          buildTextRow(
                            'Tanggal Mulai',
                            '${detail!.tglMulai != null ? DateFormat('dd-MM-yyyy').format(detail!.tglMulai!) : ""} | ${detail!.jamMulai != null ? detail!.jamMulai! : ""}',
                          ),
                          buildTextRow('Tanggal Selesai',
                              '${detail!.tglSelesai != null ? DateFormat('dd-MM-yyyy').format(detail!.tglSelesai!) : ""}  | ${detail!.jamSelesai != null ? detail!.jamSelesai! : ""}'),
                          Visibility(
                            visible: detail?.feedback != null,
                            child:
                                buildTextRow('feedback', '${detail?.feedback}'),
                          ),
                          buildTextRow('Dokumen Pendukung', ''),
                          const SizedBox(height: 8.0),
                          buildDocumentViewer(detail!.dokumenPendukung),
                          const SizedBox(height: 16.0),
                          // TextButton(
                          //   onPressed: null,
                          //   style: TextButton.styleFrom(
                          //     backgroundColor: Colors.green,
                          //     alignment: Alignment.centerLeft,
                          //     padding: const EdgeInsets.symmetric(horizontal: 17),
                          //   ),
                          //   child: const Text(
                          //     'edit',
                          //     style: TextStyle(
                          //       fontSize: 16.0,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 150.0,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 7.0),
          const Text(
            ':',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 3.0),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDocumentViewer(String? documentUrl) {
    if (documentUrl == null || documentUrl.isEmpty) {
      return const Text('Tidak Ada Dokumen Pendukung');
    }

    if (documentUrl.toLowerCase().endsWith('.pdf')) {
      return PDFView(
        filePath: documentUrl,
        fitEachPage: true,
        fitPolicy: FitPolicy.BOTH,
      );
    } else if (documentUrl.toLowerCase().endsWith('.jpg') ||
        documentUrl.toLowerCase().endsWith('.jpeg') ||
        documentUrl.toLowerCase().endsWith('.png')) {
      return Image.network(documentUrl);
    } else {
      return const SizedBox(
          width: 3.0); // Format tidak dikenali, tampilkan widget kosong
    }
  }
}
