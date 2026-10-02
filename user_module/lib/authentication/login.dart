import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/main_home.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import 'forget_password.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  final auth = AuthService();
  bool loading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> login() async {
    final mail = email.text.trim();
    final pass = password.text.trim();

    if (mail.isEmpty || pass.isEmpty) {
      showMessage('Please enter your email and password');
      return;
    }

    setState(() => loading = true);
    final user = await auth.login(mail, pass);
    if (!mounted) return;
    setState(() => loading = false);

    if (user == null) {
      showMessage('Invalid email or password');
      return;
    }

    context.read<AppProvider>().login(user);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBg(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, size: 70, color: Colors.orange),
          const Text(
            'CarZaar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Where Car Meets Best Prices',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          AuthField(
            label: 'Email',
            icon: Icons.email,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
          ),
          AuthField(
            label: 'Password',
            icon: Icons.lock,
            controller: password,
            obscure: hidePassword,
            action: TextInputAction.done,
            onSubmitted: (_) => loading ? null : login(),
            suffix: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () => setState(() => hidePassword = !hidePassword),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForgetPassword()),
            ),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignUp()),
            ),
            child: const Text(
              'Create New Account',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark text field used on all the authentication screens.
class AuthField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? action;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;

  const AuthField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.action,
    this.onSubmitted,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: action,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.orange),
          suffixIcon: suffix,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black54,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

/// Full-screen background (car photo + dark overlay) for the auth screens.
class AuthBg extends StatelessWidget {
  final Widget child;
  const AuthBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: const NetworkImage(
              'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1600&q=70',
            ),
            fit: BoxFit.cover,
            // If the photo cannot load (offline) the screen stays black
            // instead of throwing an image error.
            onError: (_, __) {},
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.65),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
