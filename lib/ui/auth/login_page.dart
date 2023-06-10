import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_navios/data/provider/auth_provider.dart';
import 'package:technical_navios/ui/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
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
                          return "Email anda kosong, masukkan email";
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
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .loginWithEmail(_emailController.text,
                              _passwordController.text, context);

                      _emailController.clear();
                      _passwordController.clear();
                    }
                  },
                  child: const Text("Login"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return const RegisterPage();
                    },
                  ), (route) => false);
                },
                child: const Text("Regisiter Here"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
