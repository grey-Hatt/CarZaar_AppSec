import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:carzaar_admin/supabase_config.dart';
import 'package:carzaar_admin/authentication/admin_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarZaar Admin',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepOrange.shade600,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepOrange.shade600,
          secondary: Colors.amber.shade600,
          surface: Color(0xFF101421),
        ),
        scaffoldBackgroundColor: Color(0xFF06070C),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF090B12),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF090B12)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF0E1423),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.deepOrange.shade600, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.white70),
          hintStyle: TextStyle(color: Colors.white38),
          prefixIconColor: Colors.deepOrange.shade600,
          suffixIconColor: Colors.white54,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      home: const AdminLoginScreen(),
    );
  }
}
