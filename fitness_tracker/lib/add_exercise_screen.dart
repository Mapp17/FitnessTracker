import 'package:flutter/material.dart';
import 'package:fitness_tracker/app_router.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _muscleGroup;
  int? totalVolume;

  @override
  void initState() {
    super.initState();
    _setsController.addListener(_updateVolume);
    _repsController.addListener(_updateVolume);
    _weightController.addListener(_updateVolume);
  }

  void _updateVolume() {
    int? sets = int.tryParse(_setsController.text);
    int? reps = int.tryParse(_repsController.text);
    double? weight = double.tryParse(_weightController.text);

    if (sets != null && reps != null && weight != null) {
      setState(() {
        totalVolume = (sets * reps * weight).toInt();
      });
    } else {
      setState(() {
        totalVolume = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, String hint, IconData icon,
      {String? suffix}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.orangeAccent),
      suffixText: suffix,
      labelStyle: const TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final exerciseData = {
        "name": _nameController.text.trim(),
        "sets": int.parse(_setsController.text),
        "reps": int.parse(_repsController.text),
        "weight": double.parse(_weightController.text),
        "muscleGroup": _muscleGroup
      };

      Navigator.pop(context, exerciseData);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Exercise '${exerciseData["name"]}' added!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "Add New Exercise",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  "Exercise Name",
                  "e.g Bench Press",
                  Icons.fitness_center,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Exercise name is required';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  if (value.trim().length > 50) {
                    return 'Name cannot exceed 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _setsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Sets", "e.g 3", Icons.repeat),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of sets is required';
                  }
                  final sets = int.tryParse(value);
                  if (sets == null) return 'Sets must be a whole number';
                  if (sets <= 0) return 'Sets must be greater than zero';
                  if (sets > 20) return 'Sets cannot exceed 20';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Reps", "e.g 10", Icons.format_list_numbered),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Number of reps is required';
                  }
                  final reps = int.tryParse(value);
                  if (reps == null) return 'Reps must be a whole number';
                  if (reps <= 0) return 'Reps must be greater than zero';
                  if (reps > 100) return 'Reps cannot exceed 100';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Weight", "e.g 20", Icons.fitness_center, suffix: "kg"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Weight is required';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) return 'Weight must be a valid number';
                  if (weight < 0) return 'Weight cannot be negative';
                  if (weight > 500) return 'Weight cannot exceed 500kg';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _muscleGroup,
                dropdownColor: Colors.grey[850],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Select Muscle Group...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Chest", child: Text("Chest")),
                  DropdownMenuItem(value: "Back", child: Text("Back")),
                  DropdownMenuItem(value: "Legs", child: Text("Legs")),
                  DropdownMenuItem(value: "Arms", child: Text("Arms")),
                  DropdownMenuItem(value: "Shoulders", child: Text("Shoulders")),
                  DropdownMenuItem(value: "Core", child: Text("Core")),
                ],
                onChanged: (value) {
                  setState(() {
                    _muscleGroup = value;
                  });
                },
                validator: (value) {
                  if (value == null) return "Please select a muscle group";
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  totalVolume == null
                      ? "Total Volume: --"
                      : "Total Volume: ${_setsController.text} × ${_repsController.text} × ${_weightController.text} = $totalVolume kg",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save Exercise"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
