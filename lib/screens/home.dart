import 'dart:convert';
// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/Carousel.dart';
import 'package:first/components/autcomplete.dart';
import 'package:first/screens/details.dart';
import 'package:first/screens/explore.dart';
import 'package:first/screens/first_timers_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/myDrawerListTile.dart';
import './login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';

class Suggestion {
  final String title;
  final String description;

  Suggestion({required this.title, required this.description});
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List filteredSuggestions = [];
  final TextEditingController _searchBox = TextEditingController();

  List<dynamic> items = [];

  @override
  void dispose() {
    _searchBox.dispose();
    super.dispose();
  }

  void getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      String? userName = snapshot.data()?['username'] as String?;
      setState(() {
        _username = userName;
      });
      print('User Name: $userName');
    } else {}
  }

  void signOutUser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      // Redirect the user to the login screen or any other screen as needed
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } catch (e) {
      print(e);
    }
  }

  bool show = false;
  // void _onTextChange() {
  //   setState(() {
  //     show = true;
  //   });
  // }

  String? _username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '${_username}',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // color: const Color.fromARGB(149, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () {
                            signOutUser();
                            // Call the signOutUser function
                            // Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.supervised_user_circle_sharp,
                        size: 75,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 55, top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_username!,
                              style: GoogleFonts.quicksand(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                // color: const Color.fromARGB(149, 255, 255, 255),
                              )),
                          SizedBox(
                            height: 3,
                          ),
                          Text(FirebaseAuth.instance.currentUser!.email!,
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent,
                              )),
                        ],
                      ),
                    )
                  ],
                ),
                //  ElevatedButton(
                //     style: ButtonStyle(
                //         minimumSize:
                //             MaterialStatePropertyAll(Size(double.infinity, 30)),
                //         backgroundColor:
                //             MaterialStatePropertyAll(Colors.redAccent)),
                //     onPressed: () {
                //       Navigator.pushNamed(
                //         context,
                //         "/login",
                //       );
                //     },
                //     child: Text(
                //       "Sign In",
                //       style: GoogleFonts.quicksand(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         // color: const Color.fromARGB(149, 255, 255, 255),
                //       ),
                //     )),
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/back.jpeg"),
                  ),
                ),
              ),
              MyDrawerListTile(
                title: "Home",
                leadingIcon: Icons.home,
                onTap: () {},
              ),
              // MyDrawerListTile(
              //   title: "Sign In",
              //   leadingIcon: Icons.exit_to_app_outlined,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const LoginPage()),
              //     );
              //   },
              // ),
              MyDrawerListTile(title: "Tour", onTap: () {}),
              MyDrawerListTile(title: "Go", onTap: () {}),
              MyDrawerListTile(title: "Next", onTap: () {}),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  height: 100,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: MySearchScreen()),
              // const SizedBox(
              //   height: 10,
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'For You',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      // color: const Color.fromARGB(149, 255, 255, 255),
                    ),
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Explore(),
                          ))
                    },
                    child: Row(
                      children: [
                        Text(
                          'See more',
                          style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 4,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => const ForYouWidget(),
                ),
              ),

              const SizedBox(
                height: 5,
              ),
              Stack(
                children: [
                  Carousel(),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black54.withOpacity(0.7),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: const Alignment(-1, 0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Traveler's Choice Best \n of the Best Hotels",
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "Traveler's Choice Best of the Best Hotels",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FirstTimersPage(),
                                        ));
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(100, 45)),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.white)),
                                  child: const Text(
                                    "See List",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              )
            ]),
      ),

      // const Image(image: AssetImage('assets/images/test.png'))
    );
  }
}

class ForYouWidget extends StatelessWidget {
  const ForYouWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 220,
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: const BoxDecoration(
        color: Color.fromARGB(191, 23, 23, 23),
        // boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2)],
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        "assets/images/desert.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: const Icon(
                          Icons.bookmark_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                ],
              )),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mountain Afadjato',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      // color: const Color.fromARGB(149, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 13,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        "Volta Region",
                        style: GoogleFonts.quicksand(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(187, 255, 255, 255)),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 12,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '4.5',
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      // color: const Color.fromARGB(149, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Ghc 90/',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                  children: [
                    TextSpan(
                      text: 'person',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Details(name: "Mountain Afadjato"),
                      ));
                },
                child: Icon(
                  Icons.arrow_right_alt_sharp,
                  color: Colors.white60,
                  size: 24,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          "Most Popular",
          "Recommended",
          "Trending",
          "Historic",
          "Nature",
          "Traditional"
        ]
            .map(
              (i) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 40,
                  width: 150,
                  alignment: Alignment.center,
                  child: ListTile(
                    // trailing: Icon(Icons.beach_access_outlined),
                    title: Text(
                      i.toString(),
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        // color: const Color.fromARGB(149, 255, 255, 255),
                      ),
                    ),
                  )),
            )
            .toList(),
      ),
    );
  }
}
