import 'package:first/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Regions extends StatelessWidget {
  const Regions({super.key});
  static const List<String> ghanaRegions = [
    "Ashanti Region",
    "Brong Ahafo Region",
    "Central Region",
    "Eastern Region",
    "Greater Accra Region",
    "Northern Region",
    "Upper East Region",
    "Upper West Region",
    "Volta Region",
    "Western Region",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.all(12),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-2, -2),
                        blurRadius: 5,
                        spreadRadius: 12),
                    BoxShadow(
                        color: Color.fromARGB(255, 191, 191, 191),
                        offset: Offset(2, 2),
                        blurRadius: 5)
                  ]),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Regions",
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: ghanaRegions.length,
          itemBuilder: (context, index) => Container(
                height: 90,
                margin: EdgeInsets.only(bottom: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      // color: Colors.redAccent.shade100,
                      blurRadius: 12,
                      offset: Offset(4, 4))
                ]),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Explore(
                            siteName: ghanaRegions[index],
                          ),
                        ));
                  },
                  title: Text("${ghanaRegions[index]}"),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    // color: Colors.redAccent,
                  ),
                ),
              )),
    );
  }
}
