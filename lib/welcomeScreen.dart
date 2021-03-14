
import 'package:appdevl/providers/auth_provider.dart';
import 'package:appdevl/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screen/map_screen.dart';
import 'onboardingScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottoSheet(context) {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              auth.error,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      'Enter your phone number to procees',
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                          prefixText: '+7',
                          labelText: '10 digit mobile number'),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
                            validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: validPhoneNumber ? false : true,
                            child: FlatButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+7${_phoneNumberController.text}';
                                auth
                                    .verifyphone(
                                    context: context, number: number)
                                    .then((value) {
                                  _phoneNumberController.clear();
                                  auth.loading = false;
                                });
                              },
                              color: validPhoneNumber
                                  ? Colors.amberAccent
                                  : Colors.grey,
                              child: Text(auth.loading
                                  ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              )
                                  : validPhoneNumber
                                  ? 'CONTINUE'
                                  : 'ENTER PHONE NUMBER'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: OnboardingScreen(),
                ),
                Text('Ready to order from your nearest shop?'),
                SizedBox(
                  height: 20.0,
                ),
                FlatButton(
                  color: Colors.amberAccent,
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;

                    });
                    await locationData.getCurrentPostion();
                    if (locationData.permissionAllowed == true) {
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading = false;
                      });
                    } else {
                      print('Permission not allowed');
                    }
                  },
                  child: locationData.loading
                      ? CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blue),
                  )
                      : Text('Set Delivery Loctaion'),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = 'login';
                    });
                    showBottoSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                        text: 'Aleady a Customer ?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  'SKIP',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
