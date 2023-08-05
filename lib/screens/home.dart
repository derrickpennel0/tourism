import 'dart:convert';
import 'dart:math';
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
import 'package:first/screens/profile.dart';
import 'package:first/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

  List Images = [
    'forest',
    'lake',
    'mountain',
    'waterfalls',
    'zoo',
    'sanctuary'
  ];
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
    _body = bodies[0];
  }

  var _body;
  List bodies = [Dashboard(), Bookmarks(), ProfilePage()];

  var _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      key: _scaffoldKey,

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
      body: _body,

      bottomNavigationBar: GNav(
          rippleColor: Colors.grey, // tab button ripple color when pressed
          hoverColor: Colors.grey, // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 30,
          tabMargin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          // backgroundColor: Colors.redAccent,
          tabActiveBorder: Border.all(
              color: Colors.transparent, width: 1), // tab button border
          tabBorder: Border.all(
              color: Colors.transparent, width: 0), // tab button border
          tabShadow: [
            // BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
          ], // tab button shadow
          curve: Curves.easeInOut, // tab animation curves
          // duration: Duration(milliseconds: 100), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.redAccent,
          tabBackgroundGradient: RadialGradient(
            colors: [
              Colors.grey.shade100,
              Colors.grey.shade600,

              // Colors.transparent,
            ],
            radius: 3,
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
          ), // selected icon and text color
          iconSize: 30, // tab button icon size
          // tabBackgroundColor: Colors.grey.shade300,
          textStyle: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800),
          // selected tab background color
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
              _body = bodies[value];
            });
          },
          selectedIndex: _selectedIndex,
          // navigation bar padding
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.bookmark_outline,
              text: 'Bookmarks',
            ),
            GButton(
              icon: Icons.person_outline,
              text: 'Profile',
            ),
          ]),
      // bottomNavigationBar: BottomNavigationBar(
      //     selectedIconTheme: IconThemeData(color: Colors.redAccent),
      //     selectedLabelStyle: MaterialStateTextStyle.resolveWith((states) {
      //       if (states.contains(MaterialState.selected)) {
      //         return TextStyle(color: Colors.red);
      //       }
      //       return TextStyle(color: Colors.black);
      //     }),

      //     // selectedLabelStyle: MaterialStateProperty.all(
      //     //    TextStyle(color: Colors.red),
      //     // ),
      //     // TextStyle(color: Colors.red),
      //     // GoogleFonts.quicksand(
      //     //   fontSize: 13,
      //     //   fontWeight: FontWeight.w900,
      //     //   color: Colors.redAccent,
      //     // ),
      //     currentIndex: _selectedIndex,
      //     onTap: (value) {
      //       setState(() {
      //         _selectedIndex = value;
      //         _body = bodies[value];
      //       });
      //     },
      //     items: [
      //       BottomNavigationBarItem(
      //         label: "Home",
      //         icon: Icon(Icons.home_filled),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.bookmark),
      //         label: "Bookmark",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Profile',
      //       ),
      //     ]),
      // const Image(image: AssetImage('assets/images/test.png'))
    );
  }
}

class ForYouWidget extends StatefulWidget {
  final String name;
  final String location;
  final String rating;
  final String image;

  const ForYouWidget({
    super.key,
    required this.name,
    required this.location,
    required this.rating,
    required this.image,
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
      final site = {'name': widget.name, 'location': widget.location};
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot querySnapshot =
          await collectionRef.where('email', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('bookmarks')) {
          List<dynamic> sites = data['bookmarks'];
          bool isBookmarkPresent(String name, String location) {
            return sites.any((bookmark) =>
                bookmark['name'] == name && bookmark['location'] == location);
          }

          if (isBookmarkPresent(widget.name, widget.location)) {
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

  Future<void> bookmark(String name, String location) async {
    try {
      // Get the current logged-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is logged in.');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Kindly log into your account",
                style: GoogleFonts.quicksand(
                    color: Colors.grey[800], fontWeight: FontWeight.w700)),
            actions: [
              TextButton(
                child: Text("Cancel",
                    style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "Ok",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/login");
                },
              )
            ],
          ),
        );
        return;
      }

      // Get a reference to the user's document in Firestore
      DocumentReference<Map<String, dynamic>> userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Get the user's document snapshot
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await userDocRef.get();

      // Get the current bookmarks array
      List<dynamic>? bookmarksArray = userSnapshot.data()?['bookmarks'];

      if (bookmarksArray == null) {
        // If the bookmarks array doesn't exist, create a new one with the first bookmark
        bookmarksArray = [
          {'name': name, 'location': location},
        ];
      } else {
        // Check if the bookmark already exists in the array
        bool bookmarkExists = false;
        for (var bookmark in bookmarksArray) {
          if (bookmark['name'] == name && bookmark['location'] == location) {
            bookmarkExists = true;
            break;
          }
        }

        // If the bookmark exists, remove it; otherwise, add it to the array
        if (bookmarkExists) {
          setState(() {
            toggle = false;
          });
          bookmarksArray.removeWhere((bookmark) =>
              bookmark['name'] == name && bookmark['location'] == location);
        } else {
          setState(() {
            toggle = true;
          });
          bookmarksArray.add({'name': name, 'location': location});
        }
      }

      // Update the bookmarks array in Firestore
      await userDocRef.update({'bookmarks': bookmarksArray});

      print('Bookmarking/unbookmarking successful.');
    } catch (e) {
      print('Error bookmarking/unbookmarking: $e');
    }
  }

