import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate/db/database_helper.dart';
import '../models/health_entry.dart';

// 1. Provider for the DatabaseHelper instance
// We use the singleton instance provided by your class structure
final databaseHelperProvider = Provider((ref) => DatabaseHelper.instance);


// 2. StateNotifier to manage the current list of HealthEntries in memory
class HealthEntryNotifier extends StateNotifier<List<HealthEntry>> {
  final DatabaseHelper dbHelper;

  // Initialize with an empty list and inject the db helper
  HealthEntryNotifier(this.dbHelper) : super([]);

  // --- CRUD Operations that sync with the Database ---

  Future<void> refreshEntries() async {
    // This method is called by the FutureProvider initially
    state = await dbHelper.getAllEntries();
  }

  Future<void> addEntry(HealthEntry entry) async {
    final newId = await dbHelper.insertEntry(entry);
    // Create a copy of the entry with the actual ID from the DB
    final entryWithId = HealthEntry(
      id: newId,
      date: entry.date,
      steps: entry.steps,
      calories: entry.calories,
      water: entry.water,
    );
    // Update local state (UI rebuilds automatically)
    state = [entryWithId, ...state]; // Add new entry to the top of the list
  }

  Future<int> updateEntry(HealthEntry entry) async {
    int status =  await dbHelper.updateEntry(entry);
    // Update local state by mapping the list
    state = state.map((e) => e.id == entry.id ? entry : e).toList();

    return status;
  }

  Future<void> deleteEntry(int id) async {
    await dbHelper.deleteEntry(id);
    // Update local state by filtering the list
    state = state.where((e) => e.id != id).toList();
  }
}

// 3. The primary provider that UI widgets will watch
// This uses StateNotifierProvider and injects the dbHelper dependency
final healthEntriesProvider = StateNotifierProvider<HealthEntryNotifier, List<HealthEntry>>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return HealthEntryNotifier(dbHelper);
});

// 4. A FutureProvider for initial loading and error handling
// Widgets should typically watch this provider for initial loading state (loading/error/data)
final initialEntriesLoaderProvider = FutureProvider<void>((ref) async {
  final notifier = ref.read(healthEntriesProvider.notifier);
  await notifier.refreshEntries();
});
