import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/home.dart';
import 'package:flutter/gestures.dart';

// import 'package:first/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _visibile = true;
  bool _hoverColor = false;
  // bool _hoverText = false;
  // bool _hoverRegister = false;
  dynamic number;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _email = '';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // void checkUserLoggedIn() {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;

  //   if (user != null) {
  //     // User is authenticated, redirect to the dashboard screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => Home()),
  //     );
  //   } else {
  //     // User is not authenticated, stay on the login screen
  //   }
  // }

  Future _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var password = _password.text;
      var email = _emailController.text;
      // try {
      //   UserCredential userCredential =
      //       await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: email,
      //     password: password,
      //   );
      //   print(userCredential);
      //   return userCredential;
      // } catch (e) {
      //   print('Error signing in: $e');
      //   return null;
      // }
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Clear the input fields
        setState(() {
          email = '';
          password = '';
        });
        // Show a success message using SnackBar
        _showMessage('Login Successful', Colors.green);
        // Redirect the user to the dashboard or any other screen as needed
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Show an error message using SnackBar
          _showMessage('No user found for that email.', Colors.red);
        } else if (e.code == 'wrong-password') {
          // Show an error message using SnackBar
          _showMessage('Invalid password', Colors.red);
        }
      } catch (e) {
        print(e.toString());
      }
      print('Email: ${email + password}');
    }
  }

  // Future<UserCredential?> signInWithEmailAndPassword(
  //     String email, String password) async {

  // }

  // @override
  // void initState() {
  //   super.initState();
  //   checkUserLoggedIn();
  // }

  void _showMessage(String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // _scaffoldKey.currentState?.openDrawer();
    // _scaffoldKey.currentState?.(

    // );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Scaffold(
          // key: _scaffoldKey,
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          // ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Container(
                  height: double.infinity,
                  width: double.infinity,
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage("assets/images/myPlane.jpg"),
                  //       fit: BoxFit.cover),
                  // ),
                  child: Image.asset(
                    "assets/images/back.jpeg",
                    fit: BoxFit.fitHeight,
                  )),

              Container(
                decoration: const BoxDecoration(
                  // color: Color.fromRGBO(255, 255, 255, 0.3),
                  // color: Colors.black12,
                  gradient: LinearGradient(colors: [
                    Colors.black87,
                    Colors.transparent,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),

                  // color: Colors.black,
                  // borderRadius:
                  //     BorderRadius.all(Radius.circular(10))
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage("assets/images/new-app-logo.png"),
                          radius: 30,
                        ),
                      ),
                      Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: Text(
                                "Welcome back!",
                                style: GoogleFonts.quicksand(
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 0.0),
                              child: Text(
                                "We are waiting for you",
                                style: GoogleFonts.quicksand(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Text(
                                "Sign in and start your trip with us",
                                style: GoogleFonts.quicksand(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          style: GoogleFonts.quicksand(color: Colors.white),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            enabled: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                          validator: _validateEmail,
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 20.0, vertical: 20.0),
                      //   child: IntlPhoneField(
                      //     style: GoogleFonts.quicksand(color: Colors.white),
                      //     dropdownIcon: const Icon(
                      //       Icons.arrow_drop_down,
                      //       color: Colors.white,
                      //     ),
                      //     dropdownTextStyle:
                      //         const TextStyle(color: Colors.white),
                      //     disableLengthCheck: true,
                      //     controller: _phoneNumber,
                      //     validator: (phone) {
                      //       final phoneNumber = phone?.number ?? '';
                      //       if (phoneNumber.isEmpty) {
                      //         return "Please enter a phone number";
                      //       } else if (phoneNumber.length < 9) {
                      //         return "Phone number must be at least 9 digits";
                      //       } else if (phoneNumber.length > 9) {
                      //         return "Phone number must be 9 digits";
                      //       } else {
                      //         return null;
                      //       }
                      //     },
                      //     key: const ValueKey("phone"),
                      //     keyboardType: TextInputType.phone,
                      //     decoration: const InputDecoration(
                      //       labelText: 'Phone Number',
                      //       labelStyle: TextStyle(color: Colors.white),
                      //       enabledBorder: UnderlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.white),
                      //       ),
                      //       border: UnderlineInputBorder(
                      //         borderSide: BorderSide(),
                      //       ),
                      //     ),
                      //     initialCountryCode: 'GH',
                      //     onChanged: (phone) {
                      //       print("Code is: ${phone.completeNumber}");
                      //       number = phone.completeNumber;
                      //     },
                      //     onCountryChanged: (country) {
                      //       print('Country changed to ${country.name}');
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          style: GoogleFonts.quicksand(color: Colors.white),
                          controller: _password,
                          validator: (value) {
                            if (value == "" || value!.isEmpty) {
                              return "Please enter a password";
                            } else {
                              return null;
                            }
                          },
                          key: const ValueKey("password"),
                          keyboardType: TextInputType.visiblePassword,
                          onTap: () {},
                          decoration: InputDecoration(
                            enabled: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            labelStyle: const TextStyle(color: Colors.white),
                            // label: Text("HEy"),
                            labelText: "Password",
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _visibile = !_visibile;
                                  });
                                },
                                child: Icon(
                                  _visibile
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _visibile
                                      ? Colors.white
                                      : Colors.redAccent,
                                )),
                            // Icon(Icons.visibility)
                          ),
                          obscureText: _visibile,
                        ),
                      ),
                      SizedBox(
                        //             // width: 100,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  50.0), // Add padding to the left and right sides
                          width: double.infinity,
                          // alignment: AlignmentDirectional.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: OutlinedButton(
                                onHover: (value) {
                                  setState(() {
                                    _hoverColor = value;
                                  });
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          _hoverColor
                                              ? Colors.red.shade100
                                              : Colors.redAccent),
                                ),
                                onPressed: _submitForm,
                                child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Login"))),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text.rich(
                          TextSpan(
                              text: "Don't have an account?",
                              style: GoogleFonts.quicksand(color: Colors.white),
                              children: [
                                WidgetSpan(
                                  child: SizedBox(width: 5),
                                ), // Add space of width 10

                                TextSpan(
                                  text: "Click here",
                                  style: GoogleFonts.quicksand(
                                    color: Colors.redAccent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.redAccent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Handle the onTap event here
                                      // print('Click here tapped!');
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(
                                              milliseconds:
                                                  500), // Set the duration of the animation
                                          pageBuilder: (_, __, ___) =>
                                              const RegisterPage(), // Provide the destination page widget
                                          transitionsBuilder:
                                              (_, animation, __, child) {
                                            // Define the desired transition animation
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                      // Perform desired action
                                    },
                                ),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              )
              // Container(
              //   decoration: const BoxDecoration(
              //     // color: Color.fromRGBO(255, 255, 255, 0.3),
              //     // color: Colors.black12,
              //     gradient: LinearGradient(colors: [
              //       Colors.black87,
              //       Colors.transparent,
              //     ], begin: Alignment.bottomCenter, end: Alignment.topCenter),

              //     // color: Colors.black,
              //     // borderRadius:
              //     //     BorderRadius.all(Radius.circular(10))
              //   ),
              //   width: double.infinity, // Specify your desired width here
              //   height: double.infinity,
              //   child: SingleChildScrollView(
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 65.0),
              //           child: Text(
              //             "Welcome back!",
              //             style: GoogleFonts.lato(
              //                 fontSize: 30.0,
              //                 fontWeight: FontWeight.bold,
              //                 fontStyle: FontStyle.italic),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 90.0, vertical: 10.0),
              //           child: Text(
              //             "We are waiting for you",
              //             style: GoogleFonts.lato(fontSize: 15.0),
              //           ),
              //         ),
              //         Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 60.0, vertical: 0.0),
              //           child: Text(
              //             "Sign in and start your trip with us",
              //             style: GoogleFonts.lato(fontSize: 15.0),
              //           ),
              //         ),
              //         Center(
              //           child: Padding(
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 20.0, vertical: 20.0),
              //               child: IntlPhoneField(
              //                 disableLengthCheck: true,
              //                 controller: _phoneNumber,
              //                 validator: (phone) {
              //                   final phoneNumber = phone?.number ?? '';
              //                   if (phoneNumber.isEmpty) {
              //                     return "Please enter a phone number";
              //                   } else if (phoneNumber.length < 9) {
              //                     return "Phone number must be at least 9 digits";
              //                   } else if (phoneNumber.length > 9) {
              //                     return "Phone number must be 9 digits";
              //                   } else {
              //                     return null;
              //                   }
              //                 },
              //                 key: const ValueKey("phone"),
              //                 keyboardType: TextInputType.phone,
              //                 decoration: const InputDecoration(
              //                   labelText: 'Phone Number',
              //                   border: UnderlineInputBorder(
              //                     borderSide: BorderSide(),
              //                   ),
              //                 ),
              //                 initialCountryCode: 'GH',
              //                 onChanged: (phone) {
              //                   print("Code is: ${phone.completeNumber}");
              //                   number = phone.completeNumber;
              //                 },
              //                 onCountryChanged: (country) {
              //                   print('Country changed to ${country.name}');
              //                 },
              //               )),
              //         ),
              //         Center(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 20.0, vertical: 10.0),
              //             child: TextFormField(
              //               controller: _password,
              //               validator: (value) {
              //                 if (value == "" || value!.isEmpty) {
              //                   return "Please enter a password";
              //                 } else if (value.length < 7) {
              //                   return "Please enter at least 7 characters";
              //                 } else {
              //                   return null;
              //                 }
              //               },
              //               key: const ValueKey("password"),
              //               keyboardType: TextInputType.visiblePassword,
              //               onTap: () {},
              //               decoration: InputDecoration(
              //                 // labelStyle: const TextStyle(color: Colors.black),
              //                 // label: Text("HEy"),
              //                 labelText: "Password",
              //                 suffixIcon: GestureDetector(
              //                     onTap: () {
              //                       setState(() {
              //                         _visibile = !_visibile;
              //                       });
              //                     },
              //                     child: Icon(_visibile
              //                         ? Icons.visibility
              //                         : Icons.visibility_off)),
              //                 // Icon(Icons.visibility)
              //               ),
              //               obscureText: _visibile,
              //             ),
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
              //                             MaterialStateProperty.all<Color>(
              //                                 _hoverColor
              //                                     ? Colors.red.shade100
              //                                     : Colors.lightGreen),
              //                       ),
              //                       onPressed: () {
              //                         if (_formKey.currentState!.validate()) {
              //                           var password = _password.text;
              //                           var phone = number;
              //                           print("Number" + phone);
              //                           print("Password" + password);

              //                           ScaffoldMessenger.of(context)
              //                               .showSnackBar(
              //                             const SnackBar(
              //                                 content:
              //                                     Text("Loading..Please wait")),
              //                           );
              //                         } else {
              //                           return null;
              //                         }
              //                         // else {
              //                         //   showDialog(
              //                         //     context: context,
              //                         //     builder:
              //                         //         (BuildContext context) {
              //                         //       return AlertDialog(
              //                         //         title:
              //                         //             const Text("Sorry"),
              //                         //         content: const Text(
              //                         //             "Please fill in all the required fields."),
              //                         //         actions: [
              //                         //           TextButton(
              //                         //             onPressed: () {
              //                         //               Navigator.of(
              //                         //                       context)
              //                         //                   .pop();
              //                         //             },
              //                         //             child: const Text(
              //                         //                 "OK"),
              //                         //           ),
              //                         //         ],
              //                         //       );
              //                         //     },
              //                         //   );
              //                         // }
              //                       },
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
              //                   style: GoogleFonts.lato(
              //                       backgroundColor: Colors.transparent,
              //                       color: _hoverText
              //                           ? Colors.redAccent
              //                           : Colors.white),
              //                 )),
              //           ),
              //         ),
              //         Container(
              //           alignment: Alignment.center,
              //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //           child: Padding(
              //               padding: const EdgeInsets.only(top: 9.0),
              //               child: TextButton(
              //                 style: ButtonStyle(
              //                   overlayColor: MaterialStateProperty.all<Color?>(
              //                       Colors.transparent),
              //                 ),
              //                 onPressed: () {
              //                   Navigator.push(
              //                     context,
              //                     PageRouteBuilder(
              //                       transitionDuration: const Duration(
              //                           milliseconds:
              //                               500), // Set the duration of the animation
              //                       pageBuilder: (_, __, ___) =>
              //                           const RegisterPage(), // Provide the destination page widget
              //                       transitionsBuilder:
              //                           (_, animation, __, child) {
              //                         // Define the desired transition animation
              //                         return FadeTransition(
              //                           opacity: animation,
              //                           child: child,
              //                         );
              //                       },
              //                     ),
              //                   );
              //                 },
              //                 onHover: (value) {
              //                   setState(() {
              //                     _hoverRegister = value;
              //                   });
              //                 },
              //                 child: Text(
              //                   "Don't have an acount? Register Now!",
              //                   style: GoogleFonts.quicksand(
              //                       backgroundColor: Colors.transparent,
              //                       color: _hoverRegister
              //                           ? Colors.redAccent
              //                           : Colors.greenAccent),
              //                 ),
              //               )),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
