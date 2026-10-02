import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

const adminEmail = 'admin@carzaar.com';
const adminPassword = 'admin123';

String shortId(Object? v) {
  final s = v?.toString() ?? '';
  if (s.isEmpty) return 'N/A';
  return s.length <= 8 ? s : '${s.substring(0, 8)}...';
}

String userName(Map<String, dynamic>? u) {
  if (u == null) return 'Unknown';
  final name = (u['name'] ?? '').toString();
  if (name.isNotEmpty) return name;
  final fname = (u['fname'] ?? '').toString();
  final lname = (u['lname'] ?? '').toString();
  return '$fname $lname'.trim().isEmpty ? 'Unknown' : '$fname $lname'.trim();
}

Color statusColor(String status) {
  switch (status) {
    case 'active':
    case 'accepted':
    case 'resolved':
    case 'sold':
      return Colors.green;
    case 'pending':
    case 'deal_pending':
    case 'reviewed':
      return Colors.orange;
    case 'blocked':
    case 'removed':
    case 'rejected':
    case 'withdrawn':
    case 'cancelled':
    case 'dismissed':
      return Colors.red;
    default:
      return Colors.blueGrey;
  }
}

Widget statusChip(String status) {
  final c = statusColor(status);
  return Chip(
    label: Text(status, style: const TextStyle(color: Colors.white)),
    backgroundColor: c,
  );
}

Widget emptyBox(String text, IconData icon) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.white24),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Colors.white60, fontSize: 18)),
        ],
      ),
    );

Widget adminCard({required Widget child}) => Card(
      color: const Color(0xFF101826),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(14), child: child),
    );

class CarImageBox extends StatefulWidget {
  final String? image;
  final double height;
  const CarImageBox({super.key, this.image, this.height = 135});

  @override
  State<CarImageBox> createState() => _CarImageBoxState();
}

class _CarImageBoxState extends State<CarImageBox> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = _decode(widget.image);
  }

  @override
  void didUpdateWidget(covariant CarImageBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) _bytes = _decode(widget.image);
  }

  // Decoded once (not on every rebuild) and never throws on bad data.
  Uint8List? _decode(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(Icons.directions_car, size: 56, color: Colors.white38);
    return Container(
      height: widget.height,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF0E1423),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: _bytes == null
          ? placeholder
          : Image.memory(
              _bytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: widget.height,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}

/// Formats a number as a price, e.g. `Rs. 2,500,000`.
String formatPrice(Object? value) {
  final number = num.tryParse(value?.toString() ?? '') ?? 0;
  final digits = number.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'Rs. ${number < 0 ? '-' : ''}$buffer';
}

Future<Map<String, dynamic>?> fetchUser(String? id) async {
  if (id == null || id.isEmpty) return null;
  try {
    return await supabase.from('users').select().eq('id', id).maybeSingle();
  } catch (_) {
    return null;
  }
}

Future<Map<String, dynamic>?> fetchCar(String? id) async {
  if (id == null || id.isEmpty) return null;
  try {
    return await supabase.from('cars').select().eq('id', id).maybeSingle();
  } catch (_) {
    return null;
  }
}
