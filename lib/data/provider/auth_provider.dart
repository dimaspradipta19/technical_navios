import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:technical_navios/ui/auth/login_page.dart';
import 'package:technical_navios/ui/homepage/home_page.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Login Function
  Future<void> loginWithEmail(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      setUser(userCredential.user);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        log("user not found");

        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("User Not Found"),
                ));
      } else if (e.code == "wrong-password") {
        log("worng password for that user");

        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("Wrong password!"),
                ));
      }
      notifyListeners();
    }
  }

  // Register Function
  Future<void> registerWithEmail(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      setUser(userCredential.user);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const LoginPage();
        },
      ), (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        log("email sudah ada yang punya");

        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("email already in use"),
                ));
      } else {
        log(e.toString());
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(e.toString()),
                ));
      }
      notifyListeners();
    }
  }

  // Logout Function
  Future<void> logoutAccount(BuildContext context) async {
    await _auth.signOut().then((value) {
      log("logout");
    });
    notifyListeners();
    setUser(null);
  }
}
