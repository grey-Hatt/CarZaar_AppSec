/// Formats a number as a Pakistani-rupee price, e.g. `Rs. 2,500,000`.
String formatPrice(num value) {
  final digits = value.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'Rs. ${value < 0 ? '-' : ''}$buffer';
}

/// Keeps only the digits of a phone number (needed for wa.me links).
String digitsOnly(String input) => input.replaceAll(RegExp(r'[^0-9]'), '');

/// Very small e-mail sanity check used by the forms.
bool looksLikeEmail(String input) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(input.trim());
