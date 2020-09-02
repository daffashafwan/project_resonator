import 'package:flutter/material.dart';

class Learn extends StatefulWidget {
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar'),
      ),
      body: Center(
      	child: Text('ini belajar'),
      	),
    );
  }
}