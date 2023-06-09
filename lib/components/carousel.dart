import 'dart:async';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> images = [
    "assets/images/interior.jpeg",
    "assets/images/desert.jpg",
    "assets/images/background.jpg",
    "assets/images/travel.png",
  ];
  int currentIndex = 0;
  late Timer timer;
  final int autoScrollDelay = 3; // Time delay in seconds
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: autoScrollDelay), (_) {
      if (currentIndex < images.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      scrollToIndex(currentIndex);
    });
  }

  void scrollToIndex(int index) {
    if (index < images.length) {
      setState(() {
        currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.map((image) {
        int index = images.indexOf(image);
        return Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? Colors.white : Colors.grey,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        buildIndicator(),
      ],
    );
  }
}
