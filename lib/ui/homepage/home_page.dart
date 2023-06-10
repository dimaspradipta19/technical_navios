import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technical_navios/data/provider/auth_provider.dart';
import 'package:technical_navios/ui/homepage/add_data_page.dart';
import 'package:technical_navios/ui/homepage/edit_data_page.dart';

import '../../data/provider/manipulasi_data_provider.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

// Membuat atau mendapatkan referensi koleksi "users"
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Keluar dari aplikasi"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logoutAccount(context)
                            .then((value) => Navigator.pushAndRemoveUntil(
                                    context, MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginPage();
                                  },
                                ), (route) => false));
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child:
                  Text("User saat ini ${auth.currentUser?.email ?? "Kosong"}"),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: usersCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                }

                if (snapshot.hasData) {
                  final documents = snapshot.data?.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: documents!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDataPage(
                                email: snapshot.data?.docs[index].get("email"),
                                nama: snapshot.data?.docs[index].get("nama"),
                                id: documents[index].id,
                              ),
                            )),
                        child: ListTile(
                          title: Text(documents[index].get("nama") ?? "title"),
                          subtitle:
                              Text(documents[index].get("email") ?? "subtitle"),
                          leading: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                            "Apakah ingin menghapus Data?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("No")),
                                          TextButton(
                                            onPressed: () async {
                                              // Delete data berdasarkan id nya
                                              final deleteProvider = Provider
                                                  .of<ManipulasiDataProvider>(
                                                      context,
                                                      listen: false);

                                              await deleteProvider
                                                  .deleteDataFromFirestore(
                                                      context,
                                                      documents[index].id);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ));
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Text("No Data");
              },
            )
          ],
        ),
      ),

      // action button untuk pindah kedalam halaman add data
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddDataPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
