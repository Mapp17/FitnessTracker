import 'package:fitness_tracker/BMI.dart';
import 'package:fitness_tracker/cycling.dart';
import 'package:fitness_tracker/running.dart';
import 'package:fitness_tracker/weights.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/main.dart';

class Bottom_Navigation extends StatefulWidget {
  const Bottom_Navigation({super.key});

  @override
  State<Bottom_Navigation> createState() => _Bottom_NavigationState();
}

class _Bottom_NavigationState extends State<Bottom_Navigation> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPage = index;
        });

        if(index == 0)
          {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()));

          }
        if(index == 1)
        {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeightWorkouts()));

        }
        if(index == 2)
        {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const bmi_calculator()));

        }
        if(index == 3)
        {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Running()));

        }
        if(index == 4)
        {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Cycling()));

        }

      },
      indicatorColor: Colors.orange.withOpacity(0.2),
      selectedIndex: currentPage,
      backgroundColor: Colors.grey[400],
      destinations: const <Widget>[
        NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
        ),
        NavigationDestination(
            icon: Icon(Icons.fitness_center_rounded),
            label: "Workouts"),
        NavigationDestination(
            icon: Icon(Icons.scale),
            label: "BMI"),
        NavigationDestination(
            icon: Icon(Icons.directions_run),
            label: "Run"),

        NavigationDestination(
            icon: Icon(Icons.directions_bike),
            label: "Cycling"),
      ],
    );
  }
}
