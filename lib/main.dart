import 'dart:math';
import 'package:tipo/connections/firebase.dart';
import 'package:tipo/l10n/l10n.dart';
import 'package:tipo/provider/UserProvider.dart';
import 'package:tipo/screens/auth/login.dart';
import 'package:tipo/screens/main/langing_screen.dart';
import 'package:tipo/screens/main/splash_screen.dart';
import 'package:tipo/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late String userUID = "loading";
  late String landingRunned = "true";

  @override
  void initState() {
    super.initState();
    _handleAuthenticatedState().then((value) {
      WidgetsBinding.instance?.addObserver(this);
      FirestoreHelper.getUserData().then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: ((context) => UserProvider()),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.dark,
            title: 'tipo',
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: (() {
              // your code here
              if (landingRunned != "true") {
                if (userUID == "loading") {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  );
                } else if (userUID == "") {
                  return LoginPage();
                } else {
                  return SplashScreen();
                }
              } else {
                LandingScreen();
              }
            }())));
  }

  Future<void> _handleAuthenticatedState() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userUID");
    var _landingRunned = sharedPreferences.getString("landingRunned");

    setState(() {
      userUID = _usermail.toString();
      landingRunned = _landingRunned.toString();
    });
  }
}
