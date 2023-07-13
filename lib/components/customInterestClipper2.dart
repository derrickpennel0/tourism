import 'package:flutter/cupertino.dart';

class customInterestClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var round = 50.0;
    Path path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(0, size.height);
    // path.lineTo(size.height, size.height);
    // path.lineTo(size.width, 0);

    path.lineTo(0, size.height - round);
    path.quadraticBezierTo(0, size.height, round, size.height);
    path.lineTo(size.width - round, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - round);
    path.lineTo(size.width, round * 2);

    return path;
    // throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
