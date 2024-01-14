import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_kalender.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/model/kalender_model.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String? token;
  bool isLoading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<dynamic>> events = {};
  final ValueNotifier<List<dynamic>> _selectedEvents =
      ValueNotifier<List<dynamic>>([]);

  // Tambahkan lebih banyak acara jika diperlukan
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });

    final kalenderResponse = await RemoteKalender().getData(token);
    // ignore: unnecessary_null_comparison
    if (kalenderResponse != null) {
      setState(() {
        events = processData(kalenderResponse);
        isLoading = false;
        // print(events);
      });

      // Handle ketika kalenderResponse bernilai null
      setState(() {
        isLoading = false;
      });
    }
    // Handle kesalahan selama proses getData
    setState(() {
      isLoading = false;
    });
    // Tambahkan log atau tindakan lain yang sesuai dengan kebutuhan aplikasi Anda
  }

  Map<DateTime, List<dynamic>> processData(List<KalenderModel> kalenderList) {
    Map<DateTime, List<dynamic>> processedEvents = {};

    for (var kalenderData in kalenderList) {
      DateTime startDate = kalenderData.start!;
      if (processedEvents[startDate] == null) {
        processedEvents[startDate] = [];
      }
      processedEvents[startDate]!.add(
          'Kegiatan: ${kalenderData.title} \nRuangan: ${kalenderData.ruangan} \nAcara Mulai:${kalenderData.acaraMulai} \nAcara Selesai:${kalenderData.acaraSelesai}');
    }
    return processedEvents;
  }

  //calender
  List<dynamic> _getEventsForDay(DateTime day) {
    var matchingEvents = <dynamic>[];

    for (var eventDay in events.keys) {
      if (eventDay.year == day.year &&
          eventDay.month == day.month &&
          eventDay.day == day.day) {
        matchingEvents.addAll(events[eventDay] ?? []);
      }
    }
    return matchingEvents;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      // print(_selectedEvents.value);
    }
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
          'Kalendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 21,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff5e6ac0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              eventLoader: _getEventsForDay,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 10.0),
            ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, selectedEvents, _) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.5, // Atur tinggi sesuai kebutuhan
                  child: ListView.builder(
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          // ignore: avoid_print
                          onTap: () => print('${selectedEvents[index]}'),
                          title: Text('${selectedEvents[index]}'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
