import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Penyimpanan extends StatefulWidget {
  _PenyimpananState createState() => _PenyimpananState();
  Penyimpanan({Key key}) : super(key: key);
}

class _PenyimpananState extends State<Penyimpanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penyimpanan'),
      ),
      body: Center(
      	child: Text('ini Penyimpanan'),
      	),
    );
  }
}