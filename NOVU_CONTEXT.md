# NOVU — PERMANENT PROJECT CONTEXT
# Feed this file to Antigravity at the start of every session.

---

## PROJECT IDENTITY

APP_NAME: Novu
TAGLINE: New day. New streak.
TYPE: Flutter mobile app — task manager + habit tracker
PLATFORM: Android (primary), iOS (secondary)
DISTRIBUTION: Google Play Store
MONETIZATION: One-time purchase (freemium + Pro unlock)

---

## ARCHITECTURE — NON-NEGOTIABLE

PATTERN: Clean Architecture
LAYERS: presentation → domain → data

LAYER_RULES:
- presentation: widgets, screens, providers (Riverpod)
- domain: entities, repositories (abstract), use cases
- data: models, repository implementations, data sources (sqflite)
- domain must NOT import from data or presentation
- data must NOT import from presentation

FOLDER_STRUCTURE:
```
lib/
  core/
    di/           # GetIt + Injectable
    theme/        # app_colors, app_text_styles, app_theme, novu_colors_extension
    utils/        # enums, seed_data, settings_service
  features/
    task/
    habit/        # NEW — to be created
    habit_goal/   # NEW — to be created
    daily_note/   # NEW — to be created
    calendar/
    stats/
    profile/
    onboarding/   # NEW — to be created
```

---

## STATE MANAGEMENT — STRICT RULES

ALLOWED: flutter_riverpod ^2.6.1 with riverpod_annotation
DI_ONLY: get_it + injectable (dependency injection only, NOT state management)

RULES:
- ALL app state → Riverpod providers
- setState() → ONLY for local UI animation (e.g. FAB expand, sheet scroll)
- GetX → FORBIDDEN (incompatible with existing Clean Architecture + get_it)
- Provider (non-Riverpod) → FORBIDDEN
- BLoC → FORBIDDEN

PROVIDER_PATTERN:
```dart
// Use case bridge pattern (existing pattern — follow this)
@riverpod
SomeUsecase someUsecase(SomeUsecaseRef ref) => getIt<SomeUsecase>();

// Notifier pattern for mutable state
@riverpod
class SomeNotifier extends _$SomeNotifier {
  @override
  Future<SomeEntity> build() async { ... }
}
```

AFTER_ADDING_PROVIDERS: always run `flutter pub run build_runner build --delete-conflicting-outputs`

---

## TECH STACK

```yaml
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.3.5
get_it: ^8.0.3
injectable: ^2.4.4
freezed_annotation: ^2.4.4
json_annotation: ^4.8.1
sqflite: ^2.4.2
path: ^1.9.1
path_provider: ^2.1.5
shared_preferences: ^2.3.5
fpdart: ^1.1.0
go_router: ^14.8.1
google_fonts: ^6.2.1
flutter_slidable: ^3.1.1
table_calendar: ^3.1.3
uuid: ^4.5.1
```

---

## DATABASE — sqflite (LOCAL ONLY, OFFLINE-FIRST)

EXISTING_TABLES: tasks, subtasks, categories
NEW_TABLES_NEEDED: habits, habit_steps, habit_goals, habit_completions, daily_notes

ALL data is local. No backend. No cloud sync in V1.

---

## DESIGN SYSTEM — ENFORCED

THEME: Monochrome minimalist, light mode primary
FONT: DM Sans (Google Fonts) — regular, medium, semibold only
BORDER_RADIUS: 10px (not 20px)
COLOR_PRIMARY: #1A1A18 (near-black warm)
COLOR_BACKGROUND: #FAFAF9 (warm white)
COLOR_ACCENT: single subtle accent for completion/streak moments only

NO_COLOR_ACCENTS: no purple, no lime, no gradient — monochrome only
NO_FILLED_ICONS: outline icons only, thin stroke
ANIMATION_MAX: 250ms, natural easing

CHECKLIST_FEEDBACK: strikethrough animation + fade — no confetti, no jumping checkmarks
EMPTY_STATES: every screen that can be empty MUST have an empty state
  - components: line-art illustration (monochrome) + 1 encouraging sentence + 1 CTA button

REFERENCE_APPS: iOS Reminders, Linear, Things 3

---

## TERMINOLOGY — FINAL, DO NOT DEVIATE

| Use This       | Never Use This     |
|----------------|--------------------|
| Tags           | Category           |
| Goal / Challenge | Contract         |
| Steps          | Subtasks (habit)   |
| Create Habit   | Create Task (habit)|
| Speed Dial FAB | Long-press FAB     |

---

## FEATURE FLAGS — V1 SCOPE

IN_SCOPE:
- Task management (existing, needs UI update)
- Habit tracking: Yes/No + Measurable types
- Habit Steps (ordered routine steps, drag-reorder)
- Goal / Challenge (timed habit with progress bar)
- Tomorrow Dump (rapid night planning)
- Daily Note (text + mood per day, photo = Pro)
- Identity Anchor (onboarding + stats framing)
- Calendar view
- Stats screen
- Speed Dial FAB (Task + Habit)
- Empty states (all screens)
- Onboarding (4 screens)
- Dark/Light mode

OUT_OF_SCOPE_V1:
- Cloud sync / backup
- Icon + color custom per habit
- Home widget (Android)
- Gamification (XP, badges, levels)
- Social / accountability
- AI features
- Habit stacking
- Web version

---

## CODE QUALITY RULES

- All new entities: use @freezed
- All new models: use @JsonSerializable + fromMap/toMap for sqflite
- All repositories: abstract interface in domain, implementation in data
- All use cases: single public method call(), return Either<Failure, T>
- No business logic in widgets or providers
- No direct sqflite calls from providers — always through repository → use case chain
- Providers must NOT catch exceptions directly — use fpdart Either pattern
- Run build_runner after every new @riverpod, @freezed, @injectable annotation
