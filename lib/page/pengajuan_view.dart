import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_peminjaman.dart';
import 'package:si_pirang/data/model/peminjaman_model.dart';

class PengajuanView extends StatefulWidget {
  const PengajuanView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PengajuanViewState createState() => _PengajuanViewState();
}

class _PengajuanViewState extends State<PengajuanView> {
  List<DataPeminjaman> listPengajuan = [];
  String? token;
  int? idUser;
  bool isLoading = false;
  bool? status;

  TextEditingController feedbackController = TextEditingController();

  Future<void> getListPeminjaman() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      idUser = prefs.getInt('id_user');
    });

    RemoteListPengajuan remoteListPengajuan = RemoteListPengajuan();
    PeminjamanModel response =
        await remoteListPengajuan.listPengajuan(token, idUser);
    setState(() {
      listPengajuan = response.data!;
      status = response.status!;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getListPeminjaman();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengajuan Ruangan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 21,
        backgroundColor: const Color(0xff5e6ac0),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'List Pengajuanku:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/formpengajuan');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff5e6ac0)),
                    child: const Text(
                      'Ajukan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                  : SizedBox(
                      height: 610,
                      child: buildSubmissionList(),
                    ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubmissionList() {
    // ignore: unnecessary_null_comparison
    if (listPengajuan.isEmpty) {
      return const Center(
        child: Text('Belum Ada Pengajuan Peminjaman.'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: listPengajuan.length,
        itemBuilder: (context, index) {
          // ignore: non_constant_identifier_names
          var ListPengajuan = listPengajuan[index];
          return buildSubmissionContainer(
            ListPengajuan.namaLembaga,
            ListPengajuan.kegiatan,
            ListPengajuan.status,
            ListPengajuan.id,
            ListPengajuan.feedback,
          );
        },
      );
    }
  }

  Widget buildSubmissionContainer(String? title, String? description,
      String? status, int? id, String? feedback) {
    Color statusColor = getStatusColor(status!);
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description!,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  buildActionButtons(status, id!, feedback),
                ],
              ),
            ],
          ),
          // SizedBox(height: 10.0), // Add some spacing
          // buildActionButtons(status),
        ],
      ),
    );
  }

  Widget buildActionButtons(String status, int id, String? feedback) {
    if (status == 'completed') {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align buttons horizontally
        children: [
          ElevatedButton(
            onPressed: () {
              // Implement feedback action
              popFeedback(id);
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 8, 37, 255),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              minimumSize: const Size(30, 30),
            ),
            child: const Text('Feedback'),
          ),
        ],
      );
    } else {
      // For other statuses, show delete and edit buttons
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align buttons horizontally
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/detailpeminjaman',
                    arguments: {"idPeminjaman": id});
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size(30, 30),
              ),
              child: const Text('Detail')),
          ElevatedButton(
              onPressed: () async {
                // Implement delete action
                RemoteDeletePengajuan().deleteData(token!, id);
                getListPeminjaman();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 248, 67, 30),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size(30, 30),
              ),
              child: const Text('Batal')),
          // ElevatedButton(
          //   onPressed: () {
          //     // Implement edit action
          //     // Navigator.pushNamed(context, '/editpeminjaman', arguments: {"idPeminjaman": id});
          //   },
          //   style: ElevatedButton.styleFrom(
          //     shape: const RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(10)),
          //     ),
          //     foregroundColor: Colors.white,
          //     backgroundColor: const Color.fromARGB(255, 255, 184, 53),
          //     textStyle: const TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //     minimumSize: const Size(30, 30),
          //   ),
          //   child: const Text('Edit'),
          // ),
        ],
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pading':
        return Colors.orange;
      case 'approved':
        return const Color(0xff5ad25e);
      case 'completed':
        return const Color.fromARGB(255, 36, 95, 232);
      default:
        return Colors.black; // Adjust the default color as needed
    }
  }

  Future<void> popFeedback(id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Feedback'),
          content: TextField(
            controller: feedbackController,
            decoration: const InputDecoration(hintText: 'Masukkan & Saran'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final feedback = feedbackController.text;

                var sendFeeback = await RemoteFeedbackPengajuan()
                    .feedbackPengajuan(token, id, feedback);
                if (sendFeeback == true) {
                  getListPeminjaman();
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        ),
      );
}
