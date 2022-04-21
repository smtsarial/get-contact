import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tipo/connections/auth.dart';
import 'package:tipo/models/contacts.dart';
import 'package:tipo/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final DatabaseReference ref = FirebaseDatabase.instance.ref();

  static Future<int> checkContactAvaliableOnDatabase(String phoneNumber) async {
    int size = 0;
    await FirestoreHelper.getUserData().then((value) async {
      await db
          .collection('contacts')
          .where("phones", isEqualTo: phoneNumber)
          .where("addedEmail", isEqualTo: value.email)
          .get()
          .then((value) => size = (value.size));
    });
    return size;
  }

  static Future<List<userContacts>> getAllContacts() async {
    List<userContacts> sampleList = [];
    var data = await FirebaseFirestore.instance
        .collection('contacts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sampleList.add(userContacts.fromMap(element));
      });
    });
    return sampleList;
  }

  static Future<User> getUserData() async {
    //this method for taking user data
    List<User> details = [];
    await Authentication().getUser().then((value) async {
      var data = await db
          .collection('users')
          .where("email", isEqualTo: value.toString())
          .get();
      if (data != null) {
        details = data.docs.map((document) => User.fromMap(document)).toList();
      }
      int i = 0;
      details.forEach((detail) {
        detail.id = data.docs[i].id;
        i++;
      });
    });

    return details.length != 0
        ? details[0]
        : User("", "", 20, "", [], [], "", false, DateTime.now(), "", "", "",
            "", "", "", "");
  }

  static Future<String> uploadAdminReport(File path) async {
    //upload profile picture
    try {
      print(path.toString());
      String? pictureUrl;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('adminReport/' + Path.basename(path.path));

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          pictureUrl = value;
        });
      });
      return pictureUrl.toString();
    } catch (e) {
      print(" ---> " + e.toString());
      return "";
    }
  }

  static Future uploadProfilePictureToStorage(path) async {
    //upload profile picture
    try {
      String? pictureUrl;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profileImages/${Path.basename(path.toString())}');

      await ref.putFile(path).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          print(pictureUrl);
          pictureUrl = value;
          print(pictureUrl);
        });
      });
      return pictureUrl;
    } catch (e) {
      print("sss" + e.toString());
      return e;
    }
  }

  static Future<bool> addNewUser(
      id,
      email,
      age,
      chatCount,
      profilePictureUrl,
      followers,
      followed,
      gender,
      isActive,
      lastActiveTime,
      firstName,
      lastName,
      likes,
      userBio,
      userTags,
      userType,
      username,
      phone) async {
    //this function will add new user to users collection
    try {
      var result = await db.collection('users').add(User(
              id,
              email,
              age,
              profilePictureUrl,
              followers,
              followed,
              gender,
              isActive,
              lastActiveTime,
              firstName,
              lastName,
              userType,
              username,
              "İstanbul",
              "Türkiye",
              phone)
          .toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<int> checkUsername(username) async {
    //this function checks usernames from users collection
    try {
      var data = await db
          .collection('users')
          .where("username", isEqualTo: username)
          .get();
      print(data.size);
      return data.size;
    } catch (e) {
      print(e);
      return -99;
    }
  }
}
