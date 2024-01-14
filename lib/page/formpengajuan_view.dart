import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_peminjaman.dart';
import 'package:si_pirang/data/datasources/remote_ruangan.dart';
import 'package:si_pirang/data/model/peminjaman_model.dart';
import 'package:si_pirang/data/model/ruangan_model.dart';
// import 'package:file_picker/file_picker.dart';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormPengajuanState createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  TextEditingController namalembagaController = TextEditingController();
  TextEditingController kegiatanController = TextEditingController();

  late DateTime waktuMulai;
  late DateTime waktuSelesai;
  PeminjamanModel? dataPengajuan;
  String? image;

  int?
      selectedRuangan; // Ganti tipe variabel menjadi sesuai struktur data sebenarnya

  List<Datum> ruangan = [];
  String? token;
  int? idUser;
  bool isLoading = false;

  Future getData() async {
    setState(() {
      isLoading = !isLoading;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      idUser = prefs.getInt('id_user');
    });

    List<Datum> response = await RemoteRuangan().getData(token);
    setState(() {
      ruangan = response;
    });

    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = pickedFile.path;
        // print(image);
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff5e6ac0),
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'FORM PENGAJUAN',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bagian Form
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nama Lembaga',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: namalembagaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Kegiatan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: kegiatanController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ruangan',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    height: 50,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(156, 0, 0, 0),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedRuangan,
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Pilih Ruangan',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 119, 117, 117),
                                      fontSize: 14)),
                            ),
                            ...ruangan.map((item) {
                              return DropdownMenuItem(
                                value: item.id,
                                child: Text("${item.nama}"),
                              );
                            }),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              selectedRuangan = newValue;
                              // print(selectedRuangan);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Waktu Mulai',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  DateTimeField(
                    format: format,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 5.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'mm/dd/yyyy --:-- --',
                      hintStyle: const TextStyle(fontSize: 14.0),
                      suffixIcon: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            initialDate: waktuMulai,
                            lastDate: DateTime(2101),
                          );
                          if (date != null) {
                            // ignore: use_build_context_synchronously
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                waktuMulai,
                              ),
                            );
                            if (time != null) {
                              setState(() {
                                waktuMulai = DateTimeField.combine(date, time);
                              });
                            }
                          }
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        // ignore: use_build_context_synchronously
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    onChanged: (selectedDate) {
                      setState(() {
                        waktuMulai = selectedDate!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Waktu Selesai',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  DateTimeField(
                    format: format,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 5.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'mm/dd/yyyy --:-- --',
                      hintStyle: const TextStyle(fontSize: 14.0),
                      suffixIcon: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            initialDate: waktuSelesai,
                            lastDate: DateTime(2101),
                          );
                          if (date != null) {
                            // ignore: use_build_context_synchronously
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                waktuSelesai,
                              ),
                            );
                            if (time != null) {
                              setState(() {
                                waktuSelesai =
                                    DateTimeField.combine(date, time);
                              });
                            }
                          }
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (date != null) {
                        // ignore: use_build_context_synchronously
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    onChanged: (selectedDate1) {
                      setState(() {
                        waktuSelesai = selectedDate1!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bukti Pendukung',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: ElevatedButton(
                            onPressed: _getImage,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.grey[200],
                              side: const BorderSide(color: Colors.black),
                            ),
                            child: const Text('Choose File'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      idUser;
                      final namaLembaga = namalembagaController.text;
                      final kegiatan = kegiatanController.text;
                      selectedRuangan;
                      waktuMulai;
                      waktuSelesai;
                      final idRuangan = selectedRuangan;

                      try {
                        dataPengajuan = await RemoteFormPengajuan()
                            .formPengajuan(
                                token,
                                namaLembaga,
                                kegiatan,
                                waktuMulai,
                                waktuSelesai,
                                idUser,
                                idRuangan,
                                image);

                        if (dataPengajuan?.status == true) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(context, '/dashboard',
                              arguments: {'initialPageIndex': 2});
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(dataPengajuan?.message ?? '')),
                          );
                          // print('berhasil');
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(dataPengajuan?.message ?? '')),
                          );
                        }
                      } catch (e) {
                        print('Terjadi kesalahan: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xff5e6ac0)),
                    child: const Text(
                      'Ajukan Peminjaman',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
