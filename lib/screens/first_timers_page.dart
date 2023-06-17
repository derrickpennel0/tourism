import 'package:first/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstTimersPage extends StatefulWidget {
  const FirstTimersPage({
    super.key,
  });

  @override
  State<FirstTimersPage> createState() => _FirstTimersPageState();
}

var pageNumber = 1;

List<Map<String, String>> _summary = [
  {
    "image": "assets/images/desert.jpg",
    "title": "Explore Ghana's Hidden Gems",
    "subtitle":
        "Discover the unexplored beauty of Ghana's stunning landscapes, cultural heritage, and vibrant cities with our tourism app.",
    "other": "234 unique hotels"
  },
  {
    "image": "assets/images/interior.jpeg",
    "title": "Plan Your Perfect Trip",
    "subtitle":
        "Plan your dream vacation in Ghana effortlessly. Our app provides comprehensive information on tourist sites, accommodations, restaurants, and activities to ensure a seamless travel experience.",
    "other": "234 unique hotels"
  },
  {
    "image": "assets/images/desert.jpg",
    "title": "Find Authentic Experiences",
    "subtitle":
        "Immerse yourself in the rich cultural tapestry of Ghana. Our app connects you with local guides and off-the-beaten-path destinations, offering authentic experiences and meaningful interactions.",
    "other": "234 unique hotels"
  },
  {
    "image": "assets/images/desert.jpg",
    "title": "Stay Informed and Inspired",
    "subtitle":
        "Stay up-to-date with the latest news, events, and travel tips through our app. Get inspired by captivating images, insider recommendations, and curated itineraries to make the most of your time in Ghana.",
    "other": "234 unique hotels"
  },
];

class _FirstTimersPageState extends State<FirstTimersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        PageView.builder(
          onPageChanged: (value) => {
            setState(() {
              pageNumber = value + 1;
            })
          },
          itemCount: _summary.length,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(_summary[index]["image"]!),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black87, Colors.transparent],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
              child: const SizedBox(),
            ),
          ),
        ),
       const Overlay(),
      ])),
    );
  }
}

class Overlay extends StatefulWidget {
  const Overlay({
    super.key,
  });

  @override
  State<Overlay> createState() => _OverlayState();
}

class _OverlayState extends State<Overlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    // iconSize = 24.0;
    super.dispose();
  }

  double iconSize = 24.0;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '0$pageNumber',
                style: GoogleFonts.quicksand(
                    fontSize: 70, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _summary[pageNumber - 1]["title"]!,
                style: GoogleFonts.quicksand(
                    fontSize: 30, fontWeight: FontWeight.w600),
              ),
              Text(
                _summary[pageNumber - 1]["subtitle"]!,
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(149, 255, 255, 255)),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.green.shade700,
                        thickness: 2.0, // Set the thickness to a non-zero value
                      ),
                    ),
                    Text(
                      '234 unique hotels',
                      style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy < -500) {
                    // Swipe-up gesture detected
                    setState(() {
                      iconSize =
                          48.0; // Update the icon size for the transition
                    });

                    // Perform the desired action, such as navigating to a new screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  }
                },
                child: Container(
                    // duration: const Duration(
                    //     milliseconds: 300), // Transition duration

                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _animation.value,
                              child:
                                  Icon(Icons.keyboard_arrow_up, size: iconSize),
                            );
                          },
                        ),
                        Text(
                          'Swipe up to skip',
                          style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(149, 255, 255, 255)),
                        ),
                      ],
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
