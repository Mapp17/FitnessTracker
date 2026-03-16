import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Home()
  ));

  String? name;
  // Using null-aware operator
  print(name ?? "No name provided");

}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text("Fitness Tracker",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
          color: Colors.white
        ),),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(

                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(30.0),

                color: Colors.cyan,
                child: Text("Day1 Target!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day2 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day3 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day4 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day5 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),

              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day6 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(30.0),
                color: Colors.cyan,
                child: Text("Day7 Target!",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
              ),
            ],
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Set",
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.cyan,
      ),
    );
  }
}




