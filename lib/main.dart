import 'package:flutter/material.dart';
import './MyApp.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyApp(),
    ),
  );
}
