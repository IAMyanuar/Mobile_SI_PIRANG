import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_pirang/data/datasources/remote_login.dart';
import 'package:si_pirang/data/model/login_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void navigateToRegisterView() {
    Navigator.pushNamed(context, '/register');
  }

  LoginModel? data;

  String? token;
  bool? statusCode;
  String nim = '';
  String password = '';

  TextEditingController nimController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> setPref([token, idUser, role]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setInt('id_user', idUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 175),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      30.0), // Berikan jarak antara judul dan kotak username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 2.0),
                  const Text(
                    'Username',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: const Icon(Icons.person),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: nimController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                hintText: 'Input Your Username'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3.0),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6.0),
                    const Text('Password',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff000000)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: const Icon(Icons.lock),
                          ),
                          Expanded(
                            child: TextFormField(
                              obscureText: !isPasswordVisible,
                              controller: passwordController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  hintText: 'Input Your Password'),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                  onTap: togglePasswordVisibility,
                                  child: Icon(
                                    isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              ElevatedButton(
                onPressed: () async {
                  final nim = nimController.text;
                  final password = passwordController.text;

                  final user = LoginModel(nim: nim, password: password);

                  // print('User data before login: $user');
                  try {
                    // Panggil fungsi login dari RemoteLogin
                    data = await RemoteLogin().login(user);
                    // Cek apakah login sukses
                    if (data!.status == true) {
                      setPref(data!.token, data!.idUser);
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(
                        context,
                        '/dashboard',
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(data?.message ?? '')),
                      );
                    } else {
                      // Jika login gagal, tampilkan pesan atau lakukan aksi yang sesuai
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Login failed! ${data?.message ?? ''}")),
                      );
                    }
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("tidak terkoneksi ke database")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: const Color(0xff5e6ac0)),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'poppins',
                      color: Color(0xff090a0a),
                    ),
                  ),
                  InkWell(
                    onTap: navigateToRegisterView,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'poppins',
                        color: Color(0xff006bd7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
