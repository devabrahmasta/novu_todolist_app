import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_note_entity.dart';
import '../repositories/daily_note_repository.dart';

/// Retrieves all daily notes.
@lazySingleton
class GetAllDailyNotesUsecase {
  final DailyNoteRepository _repository;
  GetAllDailyNotesUsecase(this._repository);

  Future<Either<Failure, List<DailyNoteEntity>>> call() {
    return _repository.getAllNotes();
  }
}
