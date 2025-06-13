import 'package:flutter/material.dart';

class VanityMetrics extends StatelessWidget {
  final String text;
  final String number;
  const VanityMetrics({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
