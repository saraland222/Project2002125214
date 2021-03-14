import 'package:appdevl/services/store_services.dart';
import 'package:appdevl/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../welcomeScreen.dart';

class StoreProvider with ChangeNotifier {
  StoreService storeService = StoreService();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatiude = 0.0;
  var userLongitude = 0.0;
  String selectedStore;
  String selectedStoreId;
  DocumentSnapshot storedetails;
  String distanc;
  String selectedProductCategory;

  getSelectedStore(storeDetails, distance) {
    this.storedetails = storeDetails;
    this.distanc = distance;
    notifyListeners();
  }
  selectedCategory(category) {
    this.selectedProductCategory = category;
    notifyListeners();
  }

  Future<void> getUserLocationData(context) async {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        this.userLatiude = result.data()['latitude'];
        this.userLongitude = result.data()['lognitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
  }

  //the code from package geolocation
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
