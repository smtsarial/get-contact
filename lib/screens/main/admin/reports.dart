import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tipo/connections/excelexport.dart';
import 'package:tipo/models/contacts.dart';
import 'package:tipo/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({Key? key}) : super(key: key);

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  PermissionStatus permissionStatus = PermissionStatus.denied;
  List reports = [];
  bool didUpdated = true;
  bool isLoaded = false;

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Future getAllContacts() async {
    List sampleList = [];
    var data = await FirebaseFirestore.instance
        .collection('reports')
        .orderBy("time", descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        sampleList.add(element);
      });
      setState(() {
        reports = sampleList;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAllContacts().then((value) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.reports,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      didUpdated = false;
                    });
                    getAllContacts().then((value) => setState(() {
                          didUpdated = true;
                        }));
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
        isLoaded
            ? Expanded(
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: reports.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          _launchURL(reports.elementAt(index)['reportLink']);
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
                                    Icons.file_copy,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                title: Text(
                                  timeago.format(reports
                                      .elementAt(index)['time']
                                      .toDate()),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                subtitle: Row(
                                  children: <Widget>[
                                    Icon(Icons.download,
                                        size: 18, color: Colors.yellowAccent),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .clickdownload,
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
