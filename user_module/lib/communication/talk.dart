import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/format.dart';

class Talk extends StatelessWidget {
  final String phone;
  final String message;

  const Talk({
    super.key,
    required this.phone,
    required this.message,
  });

  Future<void> openWhatsApp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    // wa.me only accepts digits, so strip "+", spaces, dashes, brackets...
    final cleanPhone = digitsOnly(phone);

    if (cleanPhone.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No phone number available')),
      );
      return;
    }

    final url = Uri.parse(
      'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}',
    );

    bool opened = false;
    try {
      opened = await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => openWhatsApp(context),
      icon: const Icon(Icons.chat),
      label: const Text('Contact on WhatsApp'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(14),
      ),
    );
  }
}
