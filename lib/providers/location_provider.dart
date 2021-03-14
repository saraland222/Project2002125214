import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  double latitude = 37.421632;
  bool loading = false;
  double longitude = 122.084664;
  bool permissionAllowed = false;
  var selecteAddress;

  Future<void> getCurrentPostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      final coordinates = new Coordinates(
        this.latitude,
        this.longitude,
      );
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selecteAddress = addresses.first;
      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Permission not allowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(
      this.latitude,
      this.longitude,
    );
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selecteAddress = addresses.first;
    notifyListeners();
    print("${selecteAddress.featureName} : ${selecteAddress.addressLine}");
  }

  Future<void> savePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setDouble('latitude', this.latitude);
    preferences.setDouble('lognitude', this.longitude);
    preferences.setString('address', this.selecteAddress.addressLine);
    preferences.setString('loaction', this.selecteAddress.featureName);
  }
}
