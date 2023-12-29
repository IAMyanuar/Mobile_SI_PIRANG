import 'package:flutter/material.dart';

class PengajuanView extends StatefulWidget {
  @override
  _PengajuanViewState createState() => _PengajuanViewState();
}

class _PengajuanViewState extends State<PengajuanView> {
  TextEditingController _submissionController = TextEditingController();

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
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('List Pengajuanku:'),
              SizedBox(height: 10.0),
              buildSubmissionContainer('UKM Gending Wangi',
                  'Lorem ipsum dolor sit amet,', 'Pading', Colors.orange),
              SizedBox(height: 10.0),
              buildSubmissionContainer('UKM Gending Wangi',
                  'Lorem ipsum dolor sit amet,', 'ACC', Color(0xff5ad25e)),
              SizedBox(height: 10.0),
              buildSubmissionContainer('UKM Gending Wangi',
                  'Lorem ipsum dolor sit amet,', 'Denied', Colors.red),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  String submissionValue = _submissionController.text;
                  Navigator.pushNamed(context, '/formpengajuan');
                },
                child: Text('Ajukan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSubmissionContainer(
      String title, String description, String status, Color statusColor) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 8.0),
              Text(
                status,
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: statusColor),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {},
              child: Text(
                'Detail',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
