import 'package:appdevl/providers/auth_provider.dart';
import 'package:appdevl/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool validPhoneNumber = false;
var _phoneNumberController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Container(
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
                    prefixText: '+7', labelText: '10 digit mobile number'),
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 10,
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      validPhoneNumber = true;
                    });
                  } else {
                    setState(() {
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
                          setState(() {
                            auth.loading = true;
                            auth.screen = 'MapScreen';
                            auth.latitude = locationData.latitude;
                            auth.longitude = locationData.longitude;
                            auth.address =
                                locationData.selecteAddress.addressLine;
                          });
                          String number = '+7${_phoneNumberController.text}';
                          auth
                              .verifyphone(
                            context: context,
                            number: number,
                          )
                              .then((value) {
                            _phoneNumberController.clear();
                            setState(() {
                              auth.loading = false;
                            });
                          });
                        },
                        color:
                            validPhoneNumber ? Colors.amberAccent : Colors.grey,
                        child: auth.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              )
                            : Text(validPhoneNumber
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
      ),
    );
  }
}
