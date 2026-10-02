import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Shows a car photo stored as a base64 string, with a placeholder icon
/// when there is no image (or the stored value is not a valid image).
class CarImage extends StatefulWidget {
  final String image;
  final double height;

  const CarImage({super.key, required this.image, this.height = 135});

  @override
  State<CarImage> createState() => _CarImageState();
}

class _CarImageState extends State<CarImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = _decode(widget.image);
  }

  @override
  void didUpdateWidget(covariant CarImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.image != widget.image) _bytes = _decode(widget.image);
  }

  // Decoded once instead of on every rebuild (keeps lists smooth).
  Uint8List? _decode(String value) {
    if (value.isEmpty) return null;
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(Icons.directions_car, size: 55, color: Colors.black38);

    return Container(
      height: widget.height,
      width: double.infinity,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(14),
      ),
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
