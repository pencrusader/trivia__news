import 'package:flutter/material.dart';

class HealthBadge extends StatelessWidget {
  final bool isHealthy;
  final double dotSize;

  const HealthBadge({
    super.key,
    required this.isHealthy,
    this.dotSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHealthy ? Colors.green : Colors.red,
            boxShadow: [
              BoxShadow(
                color: (isHealthy ? Colors.green : Colors.red).withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isHealthy ? 'Pi OK' : 'Pi Down',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isHealthy ? Colors.green[700] : Colors.red[700],
          ),
        ),
      ],
    );
  }
}
