import 'package:flutter/material.dart';
import '../../models/health_entry.dart';
import '../../db/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/health_provider.dart';

class AddEntryScreen extends ConsumerWidget {
  AddEntryScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final waterController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> loaderStatus = ref.watch(initialEntriesLoaderProvider);
    final List<HealthEntry> entries = ref.watch(healthEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add Health Entry')),
      body: loaderStatus.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading data: $err')),
          data: (_) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: stepsController,
                      decoration: InputDecoration(
                        labelText: 'Steps Walked', prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // Adjust padding as needed
                        child: Image.asset(
                          'assets/images/footstep.png',
                          // Replace with your image path
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain, // Adjust fit as needed
                        ),
                      ),),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Enter steps' : null,
                    ),
                    TextFormField(
                      controller: caloriesController,
                      decoration: InputDecoration(
                        labelText: 'Calories Burned', prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // Adjust padding as needed
                        child: Image.asset(
                          'assets/images/calories.png',
                          // Replace with your image path
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain, // Adjust fit as needed
                        ),
                      ),),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Enter calories' : null,
                    ),
                    TextFormField(
                      controller: waterController,
                      decoration: InputDecoration(
                        labelText: 'Water Intake (ml)', prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // Adjust padding as needed
                        child: Image.asset(
                          'assets/images/glassofwater.png',
                          // Replace with your image path
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain, // Adjust fit as needed
                        ),
                      ),),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v!.isEmpty
                          ? 'Enter water intake'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Save Entry'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final entry = HealthEntry(
                            date: DateTime.now().toString().substring(0, 10),
                            steps: int.parse(stepsController.text),
                            calories: int.parse(caloriesController.text),
                            water: int.parse(waterController.text),
                          );
                          try {
                            ref.read(healthEntriesProvider.notifier).addEntry(entry);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Entry Saved!')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Entry Not Saved!')),
                              );
                            }
                          }
                          stepsController.clear();
                          caloriesController.clear();
                          waterController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}