import 'package:flutter/material.dart';
import 'package:tipo/models/contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class OpenContactScreen extends StatefulWidget {
  const OpenContactScreen({Key? key, required this.contact}) : super(key: key);
  final userContacts contact;
  @override
  State<OpenContactScreen> createState() => _OpenContactScreenState();
}

class _OpenContactScreenState extends State<OpenContactScreen> {
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
                            widget.contact.phones.toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ]),
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          launch('sms:' +
                              widget.contact.phones.toString() +
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
                          launch("tel:" + widget.contact.phones.toString());
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
                widget.contact.emails.isNotEmpty
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
                                  widget.contact.emails.toString(),
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
                Container(
                  margin: EdgeInsets.all(0),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text("Owner Informations",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 0,
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
                                  "Adder Name",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.contact.addedFirstName +
                                      " " +
                                      widget.contact.addedLastName,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ]),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Adder Email",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.contact.addedEmail.toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ]),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Added Time",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  timeago.format(widget.contact.addedTime),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
