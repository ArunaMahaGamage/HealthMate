import 'package:flutter/material.dart';
import '../../models/health_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/health_provider.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int totalSteps = 0;
    int totalCalories = 0;
    int totalWater = 0;

    final AsyncValue<void> loaderStatus = ref.watch(initialEntriesLoaderProvider);
    final List<HealthEntry> entries = ref.watch(healthEntriesProvider);

    totalSteps = entries.fold(0, (sum, e) => sum + e.steps);
    totalCalories = entries.fold(0, (sum, e) => sum + e.calories);
    totalWater = entries.fold(0, (sum, e) => sum + e.water);

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('💚 HealthMate Dashboard 🌿')),),
      body: loaderStatus.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading data: $err')),
        data: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SummaryCard(title: 'Steps Walked',
                  value: '$totalSteps',
                  image: 'assets/images/footstep.png',),
                SummaryCard(title: 'Calories Burned',
                  value: '$totalCalories kcal',
                  image: 'assets/images/calories.png',),
                SummaryCard(title: 'Water Intake',
                  value: '${(totalWater / 1000).toStringAsFixed(1)} L',
                  image: 'assets/images/glassofwater.png',),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String image;

  const SummaryCard({required this.title, required this.value, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Image.asset(image,width: 100.0, height: 100.0, fit: BoxFit.cover,),
          ListTile(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(value, style: TextStyle(fontSize: 18, color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
