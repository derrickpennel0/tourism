import 'package:first/components/Carousel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'components/myDrawerListTile.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.transparent, elevation: 0, actions: [
        IconTheme(
            data: IconThemeData(color: Theme.of(context).iconTheme.color),
            child: IconButton(
                onPressed: () => {}, icon: Icon(Icons.verified_user_rounded)))
      ]),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/desert.jpg"),
                ),
              ),
            ),
            MyDrawerListTile(
              title: "Home",
              leadingIcon: Icons.home,
              onTap: () {},
            ),
            MyDrawerListTile(
              title: "Sign In",
              leadingIcon: Icons.exit_to_app_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            MyDrawerListTile(title: "Tour", onTap: () {}),
            MyDrawerListTile(title: "Go", onTap: () {}),
            MyDrawerListTile(title: "Next", onTap: () {}),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.only(top: 20, bottom: 5),
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         fit: BoxFit.cover,
            //         image: AssetImage("assets/images/background.jpg"))),
            child: TextFormField(
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(179, 188, 22, 22),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                focusedBorder: OutlineInputBorder(
                    // borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                // labelText: 'Search location here ....',
                // floatingLabelBehavior: FloatingLabelBehavior.auto,
                // contentPadding: EdgeInsets.only(left: 20),
                hintText: "Search location here ....",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Categories(),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Search',
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(149, 255, 255, 255)),
              ),
              Text(
                'Clear History',
                style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(214, 241, 176, 176)),
              ),
            ],
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  height: 220,
                  width: 160,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/background.jpg")),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: const Text(
                    "Ghana",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 220,
                  width: 160,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/desert.jpg")),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: const Text(
                    "Ghana",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 220,
                  width: 160,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/desert.jpg")),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: const Text(
                    "Ghana",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Carousel(),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black54.withOpacity(0.7),
                    Colors.transparent
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        alignment: const Alignment(-1, 0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Traveler's Choice Best \n of the Best Hotels",
                              style: GoogleFonts.outfit(
                                  fontSize: 30, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "Traveler's Choice Best of the Best Hotels",
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(100, 45)),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.white)),
                              child: const Text(
                                "See List",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          )
          // const Image(image: AssetImage('assets/images/test.png'))
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          "Most Popular",
          "Recommended",
          "Trending",
          "Historic",
          "Nature",
          "Traditional"
        ]
            .map(
              (i) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 40,
                  width: 150,
                  alignment: Alignment.center,
                  child: ListTile(
                    // trailing: Icon(Icons.beach_access_outlined),
                    title: Text(
                      i.toString(),
                      style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(149, 255, 255, 255)),
                    ),
                  )),
            )
            .toList(),
      ),
    );
  }
}
