import 'package:flutter/material.dart';

class Awal extends StatefulWidget {
  _AwalState createState() => _AwalState();
}

class _AwalState extends State<Awal> {
  int num=0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          color: Colors.blue,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[Colors.blue, Colors.cyanAccent]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(num.toString(), style: TextStyle(fontSize: num.toDouble()),),
                RaisedButton(
                  child: Text('Tambah Bilangan'),
                  onPressed: press,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void press() {
    setState(() {
      num++;
    });
  }
}
