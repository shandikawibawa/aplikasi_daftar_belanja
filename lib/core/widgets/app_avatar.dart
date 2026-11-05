import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final String initials;

  const AppAvatar({
    super.key,
    this.size = 40,
    this.imageUrl,
    this.initials = 'SR',
  });

  @override
  Widget build(BuildContext context) {
    // Hindari request jaringan saat flutter test berjalan
    final isTesting = !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFEDD5),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: (!isTesting && imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFFED7AA),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF9A3412),
        size: 22,
      ),
    );
  }
}
