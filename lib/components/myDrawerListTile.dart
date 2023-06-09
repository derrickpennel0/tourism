import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyDrawerListTile extends StatelessWidget {
  const MyDrawerListTile(
      {super.key,
      this.leadingIcon = Icons.home,
      required this.onTap,
      required this.title});

  final IconData leadingIcon;
  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      onTap: onTap,
      hoverColor: Colors.cyan,
      splashColor: Colors.red,
    );
  }
}
