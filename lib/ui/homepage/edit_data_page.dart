import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/provider/manipulasi_data_provider.dart';

class EditDataPage extends StatefulWidget {
  const EditDataPage(
      {super.key, required this.nama, required this.email, required this.id});

  final String nama;
  final String email;
  final String id;

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _namaController = TextEditingController();
final TextEditingController _noTelp = TextEditingController();
final _formKey = GlobalKey<FormState>();

final db = FirebaseFirestore.instance;

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

class _EditDataPageState extends State<EditDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: StreamBuilder(
              stream: usersCollection.doc(widget.id).snapshots(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _namaController,
                            decoration: InputDecoration(
                                hintText: snapshot.data?.get("nama") ?? ""),
                            validator: (valueNama) {
                              if (valueNama!.isEmpty) {
                                return "Nama anda kosong, masukkan Nama";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                hintText: snapshot.data?.get("email") ?? ""),
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
                            decoration: InputDecoration(
                                hintText: snapshot.data?.get("noTelp") ?? ""),
                            validator: (valueTelp) {
                              if (valueTelp!.isEmpty) {
                                return "No telp anda belum di isi, isi no telp yang baru";
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
                              final editProvider =
                                  Provider.of<ManipulasiDataProvider>(context,
                                      listen: false);

                              await editProvider.updateDataToFirestore(
                                  _namaController.text,
                                  _emailController.text,
                                  _noTelp.text,
                                  context,
                                  widget.id);

                              log(_namaController.text);
                              log(_emailController.text);
                              log(_noTelp.text);

                              _emailController.clear();
                              _namaController.clear();
                              _noTelp.clear();
                            }
                          },
                          child: const Text("Edit data")),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
