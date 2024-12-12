import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sockapp/clothing_item.dart';
import 'package:sockapp/db.dart';
import 'package:camera/camera.dart';
import 'package:sockapp/globals.dart' as globals;

class ClothingDetailView extends StatefulWidget {
  const ClothingDetailView({super.key, this.itemId});
  final int? itemId;

  @override
  State<ClothingDetailView> createState() => _ClothingDetailViewState();
}

class _ClothingDetailViewState extends State<ClothingDetailView> {
  ClothingItemDatabase db = ClothingItemDatabase.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late ClothesModel item;
  bool isLoading = false;
  bool isNewItem = false;
  bool isFavorite = false;
  bool openCamera = false;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    refreshItems();
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      globals.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  ///Gets the note from the database and updates the state if the noteId is not null else it sets the isNewNote to true
  refreshItems() {
    if (widget.itemId == null) {
      setState(() {
        isNewItem = true;
      });
      return;
    }
    db.read(widget.itemId!).then((value) {
      setState(() {
        item = value;
        titleController.text = item.clothingType;
        contentController.text = item.owner;
      });
    });
  }

  ///Creates a new note if the isNewNote is true else it updates the existing note
  createItem() {
    setState(() {
      isLoading = true;
    });
    final model = ClothesModel(
      clothingType: titleController.text,
      owner: contentController.text,
      color: "black",
      description: "test desc",
    );
    if (isNewItem) {
      db.create(model);
    } else {
      model.id = item.id;
      db.update(model);
    }
    setState(() {
      isLoading = false;
    });
  }

  ///Deletes the note from the database and navigates back to the previous screen
  deleteItem() {
    db.delete(item.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                openCamera = !openCamera;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite),
          ),
          Visibility(
            visible: !isNewItem,
            child: IconButton(
              onPressed: deleteItem,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createItem,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type your note here...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    child: openCamera
                        ? FutureBuilder<void>(
                            future: _initializeControllerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                // If the Future is complete, display the preview.
                                return CameraPreview(_controller);
                              } else {
                                // Otherwise, display a loading indicator.
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          )
                        : Text("Here be camera"),
                  ),
                ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
