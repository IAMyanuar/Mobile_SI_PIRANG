import 'package:flutter/material.dart';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  _FormPengajuanState createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  TextEditingController namalembagaController = TextEditingController();
  TextEditingController kegiatanController = TextEditingController();
  TextEditingController tglMulaiController = TextEditingController();
  TextEditingController tglSelesaiController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController idRuanganController = TextEditingController();
  TextEditingController dokumenPendukungController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffffffff),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10),
            Text(
              'FORM PENGAJUAN',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Bagian Form
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Lembaga',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kegiatan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ruangan',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Pilih Ruangan',
                          suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.arrow_drop_down,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Waktu Mulai',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'mm/dd/yyyy --:-- --',
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.calendar_today),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Waktu Selesai',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: 'mm/dd/yyyy --:-- --',
                            suffixIcon: InkWell(
                              onTap: () {},
                              child: Icon(Icons.calendar_today),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bukti Pendukung',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Tambahkan logika untuk memilih file
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[200],
                                  onPrimary: Colors.black,
                                  side: BorderSide(color: Colors.black),
                                ),
                                child: Text('Choose File'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
