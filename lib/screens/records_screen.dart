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
  final SearchController searchController = SearchController();

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
          : Column(
            children: [
              SearchAnchor(
                searchController: searchController, builder: (BuildContext context, SearchController controller) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      leading: const Icon(Icons.search),
                      //trailing: const [Icon(Icons.mic)],
                      hintText: 'Search',
                      constraints: const BoxConstraints(
                        minHeight: 40.0, // Set your desired minimum height
                        maxHeight: 60.0, // Set your desired maximum height
                      ),
                      // When the user taps the bar, open the full view
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        // Optional: filter results as user types within the initial bar
                      },
                    ),
                  );
              }, suggestionsBuilder: (BuildContext context, SearchController controller) {
                final String query = controller.text.toLowerCase();
                final List<HealthEntry> filteredSuggestions = entries
                    .where((item) => item.date.toLowerCase().contains(query))
                    .toList();

                // Return the list of widgets to display as suggestions
                if (filteredSuggestions.isEmpty && query.isNotEmpty) {
                  return [
                    const ListTile(title: Text('No matching fruits found')),
                  ];
                }

                return filteredSuggestions.map((item) {
                  /*return ListTile(
                    title: Text(item.date),
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    onTap: () {
                      // When a suggestion is tapped:
                      // 1. Set the text field value to the selected item
                      controller.text = item.date;
                      // 2. Close the search view and return to the main screen
                      controller.closeView(item.date);
                      // 3. (Optional) Navigate to a details page or trigger final search
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected $item')),
                      );
                    },
                  );*/
                  return ListTile(
                    title: Text('Date: ${item.date}'),
                    subtitle: Text('Steps: ${item.steps}, Calories: ${item.calories}, Water: ${item.water} ml'),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.update, color: Colors.green),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => UpdateEntryScreen(healthEntry: item,),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await DatabaseHelper.instance.deleteEntry(item.id!);
                            _loadEntries();
                            setState(() {

                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
              ),
              SizedBox(height: 20.0),
              RichText(text: const TextSpan(
                text: 'Your Records',
                style: TextStyle(
                  // Apply specific styles here
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              )),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
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
              ),
            ],
          ),
    );
  }
}