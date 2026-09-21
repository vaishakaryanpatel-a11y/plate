import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/section_card.dart';

class StepsScreen extends StatelessWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = context.watch<AppState>().steps;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Steps', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Your activity today', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text('$steps', style: Theme.of(context).textTheme.displaySmall),
                const Text('steps today'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionCard(
            child: Text(
              'PlateWise reads your device step counter after activity permission is granted. '
              'If your device has no step sensor, this value remains zero.',
            ),
          ),
        ],
      ),
    );
  }
}
