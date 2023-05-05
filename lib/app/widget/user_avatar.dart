import 'dart:math';

import 'package:flutter/material.dart';

class CircularUserAvatar extends StatelessWidget {
  final String fullName;
  final double size;

  const CircularUserAvatar({
    Key? key,
    required this.fullName,
    this.size = 100.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initials = fullName
        .split(" ")
        .map((name) => name.isNotEmpty ? name[0].toUpperCase() : '')
        .join();

    final color = _getRandomColor(context);

    return CircleAvatar(
      backgroundColor: color,
      radius: size / 2,
      child: Text(
        initials,
        style: TextStyle(
          color: _getTextColorShade(color),
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }

  Color _getRandomColor(BuildContext context) {
    final random = Random();
    final colors = Theme.of(context).brightness == Brightness.light
        ? [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ]
        : [
      Colors.orange,
      Colors.yellow,
      Colors.pink,
      Colors.deepPurple,
      Colors.cyan,
    ];

    return colors[random.nextInt(colors.length)][random.nextInt(9) * 100]!;
  }

  Color _getTextColorShade(Color color) {
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}