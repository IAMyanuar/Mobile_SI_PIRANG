import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_peminjaman.dart';
import 'package:si_pirang/data/model/peminjaman_model.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Datum> riwayat = [];
  String? token;
  int? idUser;
  String? query;
  bool isLoading = false;
  bool? status;

  final TextEditingController searchController = TextEditingController();

  Future<void> getRiwayat() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      idUser = prefs.getInt('id_user');
    });

    RemoteRiwayat remoteRiwayat = RemoteRiwayat();
    PeminjamanModel response =
        await remoteRiwayat.getRiwayat(token, idUser, query);
    setState(() {
      riwayat = response.data!;
      status = response.status!;
      isLoading = false;
    });
  }

  void _performSearch(String query) {
    setState(() {
      this.query = query;
    });
    getRiwayat();
  }

  @override
  void initState() {
    super.initState();
    getRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Peminjaman',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _performSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search Room',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24.0,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : status == false
                    ? const Center(
                        child: Text('Riwayat Peminjaman Tidak Ditemukan.'),
                      )
                    : ListView.builder(
                        itemCount: riwayat.length,
                        itemBuilder: (context, index) {
                          Datum item = riwayat[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.kegiatan}',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Ruangan: ${item.namaRuangan}',
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            '${item.tglMulai != null ? DateFormat('dd-MM-yyyy').format(item.tglMulai!) : ""} ',
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/detailpeminjaman',
                                            arguments: {
                                              "idPeminjaman": item.id
                                            });
                                        // );
                                        // print(item.id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Text('Detail'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
