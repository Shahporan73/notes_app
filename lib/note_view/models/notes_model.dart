import 'dart:ui';

import 'package:hive/hive.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject{

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? createdAt;

  @HiveField(3)
  Color? backgroundColor;

  @HiveField(4)
  String? backgroundImagePath;


  NotesModel({required this.title, required this.description, this.createdAt,
    this.backgroundColor,
    this.backgroundImagePath
  });
}