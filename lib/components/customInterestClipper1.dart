import 'package:flutter/cupertino.dart';

class CustomInterestClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width / 4, 3 * (size.height / 2), 3 * (size.width / 4),
        size.height / 2, size.width, size.height * 0.9);
    path.lineTo(size.width, 0);
    return path;
    // throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
