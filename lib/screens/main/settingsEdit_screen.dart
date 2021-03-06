import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipo/connections/auth.dart';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/models/user.dart';
import 'package:tipo/theme.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnamecontroller = new TextEditingController();
  TextEditingController lastnamecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  late File _image;
  bool _imageload = false;
  late ImagePicker picker;
  bool _visibleCircular = false;
  String editedCountry = "";
  User userData = User("", "", 20, "", [], [], "", false, DateTime.now(), "",
      "", "", "", "", "", "");

  @override
  void initState() {
    picker = new ImagePicker();
    if (mounted) {
      Authentication().getUser().then((value) {
        FirestoreHelper.getUserData()
            .then((value) => setState((() => userData = value)));
      });
    }
    super.initState();
  }

  Future SelectImageFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          _imageload = true;
          _image = File(value.path);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Profile"),
        backgroundColor: PrimaryColor,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                    SelectImageFromGallery();
                  },
                  child: _imageload == true
                      ? CircleAvatar(
                          backgroundColor: PureColor,
                          radius: 100,
                          child: CircleAvatar(
                            radius: 95,
                            backgroundImage: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        )
                      : CircleAvatar(
                          radius: 95,
                          backgroundImage: CachedNetworkImageProvider(
                              userData.profilePictureUrl),
                        ),
                ),
              ),
              SizedBox(
                height: 9,
              ),
              Center(
                child: Text("Tap to edit"),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      children: [
                    Form(key: _formKey, child: Column(children: <Widget>[]))
                  ])),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: firstnamecontroller,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: userData.firstName,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: lastnamecontroller,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: userData.lastName,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: userData.email,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: descriptioncontroller,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: userData.phone,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: DropdownButtonFormField<String>(
                    value: "??ehir",
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: TextColor),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                    dropdownColor: PrimaryColor,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        editedCountry = newValue.toString();
                      });
                    },
                    validator: (value) {
                      if (value == "Gender") {
                        return 'Please select your gender.';
                      }
                      return null;
                    },
                    items: <String>[
                      '??ehir',
                      'Adana',
                      'Ad??yaman',
                      'Afyon',
                      'A??r??',
                      'Amasya',
                      'Ankara',
                      'Antalya',
                      'Artvin',
                      'Ayd??n',
                      'Bal??kesir',
                      'Bilecik',
                      'Bing??l',
                      'Bitlis',
                      'Bolu',
                      'Burdur',
                      'Bursa',
                      '??anakkale',
                      '??ank??r??',
                      '??orum',
                      'Denizli',
                      'Diyarbak??r',
                      'Edirne',
                      'Elaz????',
                      'Erzincan',
                      'Erzurum',
                      'Eski??ehir',
                      'Gaziantep',
                      'Giresun',
                      'G??m????hane',
                      'Hakkari',
                      'Hatay',
                      'Isparta',
                      'Mersin',
                      '??stanbul',
                      '??zmir',
                      'Kars',
                      'Kastamonu',
                      'Kayseri',
                      'K??rklareli',
                      'K??r??ehir',
                      'Kocaeli',
                      'Konya',
                      'K??tahya',
                      'Malatya',
                      'Manisa',
                      'Kahramanmara??',
                      'Mardin',
                      'Mu??la',
                      'Mu??',
                      'Nev??ehir',
                      'Ni??de',
                      'Ordu',
                      'Rize',
                      'Sakarya',
                      'Samsun',
                      'Siirt',
                      'Sinop',
                      'Sivas',
                      'Tekirda??',
                      'Tokat',
                      'Trabzon',
                      'Tunceli',
                      '??anl??urfa',
                      'U??ak',
                      'Van',
                      'Yozgat',
                      'Zonguldak',
                      'Aksaray',
                      'Bayburt',
                      'Karaman',
                      'K??r??kkale',
                      'Batman',
                      '????rnak',
                      'Bart??n',
                      'Ardahan',
                      'I??d??r',
                      'Yalova',
                      'Karab??k',
                      'Kilis',
                      'Osmaniye',
                      'D??zce'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      updateUser();
                    },
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: _visibleCircular
                        ? Visibility(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.blueGrey,
                              strokeWidth: 2,
                            ),
                            visible: _visibleCircular,
                          )
                        : Text(
                            "UPDATE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future updateUser() async {
    if (_imageload != true) {
      setState(() {
        _visibleCircular = false;
      });
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _visibleCircular = true;
      });
      FirebaseFirestore.instance.collection('users').doc(userData.id).update({
        "firstName": firstnamecontroller.text.isEmpty
            ? userData.firstName
            : firstnamecontroller.text,
        "lastName": lastnamecontroller.text.isEmpty
            ? userData.lastName
            : lastnamecontroller.text,
        "phone": descriptioncontroller.text.isEmpty
            ? "userData.phone"
            : descriptioncontroller.text,
        "city": editedCountry == "" ? userData.country : editedCountry
      }).then((value) {
        setState(() {
          _visibleCircular = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Profile updated successfully"),
        ));
      });
    }
  }

  Future<void> saveData(data) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userMail", data);

    setState(() {});
  }
}
