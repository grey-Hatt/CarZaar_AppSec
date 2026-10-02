import 'package:flutter/material.dart';
import 'package:carzaar_admin/dashboard.dart';
import 'package:carzaar_admin/admin_utils.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final email = TextEditingController(text: adminEmail);
  final password = TextEditingController(text: adminPassword);
  bool loading = false, hide = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    setState(() => loading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => loading = false);
      if (email.text.trim() == adminEmail && password.text.trim() == adminPassword) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid admin credentials')));
      }
    });
  }

  Widget field(String label, IconData icon, TextEditingController c, {bool isPass = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        obscureText: isPass && hide,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: isPass
              ? IconButton(icon: Icon(hide ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => hide = !hide))
              : null,
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF06070C), Color(0xFF121A2A)]),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: adminCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 75, color: Colors.deepOrange),
                    const SizedBox(height: 12),
                    const Text('CarZaar Admin', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const Text('Monitor users, cars, bids and reports', style: TextStyle(color: Colors.white60)),
                    const SizedBox(height: 28),
                    field('Admin Email', Icons.email, email),
                    field('Password', Icons.lock, password, isPass: true),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: loading ? null : login,
                        icon: const Icon(Icons.login),
                        label: Text(loading ? 'Logging in...' : 'Login'),
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Default: admin@carzaar.com / admin123', style: TextStyle(color: Colors.white38)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
