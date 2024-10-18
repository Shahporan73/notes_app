// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notes_app/note_view/models/notes_model.dart';
import 'package:notes_app/res/appColors.dart';

class NoteViewScreen extends StatefulWidget {
  final NotesModel note;  // Pass the note object to this screen

  const NoteViewScreen({required this.note, Key? key}) : super(key: key);

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note.title);
    descriptionController = TextEditingController(text: widget.note.description);

    // Listen for changes and automatically save updates to Hive
    titleController.addListener(() {
      widget.note.title = titleController.text;
      widget.note.save();  // Save the updated title in real-time
    });

    descriptionController.addListener(() {
      widget.note.description = descriptionController.text;
      widget.note.save();  // Save the updated description in real-time
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(color: Colors.white),),
        backgroundColor: Appcolors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Title",
                //   style: TextStyle(
                //       color: Colors.black, fontWeight: FontWeight.w600,
                //       fontSize: 20
                //   ),
                // ),
                SizedBox(height: 5),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none
                    ),
                  ),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Divider(color: Colors.grey,),
                ),
                // Editable TextField for Description
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),
                    ),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
