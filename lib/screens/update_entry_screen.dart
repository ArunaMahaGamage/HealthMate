import 'package:flutter/material.dart';
import '../models/health_entry.dart';
import '../db/database_helper.dart';

class UpdateEntryScreen extends StatefulWidget {
  const UpdateEntryScreen({super.key, required this.healthEntry});

  final HealthEntry healthEntry;
  @override
  _UpdateEntryScreenState createState() => _UpdateEntryScreenState();
}

class _UpdateEntryScreenState extends State<UpdateEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final stepsController = TextEditingController();
  final caloriesController = TextEditingController();
  final waterController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    stepsController.text = widget.healthEntry.steps.toString();
    caloriesController.text = widget.healthEntry.calories.toString();
    waterController.text = widget.healthEntry.water.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Health Entry'),
      leading: BackButton(
        onPressed: () => {
          Navigator.pop(context,true)
        },
      ),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: stepsController,
                decoration: InputDecoration(labelText: 'Steps Walked'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter steps' : null,
              ),
              TextFormField(
                controller: caloriesController,
                decoration: InputDecoration(labelText: 'Calories Burned'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter calories' : null,
              ),
              TextFormField(
                controller: waterController,
                decoration: InputDecoration(labelText: 'Water Intake (ml)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter water intake' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save Entry'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final entry = HealthEntry(
                      id: widget.healthEntry.id,
                      date: DateTime.now().toString().substring(0, 10),
                      steps: int.parse(stepsController.text),
                      calories: int.parse(caloriesController.text),
                      water: int.parse(waterController.text),
                    );
                    int status = await DatabaseHelper.instance.updateEntry(entry);
                    if (status == 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Entry Saved!')),
                      );
                      Navigator.pop(context,true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Entry Not Saved!')),
                      );
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
      ),
    );
  }
}