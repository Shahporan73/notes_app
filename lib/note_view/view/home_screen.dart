// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/note_view/boxs/boxs.dart';
import 'package:notes_app/note_view/models/notes_model.dart';
import 'package:notes_app/note_view/view/notes_view_screen.dart';
import 'package:notes_app/res/appColors.dart';

class HiveHomeScreen extends StatefulWidget {
  const HiveHomeScreen({super.key});

  @override
  State<HiveHomeScreen> createState() => _HiveHomeScreenState();
}

class _HiveHomeScreenState extends State<HiveHomeScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(color: Colors.white),),
        backgroundColor: Appcolors.primaryColor,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
      child: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, value, child) {
          var data = value.values.toList().cast<NotesModel>();
          return GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              var note = data[index];
              String formattedDate = DateFormat('dd/MM/yyyy').format(note.createdAt ?? DateTime.now());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: note.backgroundColor ?? Colors.white,
                      image: note.backgroundImagePath != null && note.backgroundImagePath!.isNotEmpty
                          ? DecorationImage(
                        image: FileImage(File(note.backgroundImagePath!)),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.dstIn,
                        )
                      )
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ]
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: ListTile(
                        title: Text(
                          note.title.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                          ),
                        ),
                        subtitle: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(
                                  note.description.toString(),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )
                        ),
                        onTap: () {
                          // Navigate to the note view screen on tap
                          Get.to(
                                  () => NoteViewScreen(note: note),
                              transition: Transition.downToUp,
                              duration: Duration(milliseconds: 300)
                          );
                        },
                        onLongPress: () {
                          onDelete(context, data[index]);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Text note $formattedDate",
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            },
          );
        },
      ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolors.primaryColor,
        onPressed: () async {
          _showAddNoteDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void onDelete(BuildContext context, NotesModel notesModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Delete note?", style: TextStyle(color: Colors.black, fontSize: 18),),
          content: Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await notesModel.delete();
                Navigator.of(context).pop();
                Get.rawSnackbar(
                    message: "Note deleted",
                    backgroundColor: Colors.red,
                  snackPosition: SnackPosition.BOTTOM
                );
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Add New Note"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.rawSnackbar(message: "Note not added");
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final data = NotesModel(
                  title: titleController.text,
                  description: descriptionController.text,
                  createdAt: DateTime.now(),
                );

                final box = Boxes.getData();
                box.add(data);

                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
