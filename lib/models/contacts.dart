import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';

class userContacts {
  late String id;
  late String displayName;
  late String familyName;
  late String company;
  late String jobTitle;
  late String emails;
  late String phones;
  late String addedUserName;
  late String addedFirstName;
  late String addedLastName;
  late DateTime addedTime;
  late String addedEmail;
  late String addedProfilePicture;

  userContacts(
    this.id,
    this.displayName,
    this.familyName,
    this.company,
    this.jobTitle,
    this.emails,
    this.phones,
    this.addedUserName,
    this.addedFirstName,
    this.addedLastName,
    this.addedTime,
    this.addedEmail,
    this.addedProfilePicture,
  );
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['displayName'] = this.displayName;
      map['familyName'] = this.familyName;
      map['company'] = this.company;
      map['jobTitle'] = this.jobTitle;
      map['emails'] = this.emails;
      map["phones"] = this.phones;
      map["addedUserName"] = this.addedUserName;
      map["addedFirstName"] = this.addedFirstName;
      map["addedLastName"] = this.addedLastName;
      map["addedTime"] = this.addedTime;
      map["addedEmail"] = this.addedEmail;
      map["addedProfilePicture"] = this.addedProfilePicture;
    }
    return map;
  }

  userContacts.fromMap(dynamic obj) {
    displayName = obj['displayName'];
    familyName = obj['familyName'];
    company = obj['company'];
    jobTitle = obj['jobTitle'];
    emails = obj['emails'];
    phones = obj['phones'];
    addedUserName = obj['addedUserName'];
    addedFirstName = obj['addedFirstName'];
    addedLastName = obj['addedLastName'];
    addedTime = obj['addedTime'].toDate();
    addedEmail = obj['addedEmail'];
    addedProfilePicture = obj['addedProfilePicture'];
  }
}
