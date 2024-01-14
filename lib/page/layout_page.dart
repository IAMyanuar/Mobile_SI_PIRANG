import 'package:flutter/material.dart';
import 'package:si_pirang/page/dashboard_view.dart';
import 'package:si_pirang/page/history_view.dart';
import 'package:si_pirang/page/pengajuan_view.dart';
import 'calendar_view.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  late int currentPageIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Akses argument menggunakan ModalRoute
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Map<String, dynamic> && args.containsKey('initialPageIndex')) {
      currentPageIndex = args['initialPageIndex'] ?? 0;
    } else {
      // Atur nilai default jika argument tidak ada atau tidak sesuai
      currentPageIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        // indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.send),
            icon: Icon(Icons.send),
            label: 'Pengajuan',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history, size: 26.0),
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
      body: <Widget>[
        const DashboardView(),
        const CalendarView(),
        const PengajuanView(),
        const HistoryView()
      ][currentPageIndex],
    );
  }
}
