# duva_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# DuVaApp

# Configuration

This project expects the Supabase URL and anonymous key to be supplied at
startup using Dart environment variables.

Run the app with:

```bash
flutter run \
  --dart-define=SUPABASE_URL=your-supabase-url \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Similarly, pass the same `--dart-define` flags when building the application.
