import 'package:first/screens/login.dart';
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
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  // bool _HoverSignUpBtn = false;
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
    return Scaffold(
        backgroundColor: Colors.white,

        // appBar: AppBar(
        //   title: const Text("Hey"),
        // ),
        // extendBodyBehindAppBar: true,

        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Get Started!',
                    style: GoogleFonts.quicksand(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(212, 241, 120, 120)),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 400) {
                      // Use Row when the screen width is greater than 400
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Join us and embark on unforgettable",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              color: Color.fromARGB(150, 144, 67, 67),
                            ),
                          ),
                          Text(
                            " adventures",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              color: Color.fromARGB(150, 144, 67, 67),
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
                                fontSize: 20,
                                color: Color.fromARGB(150, 144, 67, 67),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "adventures",
                              style: GoogleFonts.quicksand(
                                fontSize: 20,
                                color: Color.fromARGB(150, 144, 67, 67),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: TextFormField(
                    style: GoogleFonts.quicksand(color: Colors.grey),

                    controller: _fullName,
                    validator: (value) {
                      if (value == "" || value!.isEmpty) {
                        return "Please enter your full name";
                      } else {
                        return null;
                      }
                    },
                    key: const ValueKey("fullName"),
                    keyboardType: TextInputType.name,
                    onTap: () {},
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 81, 80, 80))),
                      // labelStyle: const TextStyle(color: Colors.black),
                      // label: Text("HEy")
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Enter Full Name",
                      prefixIcon:
                          Icon(Icons.man_2_outlined, color: Colors.grey),

                      // Icon(Icons.visibility)
                    ),
                    // obscureText: _visibile,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: TextFormField(
                    style: GoogleFonts.quicksand(color: Colors.grey),
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your full name";
                      } else if (!value.contains('@')) {
                        return "Characters must include the @ symbol";
                      } else {
                        return null;
                      }
                    },
                    key: const ValueKey("emailAddress"),
                    keyboardType: TextInputType.emailAddress,
                    onTap: () {},
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 81, 80, 80))),
                      // labelStyle: const TextStyle(color: Colors.black),
                      // label: Text("HEy")
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Enter Email Address",
                      prefixIcon: Icon(Icons.mail_outlined, color: Colors.grey),

                      // Icon(Icons.visibility)
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10.0),
                    child: IntlPhoneField(
                      style: GoogleFonts.quicksand(color: Colors.grey),
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
                        color: Colors.grey,
                      ),
                      dropdownTextStyle: const TextStyle(color: Colors.black),
                      key: const ValueKey("phone"),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Enter Phone Number',
                        labelStyle: TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 81, 80, 80)),
                        ),
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
                    style: GoogleFonts.quicksand(color: Colors.grey),
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
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 81, 80, 80))),
                      // labelStyle: const TextStyle(color: Colors.black),
                      // label: Text("HEy")
                      labelStyle: const TextStyle(color: Colors.grey),
                      labelText: "Enter Password",
                      prefixIcon: const Icon(Icons.password_rounded,
                          color: Colors.grey),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _visibile = !_visibile;
                            });
                          },
                          child: Icon(
                              _visibile
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  _visibile ? Colors.grey : Colors.redAccent)),
                      // Icon(Icons.visibility)
                    ),
                    obscureText: _visibile,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 10.0),
                  child: TextFormField(
                    style: GoogleFonts.quicksand(color: Colors.grey),
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
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 81, 80, 80))),
                      // labelStyle: const TextStyle(color: Colors.black),
                      // label: Text("HEy")
                      labelStyle: const TextStyle(color: Colors.grey),
                      labelText: "Re-Enter Password",
                      prefixIcon: const Icon(Icons.password_rounded,
                          color: Colors.grey),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _visibile = !_visibile;
                            });
                          },
                          child: Icon(
                              _visibile
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  _visibile ? Colors.grey : Colors.redAccent)),
                      // Icon(Icons.visibility)
                    ),
                    obscureText: _visibile,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          animationDuration: const Duration(milliseconds: 200),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Colors.red;
                              }
                              return Colors.redAccent;
                            },
                          ),
                        ),
                        onPressed: () {
                          navigateToInterestPage();
                        },
                        // onPressed: () {
                        //   if (_formKey.currentState!.validate()) {
                        //     var fullName = _fullName.text;
                        //     var email = _email.text;
                        //     var phone = number;
                        //     var password = _password.text;
                        //     var password2 = _password2.text;

                        //     print("Full Name is : " + fullName);
                        //     print("Email address is : " + email);
                        //     print("Phone number is : " + phone);
                        //     print("Password : " + password);
                        //     print("Second password : " + password2);

                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text("Loading..Please wait")),
                        //     );

                        //     navigateToInterestPage();
                        //   } else {
                        //     return null;
                        //   }

                        // },
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
                        style: GoogleFonts.quicksand(color: Colors.black),
                        children: [
                          WidgetSpan(
                            child: SizedBox(width: 5),
                          ), // Add space of width 10

                          TextSpan(
                            text: "Sign In",
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
                                        const LoginPage(), // Provide the destination page widget
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
        ));
  }
}
