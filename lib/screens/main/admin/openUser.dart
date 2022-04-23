import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tipo/models/contacts.dart';
import 'package:tipo/models/user.dart';
import 'package:tipo/screens/main/admin/openContact.dart';
import 'package:tipo/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OpenProfile extends StatefulWidget {
  const OpenProfile({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<OpenProfile> createState() => _OpenProfileState();
}

class _OpenProfileState extends State<OpenProfile> {
  bool follower = false;
  List<userContacts> contacts = [];
  bool didUpdated = true;
  bool isLoaded = false;
  Future getUserSpecificContacts() async {
    List<userContacts> sampleList = [];
    var data = await FirebaseFirestore.instance
        .collection('contacts')
        .where('addedEmail', isEqualTo: widget.userData.email)
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
    getUserSpecificContacts().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: body(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData.firstName + " " + widget.userData.lastName,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 22,
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: PrimaryColor,
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 95,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.userData.profilePictureUrl),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 22,
          ),
          const Divider(),
          userSpecificInformationLayer(),
          const Divider(),
        ],
      ),
    );
  }

  Widget userSpecificInformationLayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    AppLocalizations.of(context)!.mobile,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.userData.phone,
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      launch('sms:' + widget.userData.phone + '?body=');
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.message),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      launch("tel:" + widget.userData.phone);
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.phone),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ])
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.userData.phone,
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
                GestureDetector(
                  onTap: () {
                    launch("mailto:" + widget.userData.email);
                  },
                  child: const CircleAvatar(
                    child: Icon(Icons.mail),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Center(
              child: Text(AppLocalizations.of(context)!.usercontacts,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            isLoaded
                ? Container(
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
                  )
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  )
          ]),
        ),
      ],
    );
  }
}
