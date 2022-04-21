import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = User("", "", 20, "", [], [], "", false, DateTime.now(), "", "",
      "", "", "", "", "");

  UserProvider() {
    FirestoreHelper.getUserData().then((value) => user = value);
    notifyListeners();
  }
  void updateUserData() {
    FirestoreHelper.getUserData().then((value) => user = value);
    notifyListeners();
  }
}
