import 'package:flutter/material.dart';
import './screens/first_timers_updated.dart';
// import './MyApp.dart';

void main() {
  runApp(
    MaterialApp(
        title: "Travel App",
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        // home: const MyApp(),
        home: const FirstTimerPage()),
  );
}
