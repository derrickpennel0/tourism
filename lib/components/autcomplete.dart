import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../main.dart';
import '../styles/app_style.dart';

class Suggestion {
  final String image;
  final String name;

  Suggestion({required this.name, required this.image});
}

class MySearchScreen extends StatefulWidget {
  @override
  _MySearchScreenState createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> searchDocuments(String query) async {
    final collectionRef = FirebaseFirestore.instance.collection('sites');

    try {
      final snapshot = await collectionRef.get();
      final documents = snapshot.docs.map((doc) => doc.data());

      // Check if any field name matches the query
      final matchingDocuments = documents.where((doc) =>
          doc['name']?.toLowerCase().contains(query.toLowerCase()) ?? false);

      return matchingDocuments.toList();
    } catch (error) {
      throw Exception('Error searching documents: $error');
    }
  }

  // Map<String, dynamic> myData = {
  //   'Garden': {'text': 'Gardens', 'image': 'assets/images/garden.jpg'},
  //   'Lake': {'text': 'Lakes', 'image': 'assets/images/lake.jpg'},
  //   'Forest': {'text': 'Forests', 'image': 'assets/images/forest.jpg'},
  //   'Waterfall': {
  //     'text': 'Waterfalls',
  //     'image': 'assets/images/waterfalls.jpg'
  //   },
  //   'Mountain': {'text': 'Mountains', 'image': 'assets/images/mountain.jpg'},
  //   'Sanctuary': {
  //     'text': 'Sanctuaries',
  //     'image': 'assets/images/sanctuary.jpg'
  //   },
  //   'Castle': {'text': 'Castles', 'image': 'assets/images/castle.jpg'},
  //   'National Park': {
  //     'text': 'National Parks',
  //     'image': 'assets/images/national-park.jpg'
  //   },
  //   'Zoo': {'text': 'Zoos', 'image': 'assets/images/zoo.jpg'},
  //   'Museum': {'text': 'Museums', 'image': 'assets/images/museum.jpg'},
  // };
  List<String> items = [
    'Garden',
    'Lake',
    'Forest',
    'Waterfall',
    'Mountain',
    'Sanctuary',
    'Castle',
    'National Park',
    'Zoo',
    'Museum'
  ];
  List<bool> checkedItems = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    // final themeChanger = Provider.of<ThemeChanger>(context);
    return SizedBox(
      height: double.infinity,
      // width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 45,
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  // focusColor: const Color.fromARGB(191, 23, 23, 23),
                  // iconColor: const Color.fromARGB(191, 23, 23, 23),
                  fillColor: Colors.grey.shade300,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  hintStyle: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    // color: const Color.fromARGB(149, 255, 255, 255),
                  ),
                  suffixIcon: IconButton(
                      color: Colors.grey.shade600,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Filter By'),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SizedBox(
                                    height: 200,
                                    width: 250,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: items.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(items[index]),
                                          trailing: Checkbox(
                                            value: checkedItems[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                checkedItems[index] = value!;
                                              });

                                              // Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // Update the UI with selected items
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.filter_list_sharp)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      )),
                  hintText: "Search location here ....",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) {
                  return [];
                }
                List<Map<String, dynamic>> matchingDocuments =
                    await searchDocuments(pattern);
                List<Suggestion> suggestions = matchingDocuments.map((doc) {
                  return Suggestion(
                    name: doc['name'].toString(),
                    image: doc['images'][0].toString(),
                  );
                }).toList();
                return suggestions;
              },
              itemBuilder: (context, suggestion) {
                // print(suggestion.name);
                return ListTile(
                  // leading: CircleAvatar(
                  //   child: ClipOval(
                  //     child: Image.network(
                  //       suggestion.image.toString(),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  title: Text(suggestion.name.toString()),
                );
              },
              onSuggestionSelected: (suggestion) {
                _searchController.text = suggestion.name;
                // Do something when a suggestion is
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(name: suggestion.name),
                    ));
                print('Selected suggestion: ${suggestion.name}');
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                checkedItems.contains(true)
                    ? Text(
                        "Filtered by  ${checkedItems.contains(true) ? '' : 'None'}",
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      )
                    : SizedBox(),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (checkedItems[index] == true) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                189, 107, 107, 107), // Dark background color
                            borderRadius:
                                BorderRadius.circular(7), // Rounded edges
                            border: Border.all(
                                color: Colors.white60), // Red accent border
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 1),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            items[index],
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                        );
                      }
                      // print(checkedItems);
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
