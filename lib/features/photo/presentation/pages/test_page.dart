import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

class CoastExampleApp extends StatefulWidget {
  @override
  _CoastExampleAppState createState() => _CoastExampleAppState();
}

class _CoastExampleAppState extends State<CoastExampleApp> {
  final _beaches = [
    Beach(builder: (context) => Cadzand()),
    Beach(builder: (context) => Westkapelle()),
    Beach(builder: (context) => Zoutelande()),
  ];

  final _coastController = CoastController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Coast(
        beaches: _beaches,
        controller: _coastController,
        observers: [
          CrabController(),
        ],
      ),
    );
  }
}

class Cadzand extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Cadzand"),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(height: 1000, color: Colors.blue),
              Container(height: 1000, color: Colors.red),
              Positioned(
                top: 40,
                left: 40,
                child: Crab(
                  tag: "container",
                  child: Container(
                    color: Colors.green,
                    width: 80,
                    height: 60,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class Westkapelle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Westkapelle"),
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(height: 1000, color: Colors.blue),
              Container(height: 1000, color: Colors.red),
              Positioned(
                top: 80,
                right: 40,
                child: Crab(
                  tag: "container",
                  child: Container(
                    color: Colors.green,
                    width: 200,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class Zoutelande extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zoutelande"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(height: 1000, color: Colors.blue),
            Container(height: 1000, color: Colors.red),
            Positioned(
              bottom: 40,
              left: 20,
              child: Crab(
                tag: "container",
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
