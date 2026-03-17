import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
      home: const Home()
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  final List<String> exercises = [
    "Running",
    "Cycling",
    "Workouts",
    "Flexibility"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Fitness Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Colors.grey[800],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hello, Mapps!",
              style: TextStyle(
                color: Colors.grey[400],
                fontStyle: FontStyle.italic,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20.0),
            // Featured Workout Banner
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Featured Workout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Full Body HIIT \n30 Minutes • Advanced",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Start",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            Text(
              "Popular Exercises",
              style: TextStyle(
                color: Colors.grey[400],
                fontStyle: FontStyle.normal,
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;
                  if (constraints.maxWidth >= 900) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth >= 600) {
                    crossAxisCount = 3;
                  } else {
                    crossAxisCount = 2;
                  }
                  
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.2,
                    ),

                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Colors.orangeAccent, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),

                        child: Text(
                          index == 0 ? "Daily Challenge" : " ${exercises[index]}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),


      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        indicatorColor: Colors.orange,
        selectedIndex: currentPage,
        backgroundColor: Colors.grey[400],
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.fitness_center_rounded),
              label: "Workouts"),
          NavigationDestination(
              icon: Icon(Icons.directions_run),
              label: "Run"),
          NavigationDestination(
              icon: Icon(Icons.directions_bike),
              label: "Cycling"),
        ],
      ),
    );
  }
}
