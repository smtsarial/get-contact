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

class whoSaveMe extends StatefulWidget {
  const whoSaveMe({Key? key}) : super(key: key);

  @override
  State<whoSaveMe> createState() => _whoSaveMeState();
}

class _whoSaveMeState extends State<whoSaveMe> {
  List<userContacts> savedContacts = [];
  bool isLoaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      List<userContacts> sampleList = [];
      FirestoreHelper.getUserData().then((value) {
        var data = FirebaseFirestore.instance
            .collection('contacts')
            .where('phones', isEqualTo: value.phone)
            .get()
            .then((value1) {
          value1.docs.forEach((element) {
            sampleList.add(userContacts.fromMap(element));
          });
        }).then((value) {
          if (mounted) {
            setState(() {
              savedContacts.addAll(sampleList);
              isLoaded = true;
            });
          }
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 24,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Those who registered me",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        context.watch<UserProvider>().user.profilePictureUrl),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isLoaded == false
              ? CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                )
              : savedContacts.length == 0
                  ? Container(
                      child: Center(
                        child:
                            Text("There is no information about your number!"),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: savedContacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {},
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
                                        savedContacts
                                            .elementAt(index)
                                            .displayName
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
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
}
