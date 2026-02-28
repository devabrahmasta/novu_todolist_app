import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../data/app_database.dart';

/// Module for registering third-party singletons.
@module
abstract class RegisterModule {
  /// Provide sqflite Database instance (async, @preResolve).
  @preResolve
  @lazySingleton
  Future<Database> get database => AppDatabase.instance;

  /// Provide SharedPreferences instance (async, @preResolve).
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
