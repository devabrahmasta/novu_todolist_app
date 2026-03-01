import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/projects/presentation/screens/projects_placeholder_screen.dart';
import '../../features/task/presentation/screens/create_task_screen.dart';
import '../../features/task/presentation/screens/edit_task_screen.dart';
import '../../features/task/presentation/screens/home_screen.dart';
import '../../features/task/presentation/screens/task_view_screen.dart';
import '../../features/task/presentation/screens/onboarding_screen.dart';
import '../di/injection.dart';
import '../utils/settings_service.dart';
import 'main_shell.dart';
import 'route_names.dart';

/// Application router config with GoRouter.
GoRouter createRouter() {
  final settingsService = getIt<SettingsService>();

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final settings = settingsService.loadSettings();
      if (!settings.hasCompletedOnboarding &&
          state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }
      if (settings.hasCompletedOnboarding &&
          state.matchedLocation == '/onboarding') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: RouteNames.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                name: RouteNames.calendar,
                builder: (_, __) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/projects',
                name: RouteNames.projects,
                builder: (_, __) => const ProjectsPlaceholderScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: RouteNames.profile,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Push routes (not in shell):
      GoRoute(
        path: '/task/create',
        name: RouteNames.createTask,
        builder: (_, __) => const CreateTaskScreen(),
      ),
      GoRoute(
        path: '/task/:id',
        name: RouteNames.taskView,
        builder: (_, state) =>
            TaskViewScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/task/:id/edit',
        name: RouteNames.editTask,
        builder: (_, state) =>
            EditTaskScreen(taskId: state.pathParameters['id']!),
      ),
    ],
  );
}
