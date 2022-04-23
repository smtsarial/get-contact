import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tipo/connections/excelexport.dart';
import 'package:tipo/models/contacts.dart';
import 'package:tipo/screens/main/admin/openContact.dart';
import 'package:tipo/theme.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class allContacts extends StatefulWidget {
  const allContacts({Key? key}) : super(key: key);

  @override
  State<allContacts> createState() => _allContactsState();
}

class _allContactsState extends State<allContacts> {
  PermissionStatus permissionStatus = PermissionStatus.denied;
  List<userContacts> contacts = [];
  bool didUpdated = true;
  bool isLoaded = false;

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission =
        await Permission.manageExternalStorage.status;
    if (permission != PermissionStatus.granted &&
        permission == PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

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
        contacts.addAll(sampleList);
        isLoaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getPermission().then((value) => null);
    getAllContacts().then((value) => null);
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
                      List<userContacts> contact = contacts
                          .where((element) =>
                              element.displayName.toString().contains(value))
                          .toList();
                      if (value.length != 0) {
                        setState(() {
                          contacts = contact;
                        });
                      } else {
                        getAllContacts().then((value) {});
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: PureColor,
                      ),
                      hintText: AppLocalizations.of(context)!.search,
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
                    ExportHelper().createExcel().then((value) {
                      FirebaseFirestore.instance.collection('reports').add({
                        "reportLink": value,
                        "time": DateTime.now()
                      }).then((value) {
                        setState(() {
                          didUpdated = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Report created successfully check report section!')),
                        );
                      }).catchError((e) {
                        setState(() {
                          didUpdated = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error occured please try again!')),
                        );
                      });
                    });
                  },
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: didUpdated
                        ? Icon(
                            Icons.downloading_rounded,
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
        isLoaded
            ? Expanded(
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenContactScreen(
                                        contact: contacts.elementAt(index),
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
                                  contacts
                                      .elementAt(index)
                                      .displayName
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
                                        contacts
                                            .elementAt(index)
                                            .phones
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
