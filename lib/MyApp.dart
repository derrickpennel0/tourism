import 'package:first/screens/first_timers_page.dart';
import 'package:first/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2));

  late final Animation<Offset> offAnimation = Tween(
    begin: const Offset(-0.5, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   // ignore: unused_field
   int _selectedIndex = 0;

  final _frontText =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not ";
  void selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // print("${index}");
  }

  List<Widget> allPages = const [
    Home(),
    Center(child: Text("2")),
    Center(child: Text("3")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: const Alignment(-1, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Discover the Wonders of Ghana:\n Your Ultimate Travel Companion",
                    style: GoogleFonts.quicksand(
                        fontSize: 40, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _frontText,
                    style: GoogleFonts.abel(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 14,
              right: 13,
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                child: IconButton(
                  style: const ButtonStyle(
                      minimumSize:
                          MaterialStatePropertyAll(Size.fromHeight(80))),
                  onPressed: () => {},
                  icon: const Icon(Icons.supervised_user_circle_rounded),
                ),
              )),
          Positioned(
            bottom: 0,
            left: -135,
            child: SlideTransition(
              position: offAnimation,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: const Image(
                  image: AssetImage("assets/images/travel.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(71, 14, 211, 178),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ListTile(
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll(30),
                      minimumSize:
                          MaterialStateProperty.all(const Size(150, 50)),
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                    ),
                    onPressed: () {
                      // print("object");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FirstTimersPage(),
                        ),
                      );
                    },
                    child: const Text("Get Started"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
