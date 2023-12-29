import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_ruangan.dart';
import 'package:si_pirang/data/model/ruangan_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
    });

    List<Datum> response = await RemoteRuangan().getData(token);
    setState(() {
      ruangan = response;
    });

    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 21,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Ruangan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 600,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Set the number of items in each row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: ruangan.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 250,
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffeee9e9),
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('${ruangan[index].foto}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${ruangan[index].nama}', // Set roomName here or use data from your model
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 70,
                            child: SingleChildScrollView(
                              child: Text(
                                ' ${ruangan[index].fasilitas}',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
