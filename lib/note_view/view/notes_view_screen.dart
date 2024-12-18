import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_app/note_view/models/notes_model.dart';

class NoteViewScreen extends StatefulWidget {
  final NotesModel note;

  const NoteViewScreen({required this.note, Key? key}) : super(key: key);

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  Color _backgroundColor = Colors.white;
  String? _backgroundImagePath;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note.title);
    descriptionController = TextEditingController(text: widget.note.description);

    titleController.addListener(() {
      widget.note.title = titleController.text;
      widget.note.save();
    });

    descriptionController.addListener(() {
      widget.note.description = descriptionController.text;
      widget.note.save();
    });

    _backgroundColor = widget.note.backgroundColor ?? Colors.white;
    _backgroundImagePath = widget.note.backgroundImagePath;
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _backgroundImagePath = image.path;
        widget.note.backgroundImagePath = image.path;
        widget.note.save();
      });
    }
  }

  void _pickColor(Color color) {
    setState(() {
      _backgroundColor = color;
      _backgroundImagePath = null;
      widget.note.backgroundColor = color;
      widget.note.backgroundImagePath = null;
      widget.note.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundImagePath == null ? _backgroundColor : null,
      body: Stack(
        children: [
          if (_backgroundImagePath != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_backgroundImagePath!)),
                  fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.dstIn,
                    )
                ),
              ),
            ),
          _buildContent(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image, color: Colors.white),
                  ),
                  _buildColorPicker(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(top:40),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Divider(),
          Expanded(
            child: TextField(
              controller: descriptionController,
              maxLines: null,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    final colors = [Colors.white,
      Colors.yellow,
      Colors.orange.shade200,
      Colors.green.shade200,
      Colors.blue.shade100,
      Colors.purple.shade100,
    ];

    return Row(
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => _pickColor(color),
          child: Container(
            margin: EdgeInsets.all(4),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
          ),
        );
      }).toList(),
    );
  }
}
