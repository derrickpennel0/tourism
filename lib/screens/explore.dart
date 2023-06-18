import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            "Explore",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
      body: GridView.builder(
        itemCount: imageUrls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as needed
          mainAxisSpacing: 1.0, // Adjust the spacing between images vertically
          crossAxisSpacing:
              1.0, // Adjust the spacing between images horizontally
        ),
        itemBuilder: (context, index) {
          final random = Random();
          final width = 250; // Random width between 150 and 300
          final height =
              random.nextInt(150) + 150; // Random height between 150 and 300
          print('$width , $height');
          return SizedBox(
            width: width.toDouble(),
            height: height.toDouble(),
            child: Image.asset(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
