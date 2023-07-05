import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/components/mainCarousel.dart';
import 'package:first/components/map.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void bookmark() async {
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
        final data = snapshot.data()
            as Map<String, dynamic>; // Explicitly cast to Map<String, dynamic>

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
  }

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

  List tabs = ['Overview', 'Reviews', 'Close Restaurants and Hotels'];
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
                            color: Colors.white.withOpacity(0.8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      )),
                  title: Text(
                    "Details",
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(149, 255, 255, 255)),
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {
                          bookmark();
                          setState(() {
                            toggle = !toggle;
                          });
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
                    child: Container(
                        color: const Color.fromARGB(191, 23, 23, 23),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        // margin: EdgeInsets.only(bottom: 10),
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
                                    return Text('Failed to load image');
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                                            return Text('Failed to load image');
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
                                            return Text('Failed to load image');
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MainCarousel(images: images),
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
                          // height: double.infinity,
                          padding: EdgeInsets.only(
                              bottom: 1, top: 3, left: 12, right: 12),
                          color: const Color.fromARGB(191, 23, 23, 23),
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
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  243, 255, 255, 255)),
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
                                                  color: Color.fromARGB(
                                                      187, 255, 255, 255)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
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
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      187, 255, 255, 255)),
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
                                                  color: Color.fromARGB(
                                                      187, 255, 255, 255)),
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
                              SizedBox(
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
                                              fontWeight: FontWeight.w400,
                                              color: tab != index
                                                  ? Colors.grey.shade500
                                                  : Colors.redAccent),
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
                                      color: Colors
                                          .white, // Color of the vertical line
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
                                                      tileColor: Color.fromARGB(
                                                          192, 13, 13, 13),
                                                      title:
                                                          Text(doc['content']),
                                                      subtitle: Text(
                                                        doc['author'],
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontSize: 12),
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
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  187, 255, 255, 255),
                                            ),
                                          )
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 3,
                                              itemBuilder: (context, index) =>
                                                  const ForYouWidget(
                                                rating: "3.4",
                                                name: "ghana",
                                                location: "Volta",
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
                                                        enabledBorder: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    7),
                                                            borderSide: BorderSide(
                                                                color: const Color.fromARGB(
                                                                    191, 23, 23, 23))),
                                                        border: UnderlineInputBorder(
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
                                                        fillColor:
                                                            const Color.fromARGB(
                                                                191, 23, 23, 23),
                                                        filled: true),
                                                    style: TextStyle(),
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
