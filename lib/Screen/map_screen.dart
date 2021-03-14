import 'package:appdevl/Screen/mainScreen.dart';
import 'package:appdevl/providers/auth_provider.dart';
import 'package:appdevl/providers/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = LatLng(37.421632, 122.084664);
  GoogleMapController _mapController;
  bool locationg = false;
  bool loggedIn = false;
  User user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        loggedIn = true;
        // user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              onCameraMove: (CameraPosition postion) {
                setState(() {
                  locationg = true;
                });
                locationData.onCameraMove(postion);
              },
              onMapCreated: onCreated,
              onCameraIdle: () {
                setState(() {
                  locationg = false;
                });
                locationData.getMoveCamera();
              },
            ),
            Center(
              child: Container(
                height: 50.0,
                margin: EdgeInsets.only(bottom: 40.0),
                child: Image.asset('assets/images/marker.png'),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationg ? LinearProgressIndicator() : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: TextButton.icon(
                        icon: Icon(
                          Icons.location_searching,
                          color: Colors.amberAccent,
                        ),
                        label: Flexible(
                          child: Text(
                            locationg
                                ? 'Locating...'
                                : locationData.selecteAddress == null
                                    ? 'Location'
                                    : locationData.selecteAddress.featureName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        locationg
                            ? ''
                            : locationData.selecteAddress == null
                                ? ''
                                : locationData.selecteAddress.addressLine,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: AbsorbPointer(
                          absorbing: locationg ? true : false,
                          child: FlatButton(
                            onPressed: () {
                              //here save address in sharedPrefrence
                              locationData.savePrefs();
                              if (loggedIn == false) {
                                Navigator.pushNamed(context, LoginScreen.id);
                              } else {
                                setState(() {
                                  _auth.latitude = locationData.latitude;
                                  _auth.longitude = locationData.longitude;
                                  _auth.address =
                                      locationData.selecteAddress.addressLine;
                                  _auth.location =
                                      locationData.selecteAddress.featureName;
                                });
                                _auth
                                    .updateUser(
                                  id: user.uid,
                                  number: user.phoneNumber,
                                )
                                    .then((value) {
                                  if (value == true) {
                                    Navigator.pushReplacementNamed(
                                        context, MainScreen.id);
                                  }
                                });
                              }
                            },
                            color: locationg ? Colors.grey : Colors.black,
                            child: Text(
                              'CONFIRM LOCATION',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
