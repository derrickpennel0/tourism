import 'dart:convert';
import 'dart:ui';
// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/Carousel.dart';
import 'package:first/components/autcomplete.dart';
import 'package:first/screens/bookmarks.dart';
import 'package:first/screens/details.dart';
import 'package:first/screens/explore.dart';
import 'package:first/screens/first_timers_page.dart';
import 'package:first/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/myDrawerListTile.dart';
import './login.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../main.dart';
import "dart:developer" as console show log;

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

  Future forYou() async {
    return FirebaseFirestore.instance.collection('sites').limit(3).get();
  }

  bool show = false;

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
          FirebaseAuth.instance.currentUser != null ? '@${_username}' : '',
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
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
              } else if (value == 'Sign in') {
                Navigator.pushNamed(context, "/login");
              }
            },
            itemBuilder: (BuildContext context) => [
              FirebaseAuth.instance.currentUser != null
                  ? PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    )
                  : PopupMenuItem<String>(
                      value: 'Sign in',
                      child: Text('Sign in'),
                    )
            ],
          ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: FirebaseAuth.instance.currentUser != null
                    ? Row(
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
                                Text(_username ?? "",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      // color: const Color.fromARGB(149, 255, 255, 255),
                                    )),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                    FirebaseAuth.instance.currentUser?.email ??
                                        "",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.redAccent,
                                    )),
                              ],
                            ),
                          )
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, "/login");
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.redAccent)),
                        child: Text(
                          "Sign in",
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )),
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/back.jpeg"),
                  ),
                ),
              ),
              MyDrawerListTile(
                title: "Profile",
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
              MyDrawerListTile(
                  title: "My bookmarks",
                  leadingIcon: Icons.bookmark_border,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Bookmarks(),
                        ));
                  }),
              // MyDrawerListTile(
              //     title: "Log out",
              //     leadingIcon: Icons.logout_outlined,
              //     onTap: () {}),
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
                    'Recommended',
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  InkWell(
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Explore(),
                                ));
                          },
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          label: Text('View more',
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 4,
              ),
              SizedBox(
                  height: 210,
                  child: FutureBuilder(
                    future: forYou(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List documents = snapshot.data.docs;
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final document = documents[index];
                              print('${document['name']} , ghana');

                              return ForYouWidget(
                                  name: document['name'],
                                  rating: document['rating'],
                                  location: document['locationString']);
                            });
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),

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

class ForYouWidget extends StatefulWidget {
  final String name;
  final String location;
  final String rating;

  const ForYouWidget({
    super.key,
    required this.name,
    required this.location,
    required this.rating,
  });

  @override
  State<ForYouWidget> createState() => _ForYouWidgetState();
}

class _ForYouWidgetState extends State<ForYouWidget> {
  bool toggle = false;
  // void _onTextChange() {
  //   setState(() {
  //     show = true;
  //   });
  // }

  void checkBookmarkStatus() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final userId = FirebaseAuth.instance.currentUser?.email;
      final site = widget.name;
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot querySnapshot =
          await collectionRef.where('email', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('bookmarks')) {
          List<dynamic> sites = data['bookmarks'];

          if (sites.contains(site)) {
            setState(() {
              toggle = true;
            });
          } else {
            setState(() {
              toggle = false;
            });
          }
        }
      }
    }
  }

  void bookmark() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final userId = FirebaseAuth.instance.currentUser?.email;
      final site = widget.name;
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot querySnapshot =
          await collectionRef.where('email', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final DocumentReference documentRef = FirebaseFirestore.instance
            .collection('users')
            .doc(documentSnapshot.reference.id);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final DocumentSnapshot snapshot = await transaction.get(documentRef);
          final data = snapshot.data() as Map<String,
              dynamic>; // Explicitly cast to Map<String, dynamic>

          if (snapshot.exists) {
            final List<dynamic> bookmarks = data['bookmarks'] ?? [];

            if (bookmarks.contains(site)) {
              bookmarks.remove(site);
              setState(() {
                toggle = false;
              });
            } else {
              bookmarks.add(site);
              setState(() {
                toggle = true;
              });
            }

            transaction.update(documentRef, {'bookmarks': bookmarks});
          } else {
            transaction.set(documentRef, {
              'bookmarks': [site]
            });
          }
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Kindly sign into your accont'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Log in'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/login");

                  // signOutUser();
                  // Call the signOutUser function
                },
              ),
            ],
          );
        },
      );
    }
  }

  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(name: widget.name),
            ))
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        height: 200,
        width: 160,
        decoration: BoxDecoration(
          // color: Styles.tileColor,
          // boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2)],
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Column(
          children: [
            SizedBox(
                height: 200,
                width: 160,
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
                      top: 1.5,
                      right: 1.5,
                      child: GestureDetector(
                        onTap: () {
                          bookmark();
                        },
                        child: Container(
                          height: 27,
                          width: 27,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white.withOpacity(0.8),
                          ),
                          child: Center(
                            child: !toggle
                                ? const Icon(
                                    Icons.bookmark_outline,
                                    color: Colors.redAccent,
                                    size: 25,
                                  )
                                : const Icon(
                                    Icons.bookmark,
                                    color: Colors.redAccent,
                                    size: 25,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 1,
                        child: Container(
                          height: 60,
                          width: 160,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.5),
                                Colors.transparent
                              ])),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.name,
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
                                            Container(
                                              width: 100,
                                              child: Text(
                                                widget.location,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        187, 255, 255, 255)),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
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
                                          widget.rating,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            // color: const Color.fromARGB(149, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                            ]),
                          ),
                        ))
                  ],
                )),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
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
