class ClothesField {
  // static const String tableName = 'notes';
  // static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  // static const String textType = 'TEXT NOT NULL';
  // static const String intType = 'INTEGER NOT NULL';
  // static const String id = '_id';
  // static const String title = 'title';
  // static const String number = 'number';
  // static const String content = 'content';
  // static const String isFavorite = 'is_favorite';
  // static const String createdTime = 'created_time';

  static const String tableName = 'clothing_items';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String clothingType = 'clothing_type';
  static const String owner = 'owner';
  static const String color = 'color';
  static const String description = 'description';

  // static const String title = 'title';
  // static const String number = 'number';
  // static const String content = 'content';
  // static const String isFavorite = 'is_favorite';
  // static const String createdTime = 'created_time';

  static const List<String> values = [
    id,
    clothingType,
    owner,
    color,
    description,
  ];
}

class ClothesModel {
  int? id;
  final String clothingType;
  final String owner;
  final String? color;
  final String? description;

  // final int? id;
  // final int? number;
  // final String title;
  // final String content;
  // final bool isFavorite;
  // final DateTime? createdTime;
  ClothesModel(
      {this.id,
      required this.owner,
      required this.clothingType,
      this.color,
      this.description
      // this.id,
      // this.number,
      // required this.title,
      // required this.content,
      // this.isFavorite = false,
      // this.createdTime,
      });

  Map<String, Object?> toJson() => {
        ClothesField.id: id,
        ClothesField.clothingType: clothingType,
        ClothesField.owner: owner,
        ClothesField.color: color,
        ClothesField.description: description,
        // NoteFields.id: id,
        // NoteFields.number: number,
        // NoteFields.title: title,
        // NoteFields.content: content,
        // NoteFields.isFavorite: isFavorite ? 1 : 0,
        // NoteFields.createdTime: createdTime?.toIso8601String(),
      };

  factory ClothesModel.fromJson(Map<String, Object?> json) => ClothesModel(
        id: json[ClothesField.id] as int,
        clothingType: json[ClothesField.clothingType] as String,
        owner: json[ClothesField.owner] as String,
        color: json[ClothesField.color] as String?,
        description: json[ClothesField.description] as String?,
      );

  ClothesModel copy({
    int? id,
    String? clothingType,
    String? owner,
    String? color,
    String? description,
  }) =>
      ClothesModel(
        id: id ?? this.id,
        clothingType: clothingType ?? this.clothingType,
        owner: owner ?? this.owner,
        color: color ?? this.color,
        description: description ?? this.description,
      );
}
