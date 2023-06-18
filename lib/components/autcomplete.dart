import 'package:first/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../main.dart';

class MySearchScreen extends StatefulWidget {
  @override
  _MySearchScreenState createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // List<String> _suggestions = [];

  Future<List<String>> fetchSuggestions(String query) async {
    final response =
        await http.get(Uri.parse('http://localhost:4000/search?query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> suggestions =
          List<String>.from(data.map((item) => item['name'].toString()));
      return suggestions;
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }

  List<String> items = ['Mountains', 'Lakes', 'Item 3'];
  List<bool> checkedItems = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return SizedBox(
      height: double.infinity,
      // width: double.infinity,
      child: Column(
        children: [
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(191, 23, 23, 23),
                hintStyle: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  // color: const Color.fromARGB(149, 255, 255, 255),
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Filter By'),
                            content: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
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
                    icon: const Icon(Icons.filter_5_outlined)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    )),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                  // borderSide: BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                hintText: "Search location here ....",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            suggestionsCallback: (pattern) async {
              if (pattern.isEmpty) {
                return [];
              }
              List<String> suggestions = await fetchSuggestions(pattern);
              return suggestions;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              _searchController.text = suggestion;
              // Do something when a suggestion is
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(name: suggestion),
                  ));
              print('Selected suggestion: $suggestion');
            },
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Filtered by : ${checkedItems.contains(true) ? '' : 'None'}",
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    // color: const Color.fromARGB(149, 255, 255, 255),
                  ),
                ),
                SizedBox(
                  width: 200, // Provide a fixed width here
                  height: 32.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (checkedItems[index] == true) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                191, 23, 23, 23), // Dark background color
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
