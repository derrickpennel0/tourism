import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../styles/app_style.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _edit = false;
  // Future _selectImage() async {
  //   final picker = ImagePicker();
  //   final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage != null) {
  //     // setState(() {
  //     //   LoggedInUser. = pickedImage.path;
  //     // });
  //   }
  // }

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      // if (pickedFile != null) {
      _imageFile = File(pickedFile!.path);
      // }
    });
  }

  void _editProfile() {
    setState(() {
      _edit = !_edit;
    });
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Future<void> updateDocument() async {
    try {
      // Replace 'collection_name' with the name of your collection
      // and 'document_id' with the ID of the document you want to update.
      User? user = await FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentReference documentRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);

        // Update the fields you want to change. Provide a map of field names and their new values.
        await documentRef.update({
          'email': emailController.text,
          'phone': phoneController.text,
          'location': locationController.text,
          'username': usernameController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _edit = false;
        });
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    locationController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _showOptionsDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.gallery);
              },
              child: Text("Choose from Gallery"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.camera);
              },
              child: Text("Take a Photo"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      debugPrint("ghana");
      return;
    }

    // Upload the image to Firebase Storage

    final reference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile_pics/${DateTime.now().toString()}.jpg');

    await reference.putFile(_imageFile!);

    // Get the download URL of the uploaded image
    final imageUrl = await reference.getDownloadURL();

    // Update the user's profilePic field in Firestore
    // Replace 'YOUR_USER_ID' with the actual user ID
    // You should have the user ID from your authentication method (Firebase Auth, etc.).
    // Firestore example code:
    final userId = await FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'profilePic': imageUrl,
    });

    // Uncomment the above Firestore code once you set up Firestore in your project.

    print('Image uploaded successfully. URL: $imageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Profile",
          style: GoogleFonts.quicksand(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: LoggedInUser.info(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              usernameController.text = snapshot.data?._username ?? "";
              emailController.text = snapshot.data?.email ?? "";
              phoneController.text = snapshot.data?.phone ?? "";
              locationController.text = snapshot.data?.location ?? "";

              return ListView(
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                // Profile picture
                                _imageFile != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_imageFile!),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "${snapshot.data?.profilePic}"),
                                      ),
                                // Camera icon overlay
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showOptionsDialog,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor:
                                          Color.fromARGB(255, 32, 38, 38),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _edit
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _edit = !_edit;
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons
                                                .cancel), // Replace "your_icon" with the desired icon
                                            SizedBox(
                                                width:
                                                    8), // Add some space between the icon and text
                                            Text(
                                              "Cancel",
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    Colors.grey)),
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      ElevatedButton(
                                        onPressed: updateDocument,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(_edit
                                                ? Icons.check
                                                : Icons
                                                    .edit), // Replace "your_icon" with the desired icon
                                            SizedBox(
                                                width:
                                                    8), // Add some space between the icon and text
                                            Text(
                                              "Save",
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    const Color.fromARGB(
                                                        255, 6, 78, 8))),
                                      )
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: _editProfile,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(_edit
                                            ? Icons.check
                                            : Icons
                                                .edit), // Replace "your_icon" with the desired icon
                                        SizedBox(
                                            width:
                                                8), // Add some space between the icon and text
                                        Text(
                                          "Edit Profile",
                                          style: GoogleFonts.quicksand(
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.blue)),
                                  )
                          ]),
                      Divider(
                        thickness: 2,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 20),
                      Editable(
                          edit: _edit,
                          detail: snapshot.data?._username ?? "",
                          label: "USERNAME",
                          controller: usernameController,
                          icon: Icons.person_2_outlined),
                      SizedBox(height: 20),
                      Editable(
                          edit: _edit,
                          detail: snapshot.data?.email ?? "",
                          label: "EMAIL",
                          controller: emailController,
                          icon: Icons.email_outlined),
                      SizedBox(height: 20),
                      Editable(
                          edit: _edit,
                          detail: snapshot.data?.phone ?? "",
                          label: "PHONE",
                          controller: phoneController,
                          icon: Icons.phone_android_outlined),
                      SizedBox(height: 20),
                      Editable(
                          edit: _edit,
                          detail: snapshot.data?.location ?? "",
                          controller: locationController,
                          label: "LOCATION",
                          icon: Icons.location_city_outlined),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                  child: Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ));
            }
          },
        ),
      ),
    );
  }
}

class Editable extends StatelessWidget {
  const Editable(
      {super.key,
      required bool edit,
      required this.detail,
      required this.icon,
      required this.controller,
      required this.label})
      : _edit = edit;

  final bool _edit;
  final String label;
  final String detail;
  final IconData icon;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              GoogleFonts.quicksand(fontSize: 14, color: Colors.grey.shade500),
        ),
        SizedBox(height: 2),
        !_edit == true
            ? ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(icon),
                title: Text(
                  detail,
                  style: GoogleFonts.quicksand(
                      fontSize: 20,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600),
                ),
              )
            : TextFormField(
                style: GoogleFonts.quicksand(
                    color: Styles.supportingTextDeepShadeColor),
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  focusColor: Styles.brandDeepShadeColor,
                  // fillColor: Color.fromARGB(255, 237, 232, 232),
                  fillColor: Colors.grey.shade300,

                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextDeepShadeColor)),
                  // labelText: 'Email',
                  // hintText: 'Enter your email',
                  // hintStyle: TextStyle(
                  //     color: Styles.supportingTextDeepShadeColor),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Styles.supportingTextLightShadeColor)),
                  labelStyle: const TextStyle(color: Colors.black54),
                ),
                // validator: _validateEmail,
                // onChanged: (value) {
                //   setState(() {
                //     _email = value;
                //   });
                // },
              ),
      ],
    );
  }
}

class LoggedInUser {
  String? _username;
  String? location;
  String? phone;
  String? email;
  String? profilePic;

  static Future<LoggedInUser?> info() async {
    User? user = await FirebaseAuth.instance.currentUser;
    // print('userr905945 $user');
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();
      String? userName = snapshot.data()?['username'] as String?;
      String? location = snapshot.data()?['location'] as String?;
      String? phone = snapshot.data()?['phone'] as String?;
      String? email = snapshot.data()?['email'] as String?;
      String? profilePic = snapshot.data()?['profilePic'] as String?;

      LoggedInUser loggedInUser = LoggedInUser();
      loggedInUser._username = userName;
      loggedInUser.location = location;
      loggedInUser.phone = phone;
      loggedInUser.email = email;
      loggedInUser.profilePic = profilePic;

      // print(loggedInUser.email);
      return loggedInUser;
    }

    return null;
  }

  String? get username => _username;
}
