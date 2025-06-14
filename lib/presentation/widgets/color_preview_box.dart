import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';

class ColorPreviewBox extends StatelessWidget {
  final Color color;
  final bool isFirst;
  final bool isLast;

  const ColorPreviewBox({
    super.key,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(8) : Radius.zero,
          bottomLeft: isFirst ? Radius.circular(8) : Radius.zero,
          topRight: isLast ? Radius.circular(8) : Radius.zero,
          bottomRight: isLast ? Radius.circular(8) : Radius.zero,
        ),
        border: Border(
          top: BorderSide(color: AppColors.lightDivider, width: 1),
          bottom: BorderSide(color: AppColors.lightDivider, width: 1),
          left: isFirst
              ? BorderSide(color: AppColors.lightDivider, width: 1)
              : BorderSide.none,
          right: BorderSide(color: AppColors.lightDivider, width: 1),
        ),
      ),
    );
  }
}