  // void bookmark() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     final userId = FirebaseAuth.instance.currentUser?.email;
  //     final site = widget.name;
  //     final CollectionReference collectionRef =
  //         FirebaseFirestore.instance.collection('users');

  //     final QuerySnapshot querySnapshot =
  //         await collectionRef.where('email', isEqualTo: userId).get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
  //       final DocumentReference documentRef = FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(documentSnapshot.reference.id);

  //       await FirebaseFirestore.instance.runTransaction((transaction) async {
  //         final DocumentSnapshot snapshot = await transaction.get(documentRef);
  //         final data = snapshot.data() as Map<String, dynamic>;

  //         if (snapshot.exists) {
  //           final List<dynamic> bookmarks = data['bookmarks'] ?? [];
  //           bool isBookmarkExists(String name, String location) {
  //             for (var bookmark in bookmarks) {
  //               if (bookmark.name) {
  //                 return true;
  //               }
  //             }
  //             return false;
  //           }

  //           if (isBookmarkExists(widget.name, widget.location)) {
  //             bookmarks
  //                 .removeWhere((bookmark) => bookmark['name'] == widget.name);
  //             setState(() {
  //               toggle = false;
  //             });
  //           } else {
  //             bookmarks.add({
  //               'name': widget.name,
  //               'location': widget.location,
  //               'image': widget.image
  //             });
  //             setState(() {
  //               toggle = true;
  //             });
  //           }

  //           transaction.update(documentRef, {'bookmarks': bookmarks});
  //         } else {
  //           transaction.set(documentRef, {
  //             'bookmarks': [
  //               {'name': widget.name, 'location': widget.location}
  //             ]
  //           });
  //         }
  //       });
  //     }
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Logout'),
  //           content: Text('Kindly sign into your accont'),
  //           actions: [
  //             TextButton(
  //               child: Text('Cancel'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text('Log in'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.pushNamed(context, "/login");

  //                 // signOutUser();
  //                 // Call the signOutUser function
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  List Images = [
    'forest',
    'lake',
    'mountain',
    'waterfalls',
    'zoo',
    'sanctuary'
  ];
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
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            // Handle the error and provide an alternative widget or fallback image
                            return Image.asset(
                              'assets/images/${Images[Random().nextInt(Images.length)]}.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1.5,
                      right: 1.5,
                      child: GestureDetector(
                        onTap: () {
                          bookmark(widget.name, widget.location);
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
                                            color: Colors.grey.shade100,
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
                                            color: Colors.grey.shade100,
                                            // YOU SEE THE PAGE WAY YOU OPEN WAY THE IMAGES COME, USE THE BRANDMAINLIGHSHADE RATHER INSTEAD OF THE GREY AS BACJGROUND
                                            // color: const Color.fromARGB(149, 255, 255, 255), Continue
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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

  String? _username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Future forYou() async {
    return FirebaseFirestore.instance.collection('sites').limit(3).get();
  }

  void signOutUser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      // Redirect the user to the login screen or any other screen as needed
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LoginPage(),
      //     ));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Container(
                height: 90,
                padding: EdgeInsets.only(top: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome",
                          style: GoogleFonts.outfit(
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900
                              // how ago change the drawer menu nu?
                              ),
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser != null
                              ? '${_username != null ? '@$_username' : ""}'
                              : '',
                          style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600
                              // how ago change the drawer menu nu?
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-2, -2),
                                  blurRadius: 5,
                                  spreadRadius: 12),
                              BoxShadow(
                                  color: Color.fromARGB(255, 191, 191, 191),
                                  offset: Offset(2, 2),
                                  blurRadius: 5)
                            ]),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.donut_small,
                            color: Colors.redAccent,
                          ),
                          onSelected: (value) {
                            if (value == 'logout') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Logout'),
                                    content: Text(
                                        'Are you sure you want to log out?'),
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
                                          setState(() {});
                                          // Call the signOutUser function
                                          Navigator.of(context).pop();
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
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  height: 85,
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
                      color: Colors.grey.shade600,
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
                            color: Colors.grey.shade900,
                          ),
                          label: Text('View more',
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: Colors.grey.shade600,
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
                                  image: document['images'][0],
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
    );
  }
}
