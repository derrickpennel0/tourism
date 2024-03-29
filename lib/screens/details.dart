import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/mainCarousel.dart';
import 'package:first/components/map.dart';
import 'package:first/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  Details({super.key, required this.name});
  final String name;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int tab = 0;
  var result;
  final TextEditingController reviewController = TextEditingController();

  Future fetchData() async {
    // Make your API request here
    final response = await http
        .get(Uri.parse('http://localhost:4000/get-site/${widget.name}'));
    // Process the response
    if (response.statusCode == 200) {
      // API request succeeded
      final data = json.decode(response.body);

      return data[0];
    } else {
      // API request failed
      print('Failed to fetch data');
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

//this parrticualr page dey look raw too much adey come
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

  Future<dynamic> searchDocuments() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('sites')
        .where('name', isEqualTo: widget.name)
        .get();

    final result = querySnapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();

    return result;
  }

  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  void checkBookmarkStatus() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final userId = FirebaseAuth.instance.currentUser?.email;
      final site = {'name': widget.name};
      final CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('users');

      final QuerySnapshot querySnapshot =
          await collectionRef.where('email', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('bookmarks')) {
          List<dynamic> sites = data['bookmarks'];
          bool isBookmarkPresent(String name) {
            return sites.any((bookmark) => bookmark['name'] == name);
          }

          if (isBookmarkPresent(widget.name)) {
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

  List tabs = ['Overview', 'Reviews', 'Nearby Restaurants and Hotels'];
  List Images = [
    'forest',
    'lake',
    'mountain',
    'waterfalls',
    'zoo',
    'sanctuary'
  ];
  late GoogleMapController googleMapController;
  bool toggle = false;
  bool isInitial = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: searchDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && isInitial) {
          return Center(
            child: Container(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("error");
        } else {
          isInitial = false;
          final data = snapshot.data[0]! as Map<String, dynamic>;
          final locationString = data['locationString'].toString();
          final rating = data['rating'].toString();
          final numReviews = data['numReviews'].toString();
          final longitude = double.parse(data['longitude']);
          final latitude = double.parse(data['latitude']);
          final description = data['description'];
          final images = data['images'];
          // checkBookmarkStatus(locationString);
          return SafeArea(
            child: Scaffold(
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
                    ),
                  ),
                  title: Text(
                    "Details",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          bookmark(widget.name, locationString);
                        },
                        child: Container(
                          height: 30,
                          width: 32.5,
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
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
                  ]),
              body: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                          // color: Colors.grey.shade300,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          // margin: EdgeInsets.only(bottom: 10) HOT RELOAD DONT RESTART ELSE EGO GO THE INTEREST PAGE OH OKAY.. NOW THE OTHER GREY TOO YOU FOR TOUCH AM,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(
                            children: [
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                // margin: EdgeInsets.symmetric(vertical: 7),
                                decoration: const BoxDecoration(
                                    // color: Colors.white,
                                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    images[0],
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
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
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: 70,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.symmetric(vertical: 7),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Image.network(
                                            images[1],
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              // Handle the error and provide an alternative widget or fallback image
                                              return Image.asset(
                                                'assets/images/${Images[Random().nextInt(Images.length)]}.jpg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 70,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 7),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: Image.network(
                                            images[0],
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              // Handle the error and provide an alternative widget or fallback image
                                              return Image.asset(
                                                'assets/images/${Images[Random().nextInt(Images.length)]}.jpg',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MainCarousel(
                                                        images: images),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                // margin: EdgeInsets.symmetric(vertical: 7),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: Image.network(
                                                  images[2] ??
                                                      "https://media-cdn.tripadvisor.com/media/photo-f/13/ed/95/e5/kalakpa-nature-reserve.jpg",
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    // Handle the error and provide an alternative widget or fallback image
                                                    return Text('');
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    // margin: EdgeInsets.symmetric(vertical: 7),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          134, 0, 0, 0),
                                                      border: Border.all(
                                                          color: Colors.white),
                                                    ),
                                                    child: const Center(
                                                        child: Text("+5"))),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.50,
                    // decoration: BoxDecoration(),
                    // decoration:
                    //     BoxDecoration(color: Color.fromARGB(255, 41, 41, 41)),
                    child: Column(
                      children: [
                        Container(
                          // width: double.infinity,
                          // height: double.infinity, we for use diff color .. ,,yeah ..but what do you hvae in mind? unlessyeah
                          padding: EdgeInsets.only(
                              bottom: 1, top: 3, left: 12, right: 12),
                          // color: Colors.grey.shade300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              // how it dey look for your side  oh ebi cool then vim we mive but the reviews text as in the unactive once if we use the redAccent it go be off? yeah yeah
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    offset: Offset(0, 9))
                              ]),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
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
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.redAccent,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              '${locationString}',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
//ano dey see what you dey talk tho but make i fix this thing
                                  Container(
                                    // width: MediaQuery.of(context).size.width *
                                    //     0.30,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${rating}',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.redAccent),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Text(
                                            //   '${rating}',
                                            //   style: GoogleFonts.quicksand(
                                            //       fontSize: 14,
                                            //       fontWeight:
                                            //           FontWeight.w500,
                                            //       color: Color.fromARGB(
                                            //           187, 255, 255, 255)),
                                            // ),
                                            Text(
                                              "($numReviews reviews)",
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 20,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tabs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tab = index;
                                          });
                                        },
                                        child: Text(
                                          tabs[index],
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: tab != index
                                                  ? Colors.grey.shade500
                                                  : Colors.blue),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      width: 1, // Width of the vertical line
                                      color: Colors.grey
                                          .shade500, // Color of the vertical line
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: ListView(
                              children: [
                                tab == 1
                                    ? StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('reviews')
                                            .where('postId',
                                                isEqualTo: widget.name)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }

                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }

                                          if (!snapshot.hasData ||
                                              snapshot.data!.docs.isEmpty) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Expanded(
                                                //   child: Container(
                                                //     height: 30,
                                                //   ),
                                                // ),
                                                Center(
                                                  child: Text(
                                                    'No reviews available',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            color: Colors
                                                                .grey.shade600),
                                                  ),
                                                ),
                                                // Expanded(
                                                //   child: Container(
                                                //     height: 30,
                                                //   ),
                                                // ),
                                              ],
                                            );
                                          }

                                          return Container(
                                            height: 400,
                                            width: 300,
                                            child: ListView(
                                              children: snapshot.data!.docs
                                                  .map((doc) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: ListTile(
                                                      tileColor:
                                                          Colors.grey.shade300,
                                                      title:
                                                          Text(doc['content']),
                                                      subtitle: Text(
                                                        doc['author'],
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .redAccent),
                                                      ),
                                                      trailing: FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.email ==
                                                              doc['author']
                                                          ? IconButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'reviews')
                                                                      .doc(doc
                                                                          .id)
                                                                      .delete();
                                                                  print(
                                                                      'Comment deleted successfully');
                                                                } catch (error) {
                                                                  print(
                                                                      'Error deleting comment: $error');
                                                                }
                                                              },
                                                              icon: Icon(
                                                                Icons.cancel,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : null),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        },
                                      )
                                    : tab == 0
                                        ? Text(
                                            description,
                                            style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade600),
                                          )
                                        : Expanded(
                                            child: Container(
                                              height: 220,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: GoogleMap(
                                                  zoomControlsEnabled: false,
                                                  markers: {
                                                    Marker(
                                                      markerId:
                                                          MarkerId("demo"),
                                                      infoWindow: InfoWindow(
                                                          title:
                                                              "${widget.name}"),
                                                      position: LatLng(
                                                          latitude, longitude),
                                                      // draggable: true,
                                                    )
                                                  },
                                                  mapType: MapType.normal,
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    googleMapController =
                                                        controller;
                                                  },
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                          target: LatLng(
                                                              latitude,
                                                              longitude),
                                                          zoom: 13),
                                                ),
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: tab == 0
                                  ? BottomAppBar(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.redAccent),
                                              minimumSize:
                                                  MaterialStatePropertyAll(Size(
                                                      double.infinity, 40))),
                                          child: Text(
                                            "View Map",
                                            style: GoogleFonts.quicksand(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    246, 255, 255, 255)),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => GMaps(
                                                    coordinates: {
                                                      "lat": latitude,
                                                      "lng": longitude
                                                    }),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : tab == 1
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 3),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 45,
                                                  // width: 100,
                                                  child: TextField(
                                                    controller:
                                                        reviewController,
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300)),
                                                        border:
                                                            UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText:
                                                            "Leave a review ...",
                                                        hintStyle:
                                                            GoogleFonts.quicksand(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize: 14),
                                                        fillColor: Colors
                                                            .grey.shade300,
                                                        filled: true),
                                                    style: TextStyle(),
                                                    //adey prefer filled with white color and the border can be a grey and text can also be
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.redAccent),
                                                      minimumSize:
                                                          MaterialStatePropertyAll(
                                                              Size(60, 45))),
                                                  onPressed: () async {
                                                    try {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("reviews")
                                                          .add({
                                                        'content':
                                                            reviewController
                                                                .text,
                                                        'author': FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.email
                                                            .toString(),
                                                        'timestamp':
                                                            Timestamp.now(),
                                                        'postId': widget.name,
                                                      });
                                                      reviewController.clear();
                                                    } catch (e) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                  child: Icon(Icons.send))
                                            ],
                                          ),
                                        )
                                      : null,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
