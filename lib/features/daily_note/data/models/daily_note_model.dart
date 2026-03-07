import '../../domain/entities/daily_note_entity.dart';

/// SQLite-backed daily note model.
class DailyNoteModel {
  String id;
  String date; // "yyyy-MM-dd", UNIQUE
  String? text;
  String? photoPath;
  int? mood; // 0–4
  int createdAt; // millisSinceEpoch
  int updatedAt;

  DailyNoteModel({
    required this.id,
    required this.date,
    this.text,
    this.photoPath,
    this.mood,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyNoteModel.fromMap(Map<String, dynamic> map) {
    return DailyNoteModel(
      id: map['id'] as String,
      date: map['date'] as String,
      text: map['text'] as String?,
      photoPath: map['photo_path'] as String?,
      mood: map['mood'] as int?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'text': text,
      'photo_path': photoPath,
      'mood': mood,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

// ─── Mapper Extensions ──────────────────────────────────

extension DailyNoteModelMapper on DailyNoteModel {
  DailyNoteEntity toEntity() {
    return DailyNoteEntity(
      id: id,
      date: date,
      text: text,
      photoPath: photoPath,
      mood: mood,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }
}

extension DailyNoteEntityMapper on DailyNoteEntity {
  DailyNoteModel toModel() {
    return DailyNoteModel(
      id: id,
      date: date,
      text: text,
      photoPath: photoPath,
      mood: mood,
      createdAt: createdAt.millisecondsSinceEpoch,
      updatedAt: updatedAt.millisecondsSinceEpoch,
    );
  }
}
