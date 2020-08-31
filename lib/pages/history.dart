import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  _HistoryState createState() => _HistoryState();
  History({Key key}) : super(key: key);
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Center(
      	child: Text('ini History'),
      	),
    );
  }
}