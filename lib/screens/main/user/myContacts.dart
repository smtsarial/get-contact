import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/connections/getContacts.dart';
import 'package:tipo/models/contacts.dart';
import 'package:tipo/provider/UserProvider.dart';
import 'package:tipo/screens/main/user/contact_screen.dart';
import 'package:tipo/theme.dart';

class myContactsScreen extends StatefulWidget {
  const myContactsScreen({Key? key}) : super(key: key);

  @override
  State<myContactsScreen> createState() => _myContactsScreenState();
}

class _myContactsScreenState extends State<myContactsScreen> {
  PermissionStatus permissionStatus = PermissionStatus.denied;
  Iterable<Contact> contacts = [];
  bool didUpdated = false;

  void updateMyContact(value) {
    FirestoreHelper.getUserData().then((userData) {
      value.forEach((element) {
        FirestoreHelper.checkContactAvaliableOnDatabase(
                element.phones!.first.value.toString())
            .then((value) {
          if (value == 0) {
            userContacts user = userContacts(
                "",
                element.displayName == null
                    ? ""
                    : element.displayName.toString(),
                element.familyName == null ? "" : element.familyName.toString(),
                element.company == null ? "" : element.company.toString(),
                element.jobTitle == null ? "" : element.jobTitle.toString(),
                element.emails!.isNotEmpty
                    ? element.emails!.first.value.toString()
                    : "",
                element.phones!.isNotEmpty
                    ? element.phones!.first.value.toString()
                    : "",
                userData.username,
                userData.firstName,
                userData.lastName,
                DateTime.now(),
                userData.email,
                userData.profilePictureUrl);
            FirebaseFirestore.instance
                .collection("contacts")
                .add(user.toMap())
                .then((value) {
              setState(() {
                didUpdated = true;
              });
            });
          } else {
            print("This contact added before");
            if (mounted) {
              setState(() {
                didUpdated = true;
              });
            }
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      _getPermission().then((value) {
        setState(() {
          permissionStatus = value;
        });
        ContactHelper().getAllContacts().then((value) {
          setState(() {
            contacts = value;
          });
          updateMyContact(value);
        });
      });
    }
    //getPermission().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return permissionStatus == PermissionStatus.denied
        ? Center(
            child: Text("Permission Denied"),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF1B1E1F),
              elevation: 0,
              centerTitle: false,
              title: const Text(
                "My Contacts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        context.watch<UserProvider>().user.profilePictureUrl),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () async {
                try {
                  Contact contact = await ContactsService.openContactForm();
                  if (contact != null) {
                    ContactHelper().getAllContacts().then((value) {
                      setState(() {
                        contacts = value;
                      });
                      updateMyContact(value);
                    });
                  }
                } on FormOperationException catch (e) {
                  switch (e.errorCode) {
                    case FormOperationErrorCode.FORM_OPERATION_CANCELED:
                    case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
                    case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
                      print(e.toString());
                  }
                }
              },
            ),
            body: Column(
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
                              List<Contact> contact = contacts
                                  .where((element) => element.displayName
                                      .toString()
                                      .contains(value))
                                  .toList();
                              if (value.length != 0) {
                                setState(() {
                                  contacts = contact;
                                });
                              } else {
                                ContactHelper().getAllContacts().then((value) {
                                  setState(() {
                                    contacts = value;
                                  });
                                  updateMyContact(value);
                                });
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
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              didUpdated = false;
                            });
                            ContactHelper().getAllContacts().then((value) {
                              setState(() {
                                contacts = value;
                              });
                              updateMyContact(value);
                            });
                          },
                          child: Card(
                              child: Padding(
                            padding: EdgeInsets.all(4),
                            child: didUpdated
                                ? Icon(
                                    Icons.replay,
                                    color: Colors.white,
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
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            //Navigator.push(
                            //    context,
                            //    MaterialPageRoute(
                            //        builder: ((context) => ContactScreen(
                            //              contact: contacts.elementAt(index),
                            //            ))));
                            try {
                              Contact contact =
                                  await ContactsService.openExistingContact(
                                      contacts.elementAt(index));
                              if (contact != null) {
                                ContactHelper().getAllContacts().then((value) {
                                  setState(() {
                                    contacts = value;
                                  });
                                  updateMyContact(value);
                                });
                              }
                            } on FormOperationException catch (e) {
                              switch (e.errorCode) {
                                case FormOperationErrorCode
                                    .FORM_OPERATION_CANCELED:
                                case FormOperationErrorCode
                                    .FORM_COULD_NOT_BE_OPEN:
                                case FormOperationErrorCode
                                    .FORM_OPERATION_UNKNOWN_ERROR:
                                  print(e.toString());
                              }
                            }
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
                                              .phones!
                                              .first
                                              .value
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
              ],
            ),
          );
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission == PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}
