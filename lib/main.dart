import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/components/autcomplete.dart';
import 'package:first/components/map.dart';
import 'package:first/screens/details.dart';
import 'package:first/screens/home.dart';
import 'package:first/screens/login.dart';
import 'package:flutter/material.dart';
import './MyApp.dart';
import 'package:provider/provider.dart';
import './screens/first_timers_updated.dart';
import './firebase_options.dart';
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeChanger(Themes.darkTheme),
//       child: const AppWrapper(),
//     ),
//   );
// }

// import './MyApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      initialRoute: '/login',
      routes: {
        // '/': (context) => Home(),
        '/login': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return Home();
          } else {
            return LoginPage();
          }
        },
        '/dashboard': (context) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return Home();
          } else {
            return LoginPage();
          }
        },
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(), // Set the dark theme
      themeMode: ThemeMode.dark, // Set the theme mode to dark
      home: const FirstTimerPage(),
    ),
  );
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      title: "Travel App",
      debugShowCheckedModeBanner: false,
      theme: themeChanger.currentTheme,
      home: const Home(),
    );
  }
}

class Themes {
  final primaryColor = Colors.redAccent;
  static final lightTheme = ThemeData(
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 35, 35, 35), // Set your desired icon color
        // size: 24, // Set your desired icon size
      ),
      focusColor: const Color.fromARGB(255, 254, 152, 152),
      primaryColor: Colors.redAccent,
      hintColor: const Color.fromARGB(255, 36, 36, 36),
      brightness: Brightness.light,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
            color: Colors.black), // Set your desired text color for dark
      ),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: Color.fromARGB(255, 36, 36, 36),
      ));

// Dark Theme
  static final darkTheme = ThemeData(
    iconTheme: const IconThemeData(
      color: Color.fromARGB(241, 242, 242, 242), // Set your desired icon color
      // size: 24, // Set your desired icon size
    ),
    primaryColor: const Color.fromARGB(255, 31, 31, 31),
    hintColor: const Color.fromARGB(197, 242, 242, 242),
    brightness: Brightness.dark,
    focusColor: const Color.fromARGB(255, 254, 152, 152),
    inputDecorationTheme: const InputDecorationTheme(
      prefixIconColor: Color.fromARGB(197, 242, 242, 242),
    ),
  );
}

class ThemeChanger with ChangeNotifier {
  ThemeData _currentTheme;

  ThemeChanger(this._currentTheme);

  ThemeData get currentTheme => _currentTheme;

  get isDarkTheme => null;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  toggleTheme() {}
}
