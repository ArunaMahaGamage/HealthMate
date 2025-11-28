import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/health_entry.dart';
import '../screens/update_entry_screen.dart';

class RecordsScreen extends StatefulWidget {
  @override
  _RecordsScreenState createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<HealthEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    entries = await DatabaseHelper.instance.getAllEntries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loadEntries();
    });
    return Scaffold(
      appBar: AppBar(title: Text('Health Records')),
      body: entries.isEmpty
          ? Center(child: Text('No records found'))
          : ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final e = entries[index];
          return ListTile(
            title: Text('Date: ${e.date}'),
            subtitle: Text('Steps: ${e.steps}, Calories: ${e.calories}, Water: ${e.water} ml'),
            trailing: Wrap(
              children: [
                IconButton(
                  icon: Icon(Icons.update, color: Colors.green),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => UpdateEntryScreen(healthEntry: e,),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteEntry(e.id!);
                    _loadEntries();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}