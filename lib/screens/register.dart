import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/login.dart';
import 'package:first/styles/app_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'interest-page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _visibile = true;
  dynamic number;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  void createUserDocument(
      String userId, String email, String username, String phoneNumber) {
    usersCollection.doc(userId).set({
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      // Add more fields as needed
    });
  }

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

  void register(String email, String password, String username,
      String phoneNumber) async {
    // return debugPrint('${email} ${password} ${username} ${phoneNumber}');
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User registration successful, proceed to store additional information
      createUserDocument(
        userCredential.user!.uid,
        email,
        username,
        phoneNumber,
      );
      _showMessage("Your account has been created successfully", Colors.green);
    } catch (e) {
      // Handle any registration errors
      _showMessage("Something went wrong", Colors.red);

      print('Registration Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNumber.text = number ?? '';
  }

  void navigateToInterestPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(seconds: 1), // Adjust the animation duration as needed
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // Slide from right to left
              end: Offset.zero,
            ).animate(animation),
            child:
                InterestPage(), // Replace with the actual widget for the next page
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
        // backgroundColor: Colors.black,

        // appBar: AppBar(
        //   title: const Text("Hey"),
        // ),
        // extendBodyBehindAppBar: true,

        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: _screenSize.height * 0.05,
            ),
            Container(
              color: Styles.backgroundColor,
              padding: const EdgeInsets.only(top: 40.0),
              alignment: Alignment.center,
              child: Text(
                'Get Started!',
                style: GoogleFonts.quicksand(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Styles.brandMainColor),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 400) {
                  // Use Row when the screen width is greater than 400
                  //charley continue
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Join us and embark on unforgettable",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          color: Styles.brandLightShadeColor,
                        ),
                      ),
                      Text(
                        " adventures",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          color: Styles.brandLightShadeColor,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Use Wrap when the screen width is smaller or equal to 400
                  return Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 5),
                        alignment: Alignment.center,
                        child: Text(
                          "Join us and embark on unforgettable",
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "adventures",
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),

            // Center(

            // ),
            // Join us and embark on unforgettable adventures
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: TextFormField(
                style: GoogleFonts.quicksand(
                    color: Styles.supportingTextDeepShadeColor),

                controller: _username,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Please enter your full name";
                  } else {
                    return null;
                  }
                },
                key: const ValueKey("username"),
                keyboardType: TextInputType.name,
                onTap: () {},
                decoration: InputDecoration(
                  filled: true,
                  focusColor: Styles.brandDeepShadeColor,
                  // fillColor: Color.fromARGB(255, 237, 232, 232),
                  fillColor: Colors.grey.shade300,

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextDeepShadeColor)),
                  labelText: "Enter Username",
                  // hintText: 'Enter your email',
                  // hintStyle: TextStyle(
                  //     color: Styles.supportingTextDeepShadeColor),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextLightShadeColor)),
                  labelStyle: const TextStyle(color: Colors.black54),
                  // labelStyle: const TextStyle(color: Colors.black),
                  // label: Text("HEy")

                  prefixIcon: Icon(Icons.man_2_outlined, color: Colors.black54),

                  // Icon(Icons.visibility)
                ),
                // obscureText: _visibile,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: TextFormField(
                style: GoogleFonts.quicksand(
                    color: Styles.supportingTextDeepShadeColor),
                controller: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email address";
                  } else if (!value.contains('@')) {
                    return "Characters must include the @ symbol";
                  } else {
                    return null;
                  }
                },
                key: const ValueKey("emailAddress"),
                keyboardType: TextInputType.emailAddress,
                onTap: () {},
                decoration: InputDecoration(
                  filled: true,
                  focusColor: Styles.brandDeepShadeColor,
                  // fillColor: Color.fromARGB(255, 237, 232, 232),
                  fillColor: Colors.grey.shade300,

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextDeepShadeColor)),
                  labelText: "Enter Email Address",
                  // hintText: 'Enter your email',
                  // hintStyle: TextStyle(
                  //     color: Styles.supportingTextDeepShadeColor),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextLightShadeColor)),
                  labelStyle: const TextStyle(color: Colors.black54),
                  // labelStyle: const TextStyle(color: Colors.black),
                  // label: Text("HEy")

                  prefixIcon: Icon(Icons.mail_outlined, color: Colors.black54),

                  // Icon(Icons.visibility)
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 15.0),
                child: IntlPhoneField(
                  style: GoogleFonts.quicksand(
                      color: Styles.supportingTextDeepShadeColor),
                  disableLengthCheck: true,
                  controller: _phoneNumber,
                  validator: (phone) {
                    final phoneNumber = phone?.number ?? '';
                    if (phoneNumber.isEmpty) {
                      return "Please enter a phone number";
                    } else if (phoneNumber.length < 9) {
                      return "Phone number must be at least 9 digits";
                    } else if (phoneNumber.length > 9) {
                      return "Phone number must be 9 digits";
                    } else {
                      return null;
                    }
                  },
                  dropdownIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
                  dropdownTextStyle: const TextStyle(color: Colors.black),
                  key: const ValueKey("phone"),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    focusColor: Styles.brandDeepShadeColor,
                    // fillColor: Color.fromARGB(255, 237, 232, 232),
                    fillColor: Colors.grey.shade300,

                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Styles.supportingTextDeepShadeColor)),
                    labelText: 'Enter Phone Number',
                    // hintText: 'Enter your email',
                    // hintStyle: TextStyle(
                    //     color: Styles.supportingTextDeepShadeColor),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Styles.supportingTextLightShadeColor)),
                    labelStyle: const TextStyle(color: Colors.black54),
                    // labelStyle: const TextStyle(color: Colors.black),
                    // label: Text("HEy")

                    // Icon(Icons.visibility)
                  ),
                  initialCountryCode: 'GH',
                  onChanged: (phone) {
                    print("Code is: ${phone.completeNumber}");
                    number = phone.completeNumber;
                  },
                  onCountryChanged: (country) {
                    print('Country changed to ${country.name}');
                  },
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                style: GoogleFonts.quicksand(
                    color: Styles.supportingTextDeepShadeColor),
                controller: _password,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 7) {
                    return "Please enter at least 7 characters";
                  } else {
                    return null;
                  }
                },
                key: const ValueKey("password"),
                keyboardType: TextInputType.visiblePassword,
                onTap: () {},
                decoration: InputDecoration(
                  filled: true,
                  focusColor: Styles.brandDeepShadeColor,
                  // fillColor: Color.fromARGB(255, 237, 232, 232),
                  fillColor: Colors.grey.shade300,

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextDeepShadeColor)),
                  labelText: "Enter Password",
                  // hintText: 'Enter your email',
                  // hintStyle: TextStyle(
                  //     color: Styles.supportingTextDeepShadeColor),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextLightShadeColor)),
                  labelStyle: const TextStyle(color: Colors.black54),
                  // labelStyle: const TextStyle(color: Colors.black),
                  // label: Text("HEy")

                  prefixIcon:
                      const Icon(Icons.password_rounded, color: Colors.black54),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _visibile = !_visibile;
                        });
                      },
                      child: Icon(
                          _visibile ? Icons.visibility : Icons.visibility_off,
                          color:
                              _visibile ? Colors.black54 : Colors.redAccent)),

                  // Icon(Icons.visibility)
                ),
                obscureText: _visibile,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
              child: TextFormField(
                style: GoogleFonts.quicksand(
                    color: Styles.supportingTextDeepShadeColor),
                controller: _password2,
                validator: (value) {
                  if (value == "" || value!.isEmpty) {
                    return "Please enter a password";
                  } else if (value.length < 7) {
                    return "Please enter at least 7 characters";
                  } else if (value != _password.text) {
                    return "Passwords do not match";
                  } else {
                    return null;
                  }
                },
                key: const ValueKey("secondPassword"),
                keyboardType: TextInputType.visiblePassword,
                onTap: () {},
                decoration: InputDecoration(
                  filled: true,
                  focusColor: Styles.brandDeepShadeColor,
                  // fillColor: Color.fromARGB(255, 237, 232, 232),
                  fillColor: Colors.grey.shade300,

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextDeepShadeColor)),
                  labelText: "Re-Enter Password",
                  // hintText: 'Enter your email',
                  // hintStyle: TextStyle(
                  //     color: Styles.supportingTextDeepShadeColor),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextLightShadeColor)),
                  labelStyle: const TextStyle(color: Colors.black54),
                  // labelStyle: const TextStyle(color: Colors.black),
                  // label: Text("HEy")
