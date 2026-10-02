# CarZaar — Admin App

Moderation dashboard of the [CarZaar](../README.md) car bidding marketplace. It works on the same
Supabase database as the user app.

```bash
flutter pub get
flutter run -d chrome
flutter test
```

Set your Supabase URL and anon key in `lib/supabase_config.dart` before running. The demo admin
login is shown on the login screen.

**Modules:** dashboard · user management · listing monitoring · bid monitoring · complaints · analytics
