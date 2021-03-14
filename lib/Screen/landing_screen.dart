import 'package:appdevl/providers/location_provider.dart';
import 'package:flutter/material.dart';

import 'map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your Delivery Location to find nearest Stores for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              width: 600,
              child: Image.asset(
                'assets/images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : FlatButton(
                    color: Colors.green,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _locationProvider.getCurrentPostion();
                      if (_locationProvider.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.selecteAddress == false) {
                            print('Permission not allowed');
                            setState(() {
                              _isLoading = false;
                            });
                            //  Scaffold.of(context).showSnackBar(SnackBar(
                            //    content: Text(
                            //        'Please allow permission to find neares stores for you'),
                            //  ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Please allow permission to find neares stores for you'),
                              ),
                            );
                          }
                        });
                      }
                      //Navigator.pushNamed(context, HomeScreen.id);
                    },
                    child: Text(
                      'Set Your Location',
                      style: (TextStyle(color: Colors.white)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