//Charley continue finish the country one make u continue.. i almost finish dey chop
                  prefixIcon:
                      const Icon(Icons.password_rounded, color: Colors.black54),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _visibile = !_visibile;
                        });
                      },
                      child: Icon(
                          _visibile ? Icons.visibility : Icons.visibility_off,
                          color:
                              _visibile ? Colors.black54 : Colors.redAccent)),

                  // You fit continue
                ),
                obscureText: _visibile,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      animationDuration: const Duration(milliseconds: 200),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.red;
                          }
                          return Colors.redAccent;
                        },
                      ),
                    ),
                    onPressed: () {
                      register(_email.text, _password.text, _username.text,
                          _phoneNumber.text);
                      navigateToInterestPage();
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.only(top: 10.0),
              child: Text.rich(
                TextSpan(
                    text: "Already a member?",
                    style: GoogleFonts.quicksand(color: Colors.grey.shade600),
                    children: [
                      WidgetSpan(
                        child: SizedBox(width: 5),
                      ), // Add space of width 10

                      TextSpan(
                        text: "Sign In",
                        style: GoogleFonts.quicksand(
                          color: Styles.brandMainColor,
                          decoration: TextDecoration.underline,
                          decorationColor: Styles.brandMainColor,
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
                                    const LoginPage(), // Provide the destination page widget
                                transitionsBuilder: (_, animation, __, child) {
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
    ));
  }
}
