import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/screens/auth/login.dart';
import 'package:tipo/screens/main/admin/navigation.dart';
import 'package:tipo/screens/main/user/userNavigation.dart';

import '../../models/user.dart';

class SplashScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User userData = User("", "", 20, "", [], [], "", false, DateTime.now(), "",
      "", "", "", "", "", "");

  bool isLoading = true;
  bool isErrorOccured = false;

  @override
  void initState() {
    try {
      FirestoreHelper.getUserData().then((value) {
        setState(
          () {
            userData = value;
            isLoading = false;
          },
        );
      }).onError((error, stackTrace) {
        setState(() {
          isErrorOccured = true;
        });
      });
    } catch (e) {
      setState(() {
        isErrorOccured = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (() {
      if (isLoading == true) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.blueGrey,
            strokeWidth: 2,
          ),
        );
      } else {
        return (userData.id == "")
            ? LoginPage()
            : (Scaffold(
                body: userData.userType == "admin"
                    ? adminHomeScreen()
                    : HomeScreen()));
      }
    }());
  }
}
