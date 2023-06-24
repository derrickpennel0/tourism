import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class FirstTimerPage extends StatefulWidget {
  const FirstTimerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FirstTimerPageState createState() => _FirstTimerPageState();
}

class _FirstTimerPageState extends State<FirstTimerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward().whenComplete(() {
      // Navigate to another page or component here
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      ).then((value) {
        // Code to execute after navigating back from Home
        // For example, you can print a message
        print('Returned from Home');
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // gradient: RadialGradient(
            //   colors: [
            //     // Colors.teal.withOpacity(0.8),
            //     Colors.white.withOpacity(0.8),

            //     Colors.white,
            //     Colors.white,
            //   ],
            //   stops: [0.0, 0.7, 1.0],
            //   center: Alignment.bottomCenter,
            //   radius: 1.5,
            // ),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * 3.14159, // Rotate 360 degrees
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white12,
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/images/new-app-logo.png'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Travel App',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
