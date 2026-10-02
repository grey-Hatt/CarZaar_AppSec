import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final email = TextEditingController();
  final phone = TextEditingController();
  final newPassword = TextEditingController();

  final auth = AuthService();
  bool loading = false;
  bool hidePassword = true;

  @override
  void dispose() {
    email.dispose();
    phone.dispose();
    newPassword.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> reset() async {
    if (email.text.trim().isEmpty ||
        phone.text.trim().isEmpty ||
        newPassword.text.trim().isEmpty) {
      showMessage('Fill all fields');
      return;
    }

    setState(() => loading = true);

    final e = await auth.resetPassword(
      email.text.trim(),
      phone.text.trim(),
      newPassword.text.trim(),
    );

    if (!mounted) return;
    setState(() => loading = false);
    showMessage(e ?? 'Password updated successfully');

    if (e == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthBg(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user, size: 70, color: Colors.orange),
          const Text(
            'Verify Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your registered email and phone',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 25),
          AuthField(
            label: 'Registered Email',
            icon: Icons.email,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
          ),
          AuthField(
            label: 'Registered Phone',
            icon: Icons.phone,
            controller: phone,
            keyboardType: TextInputType.phone,
            action: TextInputAction.next,
          ),
          AuthField(
            label: 'New Password',
            icon: Icons.lock,
            controller: newPassword,
            obscure: hidePassword,
            action: TextInputAction.done,
            onSubmitted: (_) => loading ? null : reset(),
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
              onPressed: loading ? null : reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
              child: Text(loading ? 'Verifying...' : 'Verify & Reset'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Back to Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
