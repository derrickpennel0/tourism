import 'package:flutter/material.dart';
import './MyApp.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyApp(),
    ),
  );
}
