import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipo/models/contacts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key, required this.contact}) : super(key: key);
  final Contact contact;
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Contact',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        //actions: const [Icon(Icons.more_vert)],
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.indigo),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.40,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                SizedBox(height: 20),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 160,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        widget.contact.displayName.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mobile",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.contact.phones!.first.value.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ]),
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          launch('sms:' +
                              widget.contact.phones!.first.value.toString() +
                              '?body=');
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
                          launch("tel:" +
                              widget.contact.phones!.first.value.toString());
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
                widget.contact.emails!.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.contact.emails!.first.value.toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ]),
                          const CircleAvatar(
                            child: Icon(Icons.mail),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
