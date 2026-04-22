# Workout Calendar

Workout Calendar is a Flutter app. The application code lives in `lib/`, `assets/`, and `test/`.

## Stack

- Flutter
- `flutter_riverpod` for state and dependency management
- `go_router` for navigation
- `intl` for date/number formatting
- Local JSON assets as the data source

## Project Layout

```text
assets/
  data/                     # copied workout JSON fixtures
lib/
  app/                      # app shell, theme, router
  core/                     # constants, errors, formatters, extensions
  features/
    calendar/               # calendar state and UI
    workout_details/        # details state and UI
    workouts/               # entities, repository contracts, asset repository
  shared/                   # app-wide providers and reusable widgets
test/
  core/                     # formatter and calendar grid tests
  features/                 # repository/provider/controller tests
  support/                  # fake repository and sample data
```

## Run

1. Install Flutter SDK with Dart `>=3.7.0`.
2. If this repo does not yet contain generated platform folders on your machine, run:

   ```bash
   flutter create .
   ```

   This is a one-time bootstrap step for `android/`, `ios/`, `macos/`, `web/`, and other generated files.

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Start the app:

   ```bash
   flutter run
   ```

5. Run tests:

   ```bash
   flutter test
   flutter analyze
   ```

## What Changed

- Moved business logic out of widgets into Riverpod providers/controllers.
- Replaced ad-hoc JSON access with a repository abstraction and asset-backed implementation.
- Kept models immutable and converted raw JSON strings into typed domain values at the boundary.
- Added unit tests for calendar generation, formatting, repository parsing, and provider/controller behavior.
- Copied source JSON files into `assets/data/` so the Flutter app can load them directly.

## UX Notes

- The app opens on the most recent workout month from the dataset instead of today, so sample data is visible immediately.
- Calendar weeks start on Monday.
- Workout details include formatted metrics and a custom-painted heart-rate chart.
