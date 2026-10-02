import 'package:flutter/material.dart';

class ForgetPassScreen extends StatelessWidget {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('For this university demo, admin uses fixed credentials:\nadmin@carzaar.com / admin123', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
