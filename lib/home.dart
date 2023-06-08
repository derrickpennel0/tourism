import 'package:first/components/Carousel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, actions: [
        IconButton(onPressed: () => {}, icon: const Icon(Icons.search_outlined))
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
            const ListTile(
              leading: Icon(Icons.home),
              title: const Text("Home"),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [1, 2, 3, 4, 5, 7]
                  .map(
                    (i) => Container(
                        margin: const EdgeInsets.only(right: 7),
                        height: 40,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            border: Border.all(
                                color: Color.fromARGB(255, 97, 97, 97),
                                width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(1, 2),
                                  blurRadius: 12)
                            ]),
                        child: const ListTile(
                          trailing: Icon(Icons.beach_access_outlined),
                          title: Text(
                            "Beach",
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        )),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            height: 40,
            child: TextFormField(
              decoration: const InputDecoration(
                  // labelText: 'Search location here ....',
                  // floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // contentPadding: EdgeInsets.only(left: 20),
                  hintText: "Search location here ....",
                  prefixIcon: Icon(Icons.location_city),
                  hintMaxLines: 30),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
