import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Learn extends StatefulWidget {
  _LearnState createState() => _LearnState();
  Learn({Key key}) : super(key: key);
}

class _LearnState extends State<Learn> {
	String assett = 'assets/1.svg';
Widget svg = new SvgPicture.asset(
  'assets/1.svg'
);
	TextStyle _style = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Belajar'),
      ),
      body: Center(
      	child: ListView (
      		itemExtent: 200,
		    children: <Widget>[
		    	Padding(
			        padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
			        child: Card(
			        	child: ListTile(
            title: Text('Belajar Membaca Bahasa Isyarat - Tingkat Dasar', style: TextStyle(fontSize: 25)),
            subtitle: Text('oleh Universitas Muhammadiyah Malang'),
            
          ),
			          
			        ),
			      ),
		    	Padding(
			        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
			        child: Card(
			          child: Container(
			          	color: Colors.white,
			          	child: Padding(
			          		padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
			          		child: Stack(
			          			children: <Widget>[
				          			Positioned(
				          				child: Image.asset(
						            'assets/1.png',
						          	),	
				          			),
				          			
						          	Positioned(
						          		bottom: 0,
						          		left: 0,
						          		child: Text('Bismillah Coba', style: TextStyle(fontSize: 40))
						          	),
						          	
			          			],
			          		),

			          		
			          	),
			            
			          ),
			        ),
			      ),
		    	Padding(
			        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
			        child: Card(
			          child: Container(
			          	color: Colors.blue,
			          	child: Padding(
			          		padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
			          		child: Text('Belajar Membaca Bahasa Isyarat', style: TextStyle(color: Colors.white, fontSize: 30)),
			          	),
			            
			          ),
			        ),
			      ),

		        
		    ]
		)
      	),
    );
  }
}