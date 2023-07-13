import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bookmarks extends StatelessWidget {
  const Bookmarks({super.key});

  Future bookmarks() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      final data = documentSnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('bookmarks')) {
        List<dynamic> bookmarks = data['bookmarks'];
        // Use the 'bookmarks' list as needed
        print(bookmarks);
        return bookmarks;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: bookmarks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.toString());
            final data = snapshot.data as List;
            return Scaffold(
              body: data.length > 0
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Details(name: data[index]),
                              ));
                        },
                        title: Text(data[index]),
                      ),
                    )
                  : Center(
                      child: Text(
                        "Oops :( You have no bookmarks",
                        style: GoogleFonts.quicksand(
                            color: Colors.redAccent,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
            );
          } else {
            return Center(
                child: Container(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
