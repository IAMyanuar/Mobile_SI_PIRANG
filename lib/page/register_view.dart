import 'package:flutter/material.dart';
import 'package:si_pirang/data/datasources/remote_register.dart';
import 'package:si_pirang/data/model/register.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isPasswordVisible = false;
  final alertSuccess = const SnackBar(content: Text("Register Success"));
  final alertFailed = const SnackBar(content: Text("Register Failed"));

  RegisterModel? data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nimController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 5.0),
                const Text(
                  'Please Enter Your Data',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'poppins',
                    color: Color(0xff8d9292),
                  ),
                ),
                const SizedBox(height: 40.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NIM',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: nimController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Input Your NIM',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Input Your Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Telp',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: telpController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Input Your Telp Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Email',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Input Your Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value != null && !value.endsWith('@gmail.com')) {
                            return 'Hanya email dengan domain @gmail.com yang diperbolehkan.';
                          }
                          return null;
                        },
                      ),
                    ]),
                  ),
                ]),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Password',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Input Your Password',
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: togglePasswordVisibility,
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final nim = nimController.text;
                    final nama = namaController.text;
                    final email = emailController.text;
                    final password = passwordController.text;
                    final telp = telpController.text;

                    final newUser = RegisterModel(
                      nim: nim,
                      nama: nama,
                      email: email,
                      password: password,
                      telp: telp,
                    );

                    try {
                      data = await RemoteRegister().register(newUser);

                      if (data?.status == true) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, '/login');
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(data?.message ?? '')),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Sign Up failed! ${data?.message ?? ''}")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Tidak terkoneksi ke database")),
                      );
                    }
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size(double.infinity, 50.0),
                    padding: EdgeInsets.all(20.0),
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have account?",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'poppins',
                        color: Color(0xff090a0a),
                      ),
                    ),
                    InkWell(
                      onTap: navigateToLoginView,
                      child: const Text(
                        'Sign In',
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
        ),
      ),
    );
  }

  void navigateToLoginView() {
    Navigator.pushNamed(context, '/login');
  }
}
