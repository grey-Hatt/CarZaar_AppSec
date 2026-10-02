import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carzaar_admin/admin_utils.dart';

void main() {
  group('shortId', () {
    test('shortens long ids and handles empty values', () {
      expect(shortId('1234567890abcdef'), '12345678...');
      expect(shortId('abc'), 'abc');
      expect(shortId(null), 'N/A');
    });
  });

  group('userName', () {
    test('prefers name, falls back to first/last name', () {
      expect(userName({'name': 'Ali Khan'}), 'Ali Khan');
      expect(userName({'fname': 'Sara', 'lname': 'Ahmed'}), 'Sara Ahmed');
      expect(userName(null), 'Unknown');
    });
  });

  group('statusColor', () {
    test('maps statuses to colours', () {
      expect(statusColor('active'), Colors.green);
      expect(statusColor('pending'), Colors.orange);
      expect(statusColor('blocked'), Colors.red);
      expect(statusColor('something-else'), Colors.blueGrey);
    });
  });

  test('formatPrice adds thousands separators', () {
    expect(formatPrice(2500000), 'Rs. 2,500,000');
    expect(formatPrice('1500'), 'Rs. 1,500');
    expect(formatPrice(null), 'Rs. 0');
  });
}
