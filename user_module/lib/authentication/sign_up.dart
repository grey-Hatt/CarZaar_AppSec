import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/format.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();

  final auth = AuthService();
  bool loading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    for (final c in [name, email, password, phone, city]) {
      c.dispose();
    }
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> signup() async {
    if ([name, email, password, phone, city].any((c) => c.text.trim().isEmpty)) {
      showMessage('Fill all fields');
      return;
    }
    if (!looksLikeEmail(email.text)) {
      showMessage('Enter a valid email address');
      return;
    }
    final phoneDigits = digitsOnly(phone.text);
    if (phoneDigits.length < 10) {
      showMessage('Enter a valid phone number, e.g. 923001234567');
      return;
    }

    setState(() => loading = true);

    final user = UserModel(
      name: name.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
      phone: phone.text.trim(),
      city: city.text.trim(),
    );

    final e = await auth.signUp(user);

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(e ?? 'Account created successfully');

    if (e == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthBg(
      child: Column(
        children: [
          const Icon(Icons.person_add, size: 65, color: Colors.orange),
          const Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          AuthField(
            label: 'Full Name',
            icon: Icons.person,
            controller: name,
            action: TextInputAction.next,
          ),
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
            action: TextInputAction.next,
            suffix: IconButton(
              icon: Icon(
                hidePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
              onPressed: () => setState(() => hidePassword = !hidePassword),
            ),
          ),
          AuthField(
            label: 'Phone e.g. 923001234567',
            icon: Icons.phone,
            controller: phone,
            keyboardType: TextInputType.phone,
            action: TextInputAction.next,
          ),
          AuthField(
            label: 'City',
            icon: Icons.location_city,
            controller: city,
            action: TextInputAction.done,
            onSubmitted: (_) => loading ? null : signup(),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
              child: Text(loading ? 'Creating...' : 'Sign Up'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Already have an account? Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
