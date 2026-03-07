import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_note_entity.freezed.dart';

/// A daily journal note — one per day, with optional mood and photo.
@freezed
class DailyNoteEntity with _$DailyNoteEntity {
  const factory DailyNoteEntity({
    required String id,
    required String date, // "yyyy-MM-dd", unique per day
    String? text, // max 200 chars
    String? photoPath, // local file path, Pro only
    int? mood, // 0–4 (0=dark/hard, 4=bright/great)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DailyNoteEntity;
}
