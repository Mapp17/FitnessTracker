import 'package:flutter/material.dart';

class bmi_calculator extends StatefulWidget {
  const bmi_calculator({super.key});

  @override
  State<bmi_calculator> createState() => _bmi_calculatorState();
}

class _bmi_calculatorState extends State<bmi_calculator> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double? _bmi;
  String _message = "Enter your details to calculate BMI";
  Color _messageColor = Colors.grey;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);

    if (height != null && weight != null && height > 0 && weight > 0) {
      setState(() {
        // Height is in cm, convert to meters (h/100)^2
        _bmi = weight / ((height / 100) * (height / 100));
        if (_bmi! < 18.5) {
          _message = "Underweight";
          _messageColor = Colors.blueAccent;
        } else if (_bmi! < 25) {
          _message = "Normal Weight";
          _messageColor = Colors.greenAccent;
        } else if (_bmi! < 30) {
          _message = "Overweight";
          _messageColor = Colors.orangeAccent;
        } else {
          _message = "Obese";
          _messageColor = Colors.redAccent;
        }
      });
    } else {
      setState(() {
        _bmi = null;
        _message = "Please enter valid height and weight";
        _messageColor = Colors.redAccent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          "BMI CALCULATOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Extracted Input Card for Height
            BMIInputCard(
              title: "HEIGHT (cm)",
              controller: _heightController,
              icon: Icons.height,
              hint: "e.g. 175",
            ),
            const SizedBox(height: 20),
            // Extracted Input Card for Weight
            BMIInputCard(
              title: "WEIGHT (kg)",
              controller: _weightController,
              icon: Icons.fitness_center,
              hint: "e.g. 70",
            ),
            const SizedBox(height: 30),
            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "CALCULATE BMI",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Extracted Result Display
            BMIResultDisplay(
              bmi: _bmi,
              message: _message,
              messageColor: _messageColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// A custom reusable input card for BMI data entry.
class BMIInputCard extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData icon;
  final String hint;

  const BMIInputCard({
    super.key,
    required this.title,
    required this.controller,
    required this.icon,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.orangeAccent),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[700], fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom display box to show BMI results and category messages.
class BMIResultDisplay extends StatelessWidget {
  final double? bmi;
  final String message;
  final Color messageColor;

  const BMIResultDisplay({
    super.key,
    required this.bmi,
    required this.message,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (bmi != null) ...[
          const Text(
            "YOUR RESULT",
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bmi!.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          message.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: messageColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
