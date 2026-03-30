import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/exercise_search_provider.dart';

class ExerciseSearchScreen extends StatefulWidget {
  const ExerciseSearchScreen({super.key});

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  // Filter states
  String? _selectedMuscle;
  String? _selectedDifficulty;
  String? _selectedType;

  final List<String> _muscles = [
    'abdominals', 'abductors', 'adductors', 'biceps', 'calves', 'chest', 
    'forearms', 'glutes', 'hamstrings', 'lats', 'lower_back', 'middle_back', 
    'neck', 'quadriceps', 'traps', 'triceps'
  ];

  final List<String> _difficulties = ['beginner', 'intermediate', 'expert'];
  
  final List<String> _types = [
    'cardio', 'olympic_weightlifting', 'plyometrics', 'powerlifting', 
    'strength', 'stretching', 'strongman'
  ];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    context.read<ExerciseSearchProvider>().searchExercises(
      name: _searchController.text,
      muscle: _selectedMuscle,
      difficulty: _selectedDifficulty,
      type: _selectedType,
    );
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _triggerSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseSearchProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "EXERCISE EXPLORER",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Text Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Colors.orangeAccent),
                      onPressed: provider.isLoading ? null : _triggerSearch,
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filters Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterDropdown(
                        hint: "Muscle",
                        value: _selectedMuscle,
                        items: _muscles,
                        onChanged: (val) {
                          setState(() => _selectedMuscle = val);
                          _triggerSearch();
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterDropdown(
                        hint: "Difficulty",
                        value: _selectedDifficulty,
                        items: _difficulties,
                        onChanged: (val) {
                          setState(() => _selectedDifficulty = val);
                          _triggerSearch();
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterDropdown(
                        hint: "Type",
                        value: _selectedType,
                        items: _types,
                        onChanged: (val) {
                          setState(() => _selectedType = val);
                          _triggerSearch();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_all, color: Colors.redAccent),
                        onPressed: () {
                          setState(() {
                            _selectedMuscle = null;
                            _selectedDifficulty = null;
                            _selectedType = null;
                            _searchController.clear();
                          });
                          context.read<ExerciseSearchProvider>().clearResults();
                        },
                        tooltip: "Reset Filters",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results Area
          Expanded(
            child: Consumer<ExerciseSearchProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.orangeAccent),
                        SizedBox(height: 16),
                        Text("Fetching exercises...", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                if (provider.hasError) {
                  return _buildErrorState(provider);
                }

                if (provider.hasResults) {
                  return _buildResultsList(provider);
                }

                return _buildEmptyState(provider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: value != null ? Colors.orangeAccent : Colors.grey[700]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          dropdownColor: Colors.grey[850],
          icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text("All $hint" + (hint.endsWith('s') ? '' : 's')),
            ),
            ...items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item.replaceAll('_', ' ').toUpperCase()),
              );
            }).toList(),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildErrorState(ExerciseSearchProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 80, color: Colors.redAccent),
            const SizedBox(height: 20),
            Text(
              provider.errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => provider.retry(),
              icon: const Icon(Icons.refresh),
              label: const Text("Tap to Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(ExerciseSearchProvider provider) {
    final results = provider.searchResults;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[850]!.withAlpha(100),
          child: Text(
            '${results.length} exercises found',
            style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final exercise = results[index];
              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ExpansionTile(
                  title: Text(
                    exercise.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildChip(exercise.muscle, Colors.orangeAccent),
                        _buildChip(exercise.type, Colors.blueAccent),
                        _buildChip(exercise.difficulty, Colors.greenAccent),
                      ],
                    ),
                  ),
                  iconColor: Colors.orangeAccent,
                  collapsedIconColor: Colors.grey,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fitness_center, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                "Equipment: ${exercise.equipment.replaceAll('_', ' ')}",
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey, height: 24),
                          const Text(
                            "Instructions:",
                            style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            exercise.instructions,
                            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ExerciseSearchProvider provider) {
    bool hasActiveFilters = _selectedMuscle != null || 
                           _selectedDifficulty != null || 
                           _selectedType != null || 
                           _searchController.text.isNotEmpty;

    if (hasActiveFilters) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey[800]),
              const SizedBox(height: 16),
              const Text(
                'No exercises found matching your criteria.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try broadening your search or resetting filters.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search, size: 100, color: Colors.grey[800]),
          const SizedBox(height: 20),
          const Text(
            "Find your next challenge",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Use filters or search by name above",
            style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }
}
