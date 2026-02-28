import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/task/presentation/screens/create_task_screen.dart';
import '../../features/task/presentation/screens/edit_task_screen.dart';
import '../../features/task/presentation/screens/home_screen.dart';
import '../../features/task/presentation/screens/task_list_screen.dart';
import '../../features/task/presentation/screens/task_view_screen.dart';
import '../../features/task/presentation/screens/onboarding_screen.dart';
import '../di/injection.dart';
import '../utils/settings_service.dart';
import 'route_names.dart';

/// Application router config with GoRouter.
GoRouter createRouter() {
  final settingsService = getIt<SettingsService>();

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final settings = settingsService.loadSettings();
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!settings.hasCompletedOnboarding && !isOnboarding) {
        return '/onboarding';
      }
      if (settings.hasCompletedOnboarding && isOnboarding) {
        return '/home';
      }
      // Redirect root to /home
      if (state.matchedLocation == '/') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/home'),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/tasks',
        name: RouteNames.tasks,
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/task/create',
        name: RouteNames.createTask,
        builder: (context, state) => const CreateTaskScreen(),
      ),
      GoRoute(
        path: '/task/:id',
        name: RouteNames.taskView,
        builder: (context, state) =>
            TaskViewScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/task/:id/edit',
        name: RouteNames.editTask,
        builder: (context, state) =>
            EditTaskScreen(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/calendar',
        name: RouteNames.calendar,
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}
