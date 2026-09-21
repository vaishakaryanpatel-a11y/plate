import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../widgets/section_card.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Water', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('${state.waterCount} of ${state.profile.waterGoal} cups today'),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              children: [
                Icon(Icons.water_drop, size: 72, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 12),
                Text('${state.waterCount}', style: Theme.of(context).textTheme.displaySmall),
                const Text('cups logged'),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: state.addWater,
                  icon: const Icon(Icons.add),
                  label: const Text('Add a cup'),
                ),
                TextButton(
                  onPressed: state.waterCount == 0 ? null : state.undoWater,
                  child: const Text('Undo last cup'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: state.waterCount == 0 ? null : state.resetWaterToday,
            child: const Text('Reset today'),
          ),
        ],
      ),
    );
  }
}
