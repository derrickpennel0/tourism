import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class MainCarousel extends StatefulWidget {
  final List<dynamic> images;
  const MainCarousel({required this.images});
  @override
  _MainCarouselState createState() => _MainCarouselState();
}

class _MainCarouselState extends State<MainCarousel> {
  int _currentIndex = 0;

  // List<String> images = [
  //   'desert.jpg',
  //   'african.jpg',
  //   'test.png',
  // ];

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
      ),
      body: Center(
        child: CarouselSlider(
          items: widget.images.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                  ),
                  child: Image.network(
                    '$image',
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 400.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 6),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
