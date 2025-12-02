import 'package:flutter/material.dart';
import '../../models/health_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/health_provider.dart';

class UpdateEntryScreen extends ConsumerWidget {
  UpdateEntryScreen({super.key, required this.healthEntry});
  final _formKey = GlobalKey<FormState>();
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final waterController = TextEditingController();


  final HealthEntry healthEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    stepsController.text = healthEntry.steps.toString();
    caloriesController.text = healthEntry.calories.toString();
    waterController.text = healthEntry.water.toString();

    final AsyncValue<void> loaderStatus = ref.watch(initialEntriesLoaderProvider);
    final List<HealthEntry> entries = ref.watch(healthEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Update Health Entry'),
        leading: BackButton(
          onPressed: () => {
            Navigator.pop(context,true)
          },
        ),),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter steps';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only digits.';
                        }
                        return null; // Return null if valid
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter calories';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only digits.';
                        }
                        return null; // Return null if valid
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter water intake';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Please enter only digits.';
                        }
                        return null; // Return null if valid
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Save Entry'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final entry = HealthEntry(
                            id: healthEntry.id,
                            date: DateTime.now().toString().substring(0, 10),
                            steps: int.parse(stepsController.text),
                            calories: int.parse(caloriesController.text),
                            water: int.parse(waterController.text),
                          );
                          //int status = await DatabaseHelper.instance.updateEntry(entry);
                          try {
                            ref.read(healthEntriesProvider.notifier).updateEntry(entry);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Entry Saved!')),
                              );
                              Navigator.pop(context, true);
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
          }
      ),
    );
  }
}
