import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prognosify/router/app_router_constants.dart';

class AuthServices {
  static signUpUser(
      String email, String name, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'name': name,
        'topDiseases': [],
        'topPercentage': [],
        'topDiseasesPrecautions': {},
        'topDiseasesSymptoms': {}
      });
      if (!context.mounted) {
        return;
      }
      GoRouter.of(context).goNamed(AppRouterConstants.navigationScreen);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signed Up Successfully!")));
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password is too weak")));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email already exists")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signInUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!context.mounted) {
        return;
      }
      GoRouter.of(context).goNamed(AppRouterConstants.navigationScreen);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged In Successfully!")));
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("User does not exist")));
      } else if (e.code == "wrong-password") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Incorrect Password")));
      }
    }
  }

  static signOutUser(context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Logged Out")));
    GoRouter.of(context).goNamed(AppRouterConstants.signInScreen);
  }
}
