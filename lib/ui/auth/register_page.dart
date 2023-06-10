import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_navios/data/provider/auth_provider.dart';
import 'package:technical_navios/ui/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan Email",
                      ),
                      validator: (valueEmail) {
                        if (valueEmail!.isEmpty) {
                          return "Email anda kosong, masukkan Email";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan Password",
                      ),
                      validator: (valuePassword) {
                        if (valuePassword!.isEmpty) {
                          return "Password anda kosong, masukkan Password";
                        } else if (valuePassword.length < 6) {
                          return "Password anda kurang, masukkan Password minimal 6 karakter";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .registerWithEmail(_emailController.text,
                                      _passwordController.text, context);

                              _emailController.clear();
                              _passwordController.clear();
                            }
                          },
                          child: const Text("Register")),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ), (route) => false);
                },
                child: const Text("Login Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
