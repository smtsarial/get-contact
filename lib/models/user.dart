class User {
  late String id;
  late String email;
  late int age;
  late String profilePictureUrl;
  late List followers;
  late List followed;
  late String gender;
  late bool isActive;
  late DateTime lastActiveTime;
  late String firstName;
  late String lastName;
  late String userType;
  late String username;
  late String country;
  late String city;
  late String phone;

  User(
      this.id,
      this.email,
      this.age,
      this.profilePictureUrl,
      this.followers,
      this.followed,
      this.gender,
      this.isActive,
      this.lastActiveTime,
      this.firstName,
      this.lastName,
      this.userType,
      this.username,
      this.city,
      this.country,
      this.phone);
  User.fromMap(dynamic obj) {
    email = obj['email'];
    firstName = obj['firstName'];
    followed = obj['followed'];
    username = obj['username'];
    userType = obj['userType'];
    lastName = obj['lastName'];
    lastActiveTime = obj['lastActiveTime'].toDate();
    isActive = obj['isActive'];
    gender = obj['gender'];
    followers = obj['followers'];
    profilePictureUrl = obj['profilePictureUrl'];
    age = obj['age'];
    city = obj['city'];
    country = obj['country'];
    phone = obj['phone'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['email'] = this.email;
      map['firstName'] = this.firstName;
      map['followed'] = this.followed;
      map['username'] = this.username;
      map['userType'] = this.userType;
      map["lastName"] = this.lastName;
      map['lastActiveTime'] = this.lastActiveTime;
      map['isActive'] = this.isActive;
      map["gender"] = this.gender;
      map['followers'] = this.followers;
      map['profilePictureUrl'] = this.profilePictureUrl;
      map['age'] = this.age;
      map['city'] = this.city;
      map['country'] = this.country;
      map['phone'] = this.phone;
    }
    return map;
  }
}
