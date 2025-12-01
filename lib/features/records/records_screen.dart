import 'package:flutter/material.dart';
import '../../models/health_entry.dart';
import '../update/update_entry_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/health_provider.dart';

class RecordsScreen extends ConsumerWidget {
  RecordsScreen({super.key});
  final SearchController searchController = SearchController();

  // Function to show the AlertDialog
  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you need to delete this item?'),
                Text('This action cannot be undone.', style: TextStyle(
                  fontSize: 10.0, // Sets the font size to 24 logical pixels
                ),),
              ],
            ),
          ),
          actions: <Widget>[
            // --- NO Button ---
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // This closes the dialog and passes 'false' (or null) back to showDialog
                Navigator.of(context).pop(false);
              },
            ),
            // --- YES Button ---
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // This closes the dialog and passes 'true' back to showDialog
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showUpdateConfirmationDialog(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you need to update this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            // --- NO Button ---
            TextButton(
              child: const Text('No'),
              onPressed: () {
                // This closes the dialog and passes 'false' (or null) back to showDialog
                Navigator.of(context).pop(false);
              },
            ),
            // --- YES Button ---
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // This closes the dialog and passes 'true' back to showDialog
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showActionFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> loaderStatus = ref.watch(initialEntriesLoaderProvider);
    final List<HealthEntry> entries = ref.watch(healthEntriesProvider);
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
                            try {
                              ref.read(healthEntriesProvider.notifier).deleteEntry(item.id!);
                              _showActionFeedback(context, 'Item deleted successfully!');
                            } catch (e) {
                              _showActionFeedback(context, 'Item deleted Unsuccessful.');
                            }
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
                          final bool? update = await _showUpdateConfirmationDialog(context);
                          if (update == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    UpdateEntryScreen(healthEntry: e,),
                              ),
                            );
                          } else {
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final bool? delete = await _showDeleteConfirmationDialog(context);

                          if (delete == true) {
                            try {
                              ref.read(healthEntriesProvider.notifier).deleteEntry(e.id!);
                              _showActionFeedback(context, 'Item deleted successfully!');
                            } catch (e) {
                              _showActionFeedback(context, 'Item deleted Unsuccessful.');
                            }
                          } else {
                            _showActionFeedback(context, 'Deletion cancelled.');
                          }
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