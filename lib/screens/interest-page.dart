// NEW COMPONENT HEREEEE
import 'package:first/components/InterestButtons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({Key? key}) : super(key: key);

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  // var iconState = false;
  var text;
  final MaterialAccentColor white = MaterialAccentColor(
    0xFFFFFFFF, // The hexadecimal value for white color
    <int, Color>{},
  );

  List<Map<String, dynamic>> myArray = [];

  // state of interest buttons
  // void iconStateFunction() {
  //   setState(() {
  //     iconState = !iconState;
  //   });
  // }

  void allData(String buttonText, bool buttonState) {
    final existingButtonIndex =
        myArray.indexWhere((item) => item['name of button'] == buttonText);

    if (buttonState) {
      // Add object to the array if button state is true
      if (existingButtonIndex == -1) {
        myArray.add({
          "name of button": buttonText,
          "state": buttonState,
        });
      }
    } else {
      // Remove object from the array if button state is false
      if (existingButtonIndex != -1) {
        myArray.removeAt(existingButtonIndex);
      }
    }

    print("Array: $myArray");
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: BoxConstraints.expand(
          height: double.infinity,
          width: double.infinity,
        ),
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 50.0),
        height: 10.0,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
                child: Text.rich(
                  TextSpan(
                    text: "Tell us about your",
                    style: GoogleFonts.quicksand(
                      fontSize: 20.0,
                      color: Colors.black45,
                    ),
                    children: [
                      WidgetSpan(
                        child: SizedBox(
                          width: 7,
                        ), // Adds a space of 10 logical pixels
                      ),
                      TextSpan(
                        text: "Interests",
                        style: GoogleFonts.acme(
                          color: Colors.redAccent,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        InterestButton(
                          text: "Garden",
                          allData: allData,
                        ),
                        SizedBox(width: 20),
                        InterestButton(
                          text: "Zoo",
                          allData: allData,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InterestButton(
                          text: "Castle",
                          backgroundColor: white,
                          textColor: Colors.redAccent,
                          allData: allData,
                        ),
                        SizedBox(width: 20),
                        InterestButton(
                          text: "Mountain",
                          backgroundColor: white,
                          textColor: Colors.redAccent,
                          allData: allData,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        InterestButton(
                          text: "Museum",
                          allData: allData,
                        ),
                        SizedBox(width: 20),
                        InterestButton(
                          text: "Lake",
                          allData: allData,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // SizedBox(width: 15),
                        InterestButton(
                          text: "National Park",
                          backgroundColor: white,
                          textColor: Colors.redAccent,
                          allData: allData,
                        ),
                        SizedBox(width: 15),
                        InterestButton(
                          text: "Forest",
                          backgroundColor: white,
                          textColor: Colors.redAccent,
                          allData: allData,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: _screenWidth * 0.3),
                        InterestButton(
                          text: "Sanctuary",
                          allData: allData,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 110.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(width: 20.0),
                    SizedBox(width: 20.0),
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black45),
                        elevation: MaterialStateProperty.all(5.0),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 2.0,
                          ),
                          Text(
                            "Next",
                            style: GoogleFonts.quicksand(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:first/components/InterestButtons.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class InterestPage extends StatefulWidget {
//   const InterestPage({Key? key}) : super(key: key);

//   @override
//   State<InterestPage> createState() => _InterestPageState();
// }

// class _InterestPageState extends State<InterestPage> {
//   var text;
//   final MaterialAccentColor white = MaterialAccentColor(
//     0xFFFFFFFF, // The hexadecimal value for white color
//     <int, Color>{},
//   );

//   List<Map<String, dynamic>> myArray = [];

//   // state of interest buttons
//   // void iconStateFunction() {
//   //   setState(() {
//   //     iconState = !iconState;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // void allData() {
//     //   final existingButtonIndex =
//     //       myArray.indexWhere((item) => item['name of button'] == text);

//     //   if (iconState) {
//     //     // Add object to the array if button state is true
//     //     if (existingButtonIndex == -1) {
//     //       myArray.add({
//     //         "name of button": text,
//     //         "state": iconState,
//     //       });
//     //     }
//     //   } else {
//     //     // Remove object from the array if button state is false
//     //     if (existingButtonIndex != -1) {
//     //       myArray.removeAt(existingButtonIndex);
//     //     }
//     //   }

//     //   print("Array: $myArray");
//     // }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         constraints: BoxConstraints.expand(
//             height: double.infinity, width: double.infinity),
//         alignment: Alignment.center,
//         padding: EdgeInsets.symmetric(horizontal: 50.0),
//         height: 10.0,
//         child: Center(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
//                 child: Text.rich(
//                   TextSpan(
//                     text: "Tell us about your",
//                     style: GoogleFonts.quicksand(
//                       fontSize: 20.0,
//                       color: Colors.black45,
//                     ),
//                     children: [
//                       WidgetSpan(
//                         child: SizedBox(
//                           width: 7,
//                         ), // Adds a space of 10 logical pixels
//                       ),
//                       TextSpan(
//                         text: "Interests",
//                         style: GoogleFonts.acme(
//                           color: Colors.redAccent,
//                           fontSize: 25.0,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 10),
//                         InterestButton(
//                           text: "Garden",
//                           myArray: myArray,
//                           allData: ()=>allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                         SizedBox(width: 20),
//                         InterestButton(
//                           text: "Zoo",
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         InterestButton(
//                           text: "Castle",
//                           backgroundColor: white,
//                           textColor: Colors.redAccent,
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                         SizedBox(width: 20),
//                         InterestButton(
//                           text: "Mountain",
//                           backgroundColor: white,
//                           textColor: Colors.redAccent,
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 10),
//                         InterestButton(
//                           text: "Museum",
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                         SizedBox(width: 20),
//                         InterestButton(
//                           text: "Lake",
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 60),
//                         InterestButton(
//                           text: "National Park",
//                           backgroundColor: white,
//                           textColor: Colors.redAccent,
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                         SizedBox(width: 20),
//                         InterestButton(
//                           text: "Forest",
//                           backgroundColor: white,
//                           textColor: Colors.redAccent,
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         SizedBox(width: 150),
//                         InterestButton(
//                           text: "Sanctuary",
//                           myArray: myArray,
//                           allData: allData,
//                           // iconStateFunction: iconStateFunction,
//                           // iconState: iconState,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 150.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(width: 20.0),
//                     OutlinedButton(
//                       onPressed: () {},
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all(Colors.lightBlueAccent),
//                         elevation: MaterialStateProperty.all(5.0),
//                         padding: MaterialStateProperty.all<EdgeInsets>(
//                           EdgeInsets.all(10),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.navigate_next,
//                             color: Colors.white,
//                           ),
//                           SizedBox(
//                             width: 2.0,
//                           ),
//                           Text(
//                             "Next",
//                             style: GoogleFonts.quicksand(
//                               fontSize: 20.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:first/components/InterestButtons.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // class InterestPage extends StatefulWidget {
// //   const InterestPage({super.key});

// //   @override
// //   State<InterestPage> createState() => _InterestPageState();
// // }

// // class _InterestPageState extends State<InterestPage> {
// //   var iconState = false;
// //   var text;
// //   final MaterialAccentColor white = MaterialAccentColor(
// //     0xFFFFFFFF, // The hexadecimal value for white color
// //     <int, Color>{},
// //   );

// //   List<Map<String, dynamic>> myArray = [];

// //   // state of interest buttons
// //   void iconStateFunction() {
// //     setState(() {
// //       iconState = !iconState;
// //     });
// //   }

// //   //  pushing object into array
// //   void allData(List<Map<String, dynamic>> myArray) {
// //     final existingButtonIndex =
// //         myArray.indexWhere((item) => item['name of button'] == text);

// //     if (iconState) {
// //       // Add object to the array if button state is true
// //       if (existingButtonIndex == -1) {
// //         myArray.add({
// //           "name of button": text,
// //           "state": iconState,
// //         });
// //       }
// //     } else {
// //       // Remove object from the array if button state is false
// //       if (existingButtonIndex != -1) {
// //         myArray.removeAt(existingButtonIndex);
// //       }
// //     }

// //     print("Array: $myArray");
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Container(
// //         constraints: BoxConstraints.expand(
// //             height: double.infinity, width: double.infinity),
// //         alignment: Alignment.center,
// //         padding: EdgeInsets.symmetric(horizontal: 50.0),
// //         height: 10.0,
// //         child: Center(
// //           child: Column(
// //             children: [
// //               Padding(
// //                   padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
// //                   child: Text.rich(TextSpan(
// //                       text: "Tell us about your",
// //                       style: GoogleFonts.quicksand(
// //                         fontSize: 20.0,
// //                         color: Colors.black45,
// //                       ),
// //                       children: [
// //                         WidgetSpan(
// //                           child: SizedBox(
// //                               width: 7), // Adds a space of 10 logical pixels
// //                         ),
// //                         TextSpan(
// //                             text: "Interests",
// //                             style: GoogleFonts.acme(
// //                               color: Colors.redAccent,
// //                               fontSize: 25.0,
// //                             ))
// //                       ]))),
// //               Padding(
// //                   padding: EdgeInsets.only(top: 20.0),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           SizedBox(width: 10),
// //                           InterestButton(
// //                             text: "Garden",
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                           SizedBox(width: 20),
// //                           InterestButton(
// //                             text: "Zoo",
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 30),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.end,
// //                         mainAxisSize: MainAxisSize.max,
// //                         children: [
// //                           // SizedBox(width: 5),
// //                           InterestButton(
// //                             text: "Castle",
// //                             backgroundColor: white,
// //                             textColor: Colors.redAccent,
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                           SizedBox(width: 20),

// //                           InterestButton(
// //                             text: "Mountain",
// //                             backgroundColor: white,
// //                             textColor: Colors.redAccent,
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                           // SizedBox(width: 5),
// //                         ],
// //                       ),
// //                       SizedBox(height: 30),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           SizedBox(width: 10),
// //                           InterestButton(
// //                             text: "Museum",
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                           SizedBox(width: 20),
// //                           InterestButton(
// //                             text: "Lake",
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 30),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           SizedBox(width: 60),
// //                           InterestButton(
// //                             text: "National Park",
// //                             backgroundColor: white,
// //                             textColor: Colors.redAccent,
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                           SizedBox(width: 20),
// //                           InterestButton(
// //                             text: "Forest",
// //                             backgroundColor: white,
// //                             textColor: Colors.redAccent,
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 30),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.start,
// //                         children: [
// //                           SizedBox(width: 150),
// //                           InterestButton(
// //                             text: "Sanctuary",
// //                             myArray: myArray,
// //                             allData: () => allData(myArray),
// //                             iconStateFunction: () => iconStateFunction,
// //                             iconState: iconState,
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   )),
// //               Padding(
// //                   padding: EdgeInsets.only(top: 150.0),
// //                   child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         SizedBox(width: 20.0),
// //                         OutlinedButton(
// //                             onPressed: () {},
// //                             style: ButtonStyle(
// //                                 backgroundColor: MaterialStateProperty.all(
// //                                     Colors.lightBlueAccent),
// //                                 elevation: MaterialStateProperty.all(5.0),
// //                                 padding: MaterialStateProperty.all<EdgeInsets>(
// //                                   EdgeInsets.all(10),
// //                                 )),
// //                             child: Row(
// //                               children: [
// //                                 Icon(
// //                                   Icons.navigate_next,
// //                                   color: Colors.white,
// //                                 ),
// //                                 SizedBox(
// //                                   width: 2.0,
// //                                 ),
// //                                 Text("Next",
// //                                     style: GoogleFonts.quicksand(
// //                                         fontSize: 20.0, color: Colors.white))
// //                               ],
// //                             ))
// //                       ]))
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // ignore: must_be_immutable
// // // class InterestPage extends StatelessWidget {
// // //   InterestPage({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return
