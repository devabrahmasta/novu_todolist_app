import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/daily_note_entity.dart';
import '../../domain/repositories/daily_note_repository.dart';
import '../datasources/daily_note_local_data_source.dart';
import '../models/daily_note_model.dart';

/// Concrete implementation of [DailyNoteRepository] backed by sqflite.
@LazySingleton(as: DailyNoteRepository)
class DailyNoteRepositoryImpl implements DailyNoteRepository {
  final DailyNoteLocalDataSource _localDataSource;

  DailyNoteRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, DailyNoteEntity?>> getNoteByDate(String date) async {
    try {
      final model = await _localDataSource.getNoteByDate(date);
      return right(model?.toEntity());
    } catch (e) {
      return left(CacheFailure('Failed to get note: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> upsertNote(DailyNoteEntity note) async {
    try {
      await _localDataSource.upsertNote(note.toModel());
      return right(unit);
    } catch (e) {
      return left(CacheFailure('Failed to save note: $e'));
    }
  }

  @override
  Future<Either<Failure, List<DailyNoteEntity>>> getAllNotes() async {
    try {
      final models = await _localDataSource.getAllNotes();
      final entities = models.map((m) => m.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left(CacheFailure('Failed to get notes: $e'));
    }
  }
}
