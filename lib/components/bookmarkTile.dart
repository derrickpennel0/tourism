import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../screens/details.dart';

class BookmarkTile extends StatefulWidget {
  final String name;
  final String image;
  final String subtitle;
  const BookmarkTile(
      {super.key,
      required this.name,
      required this.subtitle,
      required this.image});

  @override
  State<BookmarkTile> createState() => _BookmarkTileState();
}

class _BookmarkTileState extends State<BookmarkTile> {
  List Images = [
    'forest',
    'lake',
    'mountain',
    'waterfalls',
    'zoo',
    'sanctuary'
  ];
  @override
  Widget build(BuildContext context) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 12, offset: Offset(4, 4))
        ]),
        child: ListTile(
          // contentPadding: EdgeInsets.symmetric(vertical: 20),
          tileColor: Colors.white,
          subtitle: Text(widget.subtitle),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 70,
              width: 70,
              color: Colors.cyan,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Handle the error and provide an alternative widget or fallback image
                  return Image.asset(
                    'assets/images/${Images[Random().nextInt(Images.length)]}.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Details(name: widget.name),
                ));
          },
          title: Text(widget.name),
        ),
      ),
    );
  }
}
