import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _visibile = true;
  bool _hoverColor = false;
  bool _hoverText = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          //  toolbarOpacity :0.1,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text("Login"),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/app-logo.png"),
              ),
            )
          ],
        ),

        extendBodyBehindAppBar: true,
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/myPlane.jpg"),
                  fit: BoxFit.cover),
            ),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Center(
                    child: Container(
                        decoration: const BoxDecoration(
                            // color: Colors.black,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        width: 450, // Specify your desired width here
                        height: 400,
                        child: Card(
                          color: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.0),
                                  child: Text(
                                    "Welcome back!",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Roboto",
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 90.0, vertical: 10.0),
                                  child: Text(
                                    "We are waiting for you",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 60.0, vertical: 0.0),
                                  child: Text(
                                    "Sign in and start your trip with us",
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: IntlPhoneField(
                                      key: const ValueKey("phone"),
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                      ),
                                      initialCountryCode: 'GH',
                                      onChanged: (phone) {
                                        print(phone.countryCode);
                                      },
                                      onCountryChanged: (country) {
                                        print('Country changed to: ' +
                                            country.name);
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    key: const ValueKey("password"),
                                    keyboardType: TextInputType.visiblePassword,
                                    onTap: () {},
                                    decoration: InputDecoration(
                                      // labelStyle: const TextStyle(color: Colors.black),
                                      // label: Text("HEy"),
                                      labelText: "Password",
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _visibile = !_visibile;
                                            });
                                          },
                                          child: Icon(_visibile
                                              ? Icons.visibility
                                              : Icons.visibility_off)),
                                      // Icon(Icons.visibility)
                                    ),
                                    obscureText: _visibile,
                                  ),
                                ),
                                SizedBox(
                                    // width: 100,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                50.0), // Add padding to the left and right sides
                                        width: double.infinity,
                                        // alignment: AlignmentDirectional.center,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30.0),
                                          child: OutlinedButton(
                                              onHover: (value) {
                                                setState(() {
                                                  _hoverColor = value;
                                                });
                                              },
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(_hoverColor
                                                            ? Colors
                                                                .red.shade100
                                                            : Colors
                                                                .lightGreen),
                                              ),
                                              onPressed: () {},
                                              child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text("Login"))),
                                        ))),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all<Color?>(
                                                  Colors.transparent),
                                        ),
                                        onPressed: () {},
                                        onHover: (value) {
                                          setState(() {
                                            _hoverText = value;
                                          });
                                        },
                                        child: Text(
                                          "Forgot Password? Click here",
                                          style: TextStyle(
                                              backgroundColor:
                                                  Colors.transparent,
                                              color: _hoverText
                                                  ? Colors.redAccent
                                                  : Colors.white),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))))),
        // body: Center(
        //   child: Padding(
        //     padding: const EdgeInsets.all(50),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const Padding(
        //           padding: EdgeInsets.only(bottom: 10.0),
        //           child: Text(
        //             "Welcome back",
        //             style:
        //                 TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //         const Padding(
        //           padding: EdgeInsets.only(bottom: 10.0),
        //           child: Text(
        //             "We are waiting for you",
        //             style: TextStyle(fontSize: 15.0),
        //           ),
        //         ),
        //         const Padding(
        //           padding: EdgeInsets.only(bottom: 30.0),
        //           child: Text(
        //             "Sign in and start your trip with us",
        //             style: TextStyle(fontSize: 15.0),
        //           ),
        //         ),
        //         IntlPhoneField(
        //           key: const ValueKey("phone"),
        //           keyboardType: TextInputType.phone,
        //           decoration: const InputDecoration(
        //             labelText: 'Phone Number',
        //             border: UnderlineInputBorder(
        //               borderSide: BorderSide(),
        //             ),
        //           ),
        //           initialCountryCode: 'GB',
        //           onChanged: (phone) {
        //             print(phone.countryCode);
        //           },
        //           onCountryChanged: (country) {
        //             print('Country changed to: ' + country.name);
        //           },
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 10.0),
        //           child: TextFormField(
        //             key: const ValueKey("password"),
        //             keyboardType: TextInputType.visiblePassword,
        //             onTap: () {},
        //             decoration: InputDecoration(
        //               // label: Text("HEy"),
        //               labelText: "Password",
        //               suffixIcon: GestureDetector(
        //                   onTap: () {
        //                     setState(() {
        //                       _visibile = !_visibile;
        //                     });
        //                   },
        //                   child: Icon(_visibile
        //                       ? Icons.visibility
        //                       : Icons.visibility_off)),
        //               // Icon(Icons.visibility)
        //             ),
        //             obscureText: _visibile,
        //           ),
        //         ),
        //         SizedBox(
        //             // width: 100,
        //             child: Container(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal:
        //                         50.0), // Add padding to the left and right sides
        //                 width: double.infinity,
        //                 // alignment: AlignmentDirectional.center,
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(top: 30.0),
        //                   child: OutlinedButton(
        //                       onHover: (value) {
        //                         setState(() {
        //                           _hoverColor = value;
        //                         });
        //                       },
        //                       style: ButtonStyle(
        //                         foregroundColor:
        //                             MaterialStateProperty.all<Color>(
        //                                 Colors.white),
        //                         backgroundColor:
        //                             MaterialStateProperty.all<Color>(_hoverColor
        //                                 ? Colors.red.shade100
        //                                 : Colors.lightGreen),
        //                       ),
        //                       onPressed: () {},
        //                       child: const Padding(
        //                           padding: EdgeInsets.all(10.0),
        //                           child: Text("Login"))),
        //                 ))),
        //         Container(
        //           alignment: Alignment.center,
        //           padding: const EdgeInsets.symmetric(horizontal: 50.0),
        //           child: Padding(
        //             padding: const EdgeInsets.only(top: 15.0),
        //             child: TextButton(
        //                 style: ButtonStyle(
        //                   overlayColor: MaterialStateProperty.all<Color?>(
        //                       Colors.transparent),
        //                 ),
        //                 onPressed: () {},
        //                 onHover: (value) {
        //                   setState(() {
        //                     _hoverText = value;
        //                   });
        //                 },
        //                 child: Text(
        //                   "Forgot Password? Click here",
        //                   style: TextStyle(
        //                       backgroundColor: Colors.transparent,
        //                       color:
        //                           _hoverText ? Colors.grey : Colors.blueAccent),
        //                 )),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
