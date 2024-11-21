import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/note_view/models/notes_model.dart';
import 'package:notes_app/note_view/view/home_screen.dart';
import 'package:notes_app/res/appColors.dart';
import 'package:path_provider/path_provider.dart';

import 'note_view/models/color_adapter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory= await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Appcolors.primaryColor),
        useMaterial3: true,
      ),
      home: const HiveHomeScreen(),
    );
  }
}
