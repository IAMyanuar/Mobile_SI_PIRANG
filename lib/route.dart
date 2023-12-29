import 'package:flutter/material.dart';
import 'package:si_pirang/page/detail_view.dart';
import 'package:si_pirang/page/formpengajuan_view.dart';
import 'package:si_pirang/page/layout_page.dart';
import 'package:si_pirang/page/login_view.dart';
import 'package:si_pirang/page/register_view.dart';

class SiPirang extends StatelessWidget {
  const SiPirang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Set this to false`
      initialRoute: '/login',
      // initialRoute: '/dashboard',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/dashboard': (context) => const Layout(),
        '/formpengajuan': (context) => const FormPengajuan(),
        '/detailpeminjaman': (context) => const DetailPengajuan(),
      },
    );
  }
}
