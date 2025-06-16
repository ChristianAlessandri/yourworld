import 'package:flutter/material.dart';
import 'package:yourworld/models/badge.dart';
import 'package:yourworld/presentation/widgets/badge_shape_painter.dart';

class TransportBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Set<String> usedVehicles;
  final List<String> allVehicles;
  final VoidCallback onTap;

  const TransportBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.usedVehicles,
    required this.allVehicles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final usedCount = usedVehicles.where((v) => allVehicles.contains(v)).length;
    final percent = usedCount / allVehicles.length;
    final level = getBadgeLevelByPercentage(percent);
    final color = getBadgeColor(level);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          CustomPaint(
            size: const Size(64, 80),
            painter: BadgeShapePainter(color: color, level: level),
            child: SizedBox(
              width: 64,
              height: 80,
              child: Center(
                child: Icon(icon, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
