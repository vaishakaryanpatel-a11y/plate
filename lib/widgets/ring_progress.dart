import 'package:flutter/material.dart';

class RingProgress extends StatelessWidget {
  const RingProgress({
    super.key,
    required this.value,
    required this.label,
    required this.caption,
  });

  final double value;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0.0, 1.0);
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 14,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.12),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.headlineMedium),
              Text(caption),
            ],
          ),
        ],
      ),
    );
  }
}
