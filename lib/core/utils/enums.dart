/// All enums used throughout the Novu app.

/// Time-of-day grouping for task ordering on the Home screen.
enum TimeOfDaySlot {
  morning, // 06:00 – 11:59
  afternoon, // 12:00 – 16:59
  evening, // 17:00 – 23:59
}

/// Task priority level. Always optional (nullable) on a task.
enum TaskPriority { low, medium, high }

/// Current status of a task.
enum TaskStatus { pending, completed, archived }

/// Repeat / recurrence type for a task.
enum RepeatType { none, daily, weekly, monthly, custom }

/// Type of habit tracking.
enum HabitType { yesNo, measurable }

/// Status of a habit goal / challenge.
enum HabitGoalStatus { active, completed, archived, abandoned }

/// Measurable habit target direction.
enum MeasurableTarget { atLeast, atMost }

/// Universal priority level (shared by tasks and habits).
enum Priority { low, medium, high }
