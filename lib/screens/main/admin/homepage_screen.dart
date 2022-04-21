import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/models/contacts.dart';
import 'package:tipo/models/user.dart';
import 'package:tipo/screens/main/admin/openUser.dart';
import 'package:tipo/theme.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  bool didUpdated = true;
  List<User> users = [];
  List<userContacts> contacts = [];
  bool isLoaded = false;

  Future getAllContacts() async {
    List<userContacts> sampleList = [];
    var data = await FirebaseFirestore.instance
        .collection('contacts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sampleList.add(userContacts.fromMap(element));
      });
      setState(() {
        contacts = sampleList;
      });
    });
  }

  Future getAllUsers() async {
    List<User> sampleList = [];
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isNotEqualTo: "admin")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sampleList.add(User.fromMap(element));
      });
      setState(() {
        users = sampleList;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAllUsers().then((value) => getAllContacts().then((value) {
          setState(() {
            isLoaded = true;
          });
        }));
    //getPermission().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                    onChanged: (value) {
                      List<User> contact = users
                          .where((element) =>
                              element.firstName.toString().contains(value))
                          .toList();
                      if (value.length != 0) {
                        setState(() {
                          users = contact;
                        });
                      } else {
                        getAllUsers().then((value) {});
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: PureColor,
                      ),
                      hintText: "Search",
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      didUpdated = false;
                    });
                    getAllUsers().then((value) {
                      getAllContacts().then((value) {
                        setState(() {
                          didUpdated = true;
                        });
                      });
                    });
                  },
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: didUpdated
                        ? Icon(
                            Icons.replay_outlined,
                            size: 35,
                          )
                        : Transform.scale(
                            scale: 0.7,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.blueGrey,
                              strokeWidth: 5,
                            ),
                          ),
                  ))),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(64, 75, 96, .9),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "User",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "Count",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          users.length.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(64, 75, 96, .9),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Contact",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "Count",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        contacts.length.toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        isLoaded
            ? Expanded(
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenProfile(
                                        userData: users.elementAt(index),
                                      )));
                        },
                        child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(64, 75, 96, .9)),
                            child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                title: Text(
                                  users.elementAt(index).firstName.toString() +
                                      " " +
                                      users
                                          .elementAt(index)
                                          .lastName
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(Icons.numbers_outlined,
                                        size: 18, color: Colors.yellowAccent),
                                    Text(
                                        "Total contact count:  " +
                                            contacts
                                                .where((element) =>
                                                    element.addedEmail ==
                                                    users
                                                        .elementAt(index)
                                                        .email)
                                                .toList()
                                                .length
                                                .toString(),
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white, size: 30.0)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
              )
      ],
    );
  }
}
