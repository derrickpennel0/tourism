import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterestButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color borderColor, textColor;
  final MaterialAccentColor backgroundColor;
  final Function allData;

  const InterestButton({
    Key? key,
    this.icon = Icons.access_alarms_outlined,
    this.backgroundColor = Colors.redAccent,
    required this.text,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    required this.allData,
  }) : super(key: key);

  @override
  _InterestButtonState createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  bool iconState = false;

  Map<String, dynamic> myData = {
    'Garden': {'text': 'Gardens', 'image': 'assets/images/garden.jpg'},
    'Lake': {'text': 'Lakes', 'image': 'assets/images/lake.jpg'},
    'Forest': {'text': 'Forests', 'image': 'assets/images/forest.jpg'},
    'Waterfall': {
      'text': 'Waterfalls',
      'image': 'assets/images/waterfalls.jpg'
    },
    'Mountain': {'text': 'Mountains', 'image': 'assets/images/mountain.jpg'},
    'Sanctuary': {
      'text': 'Sanctuaries',
      'image': 'assets/images/sanctuary.jpg'
    },
    'Castle': {'text': 'Castles', 'image': 'assets/images/castle.jpg'},
    'National Park': {
      'text': 'National Parks',
      'image': 'assets/images/national-park.jpg'
    },
    'Zoo': {'text': 'Zoos', 'image': 'assets/images/zoo.jpg'},
    'Museum': {'text': 'Museums', 'image': 'assets/images/museum.jpg'},
  };

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          iconState = !iconState;
        });
        widget.allData(widget.text, iconState);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(
                  color: widget.borderColor,
                  style: BorderStyle.solid,
                  width: 10.0)),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.all(12),
        ),
        elevation: MaterialStateProperty.all(5.0),
        backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
        animationDuration: const Duration(milliseconds: 200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(iconState
                ? 'assets/images/check.jpg'
                : myData[widget.text]['image']),
            radius: 15,
          ),
          SizedBox(width: 5.0),
          Text(
            myData[widget.text]['text'],
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              color: widget.textColor,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
