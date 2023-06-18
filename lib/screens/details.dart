import 'package:first/components/mainCarousel.dart';
import 'package:first/components/map.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class Details extends StatefulWidget {
  Details({super.key, required this.name});
  final String name;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
                                Object exception, StackTrace? stackTrace) {
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
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
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
                                  margin: EdgeInsets.symmetric(vertical: 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white)),
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
                                        builder: (context) => MainCarousel(),
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
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Image.network(
                                          "https://media-cdn.tripadvisor.com/media/photo-f/13/ed/95/e5/kalakpa-nature-reserve.jpg",
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            // Handle the error and provide an alternative widget or fallback image
                                            return Text('Failed to load image');
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
                                              color:
                                                  Color.fromARGB(134, 0, 0, 0),
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
              Expanded(
                child: Container(
                  // decoration:
                  //     BoxDecoration(color: Color.fromARGB(255, 41, 41, 41)),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                        color: const Color.fromARGB(191, 23, 23, 23),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 25,
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
                                          widget.name,
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
                                Column(
                                  children: [
                                    Row(
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
                                          "Ratings",
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
                                        Text(
                                          "4.8",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  187, 255, 255, 255)),
                                        ),
                                        Text(
                                          "(687 reviews)",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  187, 255, 255, 255)),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
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
                                            ? Color.fromARGB(246, 255, 255, 255)
                                            : Colors.redAccent),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                  width: 10,
                                ),
                                Container(
                                  height: 12,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      border: Border(
                                          left: BorderSide(
                                              width: 1, color: Colors.white))),
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
                                            ? Color.fromARGB(246, 255, 255, 255)
                                            : Colors.redAccent),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                  width: 10,
                                ),
                                Container(
                                  height: 12,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      border: Border(
                                          left: BorderSide(
                                              width: 1, color: Colors.white))),
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
                                            ? Color.fromARGB(246, 255, 255, 255)
                                            : Colors.redAccent),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            height:
                                200, // Set a specific height for the ListView
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
                                                0.3,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 3,
                                              itemBuilder: (context, index) =>
                                                  const ForYouWidget(),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                    minimumSize:
                        MaterialStatePropertyAll(Size(double.infinity, 40))),
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
                      builder: (context) => const GMaps(),
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}
