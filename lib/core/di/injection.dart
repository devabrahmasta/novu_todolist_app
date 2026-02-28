import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// Global service locator.
final getIt = GetIt.instance;

/// Initialize all injectable dependencies.
@InjectableInit()
Future<void> configureDependencies() => getIt.init();
