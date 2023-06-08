import 'package:flutter/material.dart';

class SlideAnimationPage extends StatefulWidget {
  @override
  _SlideAnimationPageState createState() => _SlideAnimationPageState();
}

class _SlideAnimationPageState extends State<SlideAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller and initialize it
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    // Define the slide animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation on page load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slide Animation Page'),
      ),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            // Add your container content here
          ),
        ),
      ),
    );
  }
}
