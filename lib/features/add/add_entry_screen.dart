import 'package:flutter/material.dart';
import '../../models/health_entry.dart';
import '../../db/database_helper.dart';

class AddEntryScreen extends StatefulWidget {
  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final waterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Health Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: stepsController,
                decoration: InputDecoration(labelText: 'Steps Walked', prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Image.asset(
                    'assets/images/footstep.png', // Replace with your image path
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
                decoration: InputDecoration(labelText: 'Calories Burned', prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Image.asset(
                    'assets/images/calories.png', // Replace with your image path
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
                decoration: InputDecoration(labelText: 'Water Intake (ml)', prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                  child: Image.asset(
                    'assets/images/glassofwater.png', // Replace with your image path
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain, // Adjust fit as needed
                  ),
                ),),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter water intake' : null,
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
                    await DatabaseHelper.instance.insertEntry(entry);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Entry Saved!')),
                    );
                    stepsController.clear();
                    caloriesController.clear();
                    waterController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}