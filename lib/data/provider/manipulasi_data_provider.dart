import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManipulasiDataProvider extends ChangeNotifier {
  // menambahkan datanya
  Future<void> addDataToDatabase(
      String nama, String email, String noTelp, context) async {
    try {
      final db = FirebaseFirestore.instance;

      await db
          .collection("users")
          .add({
            "nama": nama,
            "email": email,
            "noTelp": noTelp,
          })
          .then(
            (documentSnapshot) =>
                log("Added Data with ID: ${documentSnapshot.id}"),
            onError: (e) => log("Error $e"),
          )
          .then((value) => Navigator.pop(context));

      notifyListeners();
    } catch (e) {
      log("Error ${e.toString()}");
    }
  }

  // update data pada firestore
  Future<void> updateDataToFirestore(
      String nama, String email, String noTelp, context, String id) async {
    try {
      final db = FirebaseFirestore.instance;

      await db
          .collection("users")
          .doc(id)
          .set({
            "nama": nama,
            "email": email,
            "noTelp": noTelp,
          })
          .onError(
            (e, _) => log("Error when edit document: $e"),
          )
          .then((value) => Navigator.pop(context));

      notifyListeners();
    } catch (e) {
      log("Error ${e.toString()}");
    }
  }

  // hapus data dari firestore
  Future<void> deleteDataFromFirestore(context, String id) async {
    try {
      final db = FirebaseFirestore.instance;

      db
          .collection("users")
          .doc(id)
          .delete()
          .then(
            (doc) => log("data berhasil di delete"),
            onError: (e) => log("Error delete the document $e"),
          )
          .then((value) => Navigator.pop(context));

      notifyListeners();
    } catch (e) {
      log("Error ${e.toString()}");
    }
  }
}
