import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Awal extends StatefulWidget {
  _AwalState createState() => _AwalState();
  Awal({Key key}) : super(key: key);
}

class _AwalState extends State<Awal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
      	child: Text('ini home'),
      	),
    );
  }
}