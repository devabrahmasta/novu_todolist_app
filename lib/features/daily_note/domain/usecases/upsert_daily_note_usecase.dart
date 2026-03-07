import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_note_entity.dart';
import '../repositories/daily_note_repository.dart';

/// Creates or updates a daily note (upsert).
@lazySingleton
class UpsertDailyNoteUsecase {
  final DailyNoteRepository _repository;
  UpsertDailyNoteUsecase(this._repository);

  Future<Either<Failure, Unit>> call(DailyNoteEntity note) {
    return _repository.upsertNote(note);
  }
}
