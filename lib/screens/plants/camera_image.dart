import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../components/admin_nav.dart';
import '../../components/snackbar.dart';
import '../../helper/admin_enum.dart';
import 'add_plants.dart';

/// Add plant image from gallery or camera
class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  /// Variables
  final fs = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  PickedFile? image;
  var uuid = const Uuid();

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Plant Image"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// get image from gallery
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF58AF8B),
                    foregroundColor: Colors.white),
                onPressed: () async {
                  // ignore: deprecated_member_use
                  image =
                      // ignore: deprecated_member_use
                      await imagePicker.getImage(source: ImageSource.gallery);
                  var file = File(image?.path ?? "");

                  if (image != null) {
                    var id = uuid.v4();

                    /// Upload to Firebase
                    var snapshot =
                        await fs.ref().child('images/$id').putFile(file);
                    var downloadUrl = await snapshot.ref.getDownloadURL();
                    if (downloadUrl != "") {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPlants(url: downloadUrl)));
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    snackBar(context, "Error");
                  }
                },
                child: const Text("FROM GALLERY"),
              ),
              Container(
                height: 40.0,
              ),

              /// get image from camera
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF58AF8B),
                    foregroundColor: Colors.white),
                onPressed: () async {
                  // ignore: deprecated_member_use
                  image =
                      // ignore: deprecated_member_use
                      await imagePicker.getImage(source: ImageSource.camera);
                  var file = File(image?.path ?? "");

                  if (image != null) {
                    /// Upload to Firebase
                    var snapshot = await fs.ref().child('images').putFile(file);
                    var downloadUrl = await snapshot.ref.getDownloadURL();
                    if (downloadUrl != "") {
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddPlants(url: downloadUrl)));
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    snackBar(context, "Error");
                  }
                },
                child: const Text("FROM CAMERA"),
              )
            ],
          ),
        ),
        bottomNavigationBar:
            const AdminNavBar(selectedMenu: AdminState.plants));
  }
}
