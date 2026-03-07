import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/daily_note_entity.dart';
import '../repositories/daily_note_repository.dart';

/// Retrieves the daily note for a specific date.
@lazySingleton
class GetDailyNoteUsecase {
  final DailyNoteRepository _repository;
  GetDailyNoteUsecase(this._repository);

  Future<Either<Failure, DailyNoteEntity?>> call(String date) {
    return _repository.getNoteByDate(date);
  }
}
