import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'details.dart';

class Explore extends StatelessWidget {
  final List<String> imageUrls = [
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    'assets/images/desert.jpg',
    // Add more image URLs as needed
  ];
  Future forYou() async {
    return FirebaseFirestore.instance.collection('sites').limit(4).get();
  }

  Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            padding: EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
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
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            )), // what you talk nu you go fit do am??
        // show me where cotntainer dey
        title: Text(
          "Explore",
          style: GoogleFonts.quicksand(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: forYou(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List documents = snapshot.data.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    print('${document['name']} , ghana');

                    return ForYouWidget(
                      name: document['name'],
                      rating: document['rating'],
                      location: document['locationString'],
                      image: document['images'][0],
                    );
                  }),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
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
  //   final userId = FirebaseAuth.instance.currentUser?.email;
  //   final site = widget.name;
  //   final CollectionReference collectionRef =
  //       FirebaseFirestore.instance.collection('users');

  //   final QuerySnapshot querySnapshot =
  //       await collectionRef.where('email', isEqualTo: userId).get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
  //     final DocumentReference documentRef = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(documentSnapshot.reference.id);

  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       final DocumentSnapshot snapshot = await transaction.get(documentRef);
  //       final data = snapshot.data()
  //           as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>

  //       if (snapshot.exists) {
  //         final List<dynamic> bookmarks = data['bookmarks'] ?? [];

  //         if (bookmarks.contains(site)) {
  //           bookmarks.remove(site);
  //           setState(() {
  //             toggle = false;
  //           });
  //         } else {
  //           bookmarks.add(site);
  //           setState(() {
  //             toggle = true;
  //           });
  //         }

  //         transaction.update(documentRef, {'bookmarks': bookmarks});
  //       } else {
  //         transaction.set(documentRef, {
  //           'bookmarks': [site]
  //         });
  //       }
  //     });
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
        margin: const EdgeInsets.only(bottom: 8),
        height: 210,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          // color: Styles.tileColor,
          // boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 2)],
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        child: Column(
          children: [
            Builder(builder: (context) {
              //maek the image, taje some specific height.. hold on adey watch something
              // okay so adey think say.. the image conatINERGO Tke like 70&
              //MAKE I SEND VN
              return Expanded(
                child: SizedBox(
                    // height: 200,
                    // width: 160,
                    child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
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
                          // setState(() {
                          //   toggle = !toggle;
                          // });
                        },
                        child: Container(
                          height: 35,
                          width: 35,
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
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.bookmark,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 1,
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
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
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white
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
                                                    fontSize: 15,
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
                                              color: Colors.grey[100]
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
              );
            }),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
