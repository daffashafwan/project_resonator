import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Learn extends StatefulWidget {
  _LearnState createState() => _LearnState();
  Learn({Key key}) : super(key: key);
}

class Album {
  final int id;
  final String url;

  Album({this.id, this.url});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      url: json['transkrip']['alternative'][0]['transcript'],
    );
  }
}

class _LearnState extends State<Learn> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;
  Future<YoutubePlayer> _futureYoutube;
  String assett = 'assets/1.svg';
  Widget svg = new SvgPicture.asset('assets/1.svg');
  TextStyle _style = TextStyle(fontSize: 20);

  Future<Album> createAlbum(String title) async {
    final response = await http.post(
      Uri.parse(
          'https://us-central1-avian-direction-321000.cloudfunctions.net/lidm-backend/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'url': title,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON
      print(jsonDecode(response.body));
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<YoutubePlayer> createVideo(String videoID) async {
    YoutubePlayerController _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return YoutubePlayer(
      controller: _youtubePlayerController,
      showVideoProgressIndicator: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView(itemExtent: 200, children: <Widget>[
            Card(
                margin: EdgeInsets.zero,
                color: Color.fromARGB(255, 87, 195, 130),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          title: Text('Youtube \nTranskrip',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))),
                      TextField(
                        textInputAction: TextInputAction.go,
                        maxLines: 1,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 1),
                            border: OutlineInputBorder(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                            ),
                            hintText: 'Masukkan URL'),
                        controller: _controller,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = createAlbum(_controller.text);
                            _futureYoutube = createVideo(YoutubePlayer.convertUrlToId(_controller.text));
                          });
                        },
                        child: const Text('Create Data'),
                      ),
                    ],
                  ),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
              child: Card(
                child: Container(
                  color: Colors.blue,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: FutureBuilder<YoutubePlayer>(
                        future: _futureYoutube,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data;
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return const CircularProgressIndicator();
                        },
                      )),
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
                      child: FutureBuilder<Album>(
                        future: _futureAlbum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.url);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          return const CircularProgressIndicator();
                        },
                      )),
                ),
              ),
            ),
          ])),
    );
  }
}