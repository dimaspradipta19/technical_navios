import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_navios/data/provider/manipulasi_data_provider.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _namaController = TextEditingController();
final TextEditingController _noTelp = TextEditingController();
final _formKey = GlobalKey<FormState>();

final db = FirebaseFirestore.instance;

class _AddDataPageState extends State<AddDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add data screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan Nama",
                      ),
                      validator: (valueNama) {
                        if (valueNama!.isEmpty) {
                          return "Nama anda kosong, masukkan Nama";
                        }
                        return null;
                      },
                    ),
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
                      controller: _noTelp,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Masukkan No Telp",
                      ),
                      validator: (valueTelp) {
                        if (valueTelp!.isEmpty) {
                          return "No telp anda kosong, masukkan No telp";
                        } else if (valueTelp.length < 10) {
                          return "No telp anda kurang dari 10, masukkan No telp";
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final addProvider = Provider.of<ManipulasiDataProvider>(
                            context,
                            listen: false);

                        await addProvider.addDataToDatabase(
                            _namaController.text,
                            _emailController.text,
                            _noTelp.text,
                            context);

                        log(_namaController.text);
                        log(_emailController.text);
                        log(_noTelp.text);

                        _namaController.clear();
                        _emailController.clear();
                        _noTelp.clear();
                      }
                    },
                    child: const Text("Add data")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
