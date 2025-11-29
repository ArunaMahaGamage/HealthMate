import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/health_entry.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalSteps = 0;
  int totalCalories = 0;
  int totalWater = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTodaySummary();
  }

  Future<void> _loadTodaySummary() async {
    final db = DatabaseHelper.instance;
    final entries = await db.getAllEntries();

    final today = DateTime.now().toString().substring(0, 10);
    final todayEntries = entries.where((e) => e.date == today);

    setState(() {
      totalSteps = todayEntries.fold(0, (sum, e) => sum + e.steps);
      totalCalories = todayEntries.fold(0, (sum, e) => sum + e.calories);
      totalWater = todayEntries.fold(0, (sum, e) => sum + e.water);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('💚 HealthMate Dashboard 🌿')),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SummaryCard(title: 'Steps Walked', value: '$totalSteps', image: 'assets/images/footstep.png',),
            SummaryCard(title: 'Calories Burned', value: '$totalCalories kcal', image: 'assets/images/calories.png',),
            SummaryCard(title: 'Water Intake', value: '${(totalWater / 1000).toStringAsFixed(1)} L', image: 'assets/images/glassofwater.png',),
          ],
        ),
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
