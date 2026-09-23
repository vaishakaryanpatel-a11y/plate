import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'scan_screen.dart';
import '../widgets/ring_progress.dart';
import '../widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Good morning, ${state.profile.name}', style: Theme.of(context).textTheme.headlineSmall),
          Text(today),
          const SizedBox(height: 20),
          SectionCard(
            child: Column(
              children: [
                const RingProgress(value: 0, label: '0 kcal', caption: 'of 2200 kcal'),
                const SizedBox(height: 12),
                Text('${state.calories} calories logged today'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _MetricCard(icon: Icons.water_drop_outlined, label: 'Water', value: '${state.waterCount}/8 cups')),
              const SizedBox(width: 12),
              Expanded(child: _MetricCard(icon: Icons.directions_walk, label: 'Steps', value: '${state.steps}')),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Row(
              children: [
                const Expanded(child: Text('Track a glass of water')),
                IconButton(
                  onPressed: state.addWater,
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Add water',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text("Today's meals", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (state.meals.isEmpty)
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No meals logged yet. Your meals will appear here.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ScanScreen()),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan a plate'),
                  ),
                ],
              ),
            )
          else
            ...state.meals.map((meal) => ListTile(title: Text(meal.name), trailing: Text('${meal.calories} kcal'))),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
