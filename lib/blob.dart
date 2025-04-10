import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final double rotation;
  final Color color;
  final double scale;
  final Widget widget;

  const Blob({
    super.key,
    required this.color,
    this.rotation = 0,
    this.scale = 1, required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 5,
              ),
            ],
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
          child: widget,
        ),
      ),
    );
  }
}
