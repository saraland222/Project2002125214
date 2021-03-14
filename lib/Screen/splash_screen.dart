import 'dart:async';
import 'package:appdevl/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../welcomeScreen.dart';
import 'landing_screen.dart';
import 'mainScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          getUserData();
        }
      });
    });
    super.initState();
  }

  getUserData() async {
    UserServices _userServices = UserServices();
    _userServices.getUserById(user.uid).then((result) {
      //check location details has or not
      if (result.data()['address'] != null) {
        //if address details exits
        updatePref(result);
      }
      //if address details does not exists
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePref(result) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('latitude', result['latitude']);
    preferences.setDouble('lognitude', result['lognitude']);
    preferences.setString('address', result['address']);
    preferences.setString('loaction', result['loaction']);
    //after update pref Navigator to home screen
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child:
              Hero(tag: 'logo', child: Image.asset('assets/images/logo1.png')),
        ),
      ),
    );
  }
}
