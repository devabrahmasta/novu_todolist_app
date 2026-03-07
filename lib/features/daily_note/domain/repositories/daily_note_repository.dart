import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_note_entity.dart';

/// Abstract daily note repository — domain layer contract.
abstract class DailyNoteRepository {
  Future<Either<Failure, DailyNoteEntity?>> getNoteByDate(String date);
  Future<Either<Failure, Unit>> upsertNote(DailyNoteEntity note);
  Future<Either<Failure, List<DailyNoteEntity>>> getAllNotes();
}
