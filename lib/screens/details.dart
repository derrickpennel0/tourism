import 'dart:convert';

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
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData(); // Make the API request on page load
  // }

  Future fetchData() async {
    // Make your API request here
    final response = await http
        .get(Uri.parse('http://localhost:4000/get-site/${widget.name}'));
    // Process the response
    if (response.statusCode == 200) {
      // API request succeeded
      final data = json.decode(response.body);
      // setState(() {
      //   result = data[0];
      // });
      // print(data);

      return data[0];
    } else {
      // API request failed
      print('Failed to fetch data');
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: searchDocuments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data[0]! as Map<String, dynamic>;
          final locationString = data['locationString'].toString();
          final rating = data['rating'].toString();
          final numReviews = data['numReviews'].toString();
          final longitude = double.parse(data['longitude']);
          final latitude = double.parse(data['latitude']);
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
                      Container(
                          width: 57,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
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
                                Icons.bookmark_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                          )),
                    ]),
                body: Column(
                  children: [
                    Container(
                        color: const Color.fromARGB(191, 23, 23, 23),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                                child: Image.asset(
                                  "assets/images/desert.jpg",
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
                                  padding: EdgeInsets.all(10),
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
                                        child: Image.asset(
                                          "assets/images/interior.jpeg",
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
                                        child: Image.asset(
                                          "assets/images/desert.jpg",
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
                                                  MainCarousel(),
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
                                                "https://media-cdn.tripadvisor.com/media/photo-f/13/ed/95/e5/kalakpa-nature-reserve.jpg",
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  // Handle the error and provide an alternative widget or fallback image
                                                  return Text(
                                                      'Failed to load image');
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
                                  height: 7,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            tab = 0;
                                          });
                                        },
                                        child: Text(
                                          "Overview",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: tab != 0
                                                  ? Color.fromARGB(
                                                      246, 255, 255, 255)
                                                  : Colors.redAccent),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 10,
                                      ),
                                      Container(
                                        height: 8,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            // color: Colors.white,
                                            border: Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.white))),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            tab = 1;
                                          });
                                        },
                                        child: Text(
                                          "Reviews",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: tab != 1
                                                  ? Color.fromARGB(
                                                      246, 255, 255, 255)
                                                  : Colors.redAccent),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 10,
                                      ),
                                      Container(
                                        height: 8,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            // color: Colors.white,
                                            border: Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.white))),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            tab = 2;
                                          });
                                        },
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          "Close Restaurants/Hostels",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: tab != 2
                                                  ? Color.fromARGB(
                                                      246, 255, 255, 255)
                                                  : Colors.redAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                            child: SizedBox(
                              height:
                                  260, // Set a specific height for the ListView
                              child: ListView(
                                children: [
                                  tab == 1
                                      ? Text(
                                          "Reviewssss",
                                          style: GoogleFonts.quicksand(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                187, 255, 255, 255),
                                          ),
                                        )
                                      : tab == 0
                                          ? Text(
                                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla varius placerat enim vitae commodo. Mauris id massa lacus. Nunc fermentum est ut erat feugiat tincidunt. Maecenas consectetur nulla quis metus ullamcorper, eget dignissim nulla cursus. Mauris sit amet lacinia mi. Morbi lacinia justo id cursus tristique. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin semper tortor ac turpis euismod tempus. Mauris semper, risus at auctor posuere, nibh enim gravida augue, at lacinia \n lacinia justo id cursus tristique. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin semper tortor ac turpis euismod tempus. Mauris semper, risus at auctor posuere, nibh enim gravida augue, at lacinia",
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
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 3,
                                                itemBuilder: (context, index) =>
                                                    const ForYouWidget(),
                                              ),
                                            ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.redAccent),
                          minimumSize: MaterialStatePropertyAll(
                              Size(double.infinity, 40))),
                      child: Text(
                        "View Map",
                        style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(246, 255, 255, 255)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GMaps(coordinates: {
                              "lat": latitude,
                              "lng": longitude
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                )),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
