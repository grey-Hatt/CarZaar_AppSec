import 'package:flutter/material.dart';

/// Small colour-coded badge for bid / car / report statuses.
class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip(this.status, {super.key});

  Color get _color => switch (status) {
        'active' || 'accepted' || 'resolved' || 'sold' => Colors.green,
        'pending' || 'deal_pending' || 'reviewed' => Colors.orange,
        'rejected' ||
        'withdrawn' ||
        'cancelled' ||
        'blocked' ||
        'removed' ||
        'dismissed' =>
          Colors.red,
        _ => Colors.blueGrey,
      };

  String get _label {
    final text = status.replaceAll('_', ' ');
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
