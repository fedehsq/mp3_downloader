import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'Song.dart';

// https://hub.ilill.li/?id=131740860 SELECTED A SFERA SONG, SHOW TEXT
// https://il.ilill.li/force/T5DNZCxzwd/ // DOWNLOAD

Future<ExtendedSong> fetchSong(Song song) async {
  print(song.id);
  String url = "hub.ilill.li/?id=${song.id}";
  final response = await get(
      Uri.https("hub.ilill.li", "/", {"id" : song.id}));
  print(response.body);

  if (response.statusCode == 200) {
    print(response.body);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ExtendedSong.fromJson(song, jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

class SongPage extends StatelessWidget {
  final Song song;

  const SongPage({Key key, this.song}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(song.title),),
        body: FutureBuilder<ExtendedSong>(
            future: fetchSong(song),
            builder: (context, AsyncSnapshot<ExtendedSong> snapshot) {
              if (snapshot.hasData) {
                ExtendedSong song = snapshot.data;
                return Column(
                  children: [
                    ListTile(title: Text('Artist: ${song.artist}')),
                    ListTile(title: Text('Time: ${song.duration}')),
                    ListTile(title: Text('Bitrate: ${song.bpm}')),
                    ExpansionTile(title: Text('Lyrics'),
                        children: [
                          Text(song.lyrics)
                        ]),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
        ),
        floatingActionButton: MaterialButton(child: Text('Download'),
          onPressed: () {  },),
    );
  }
}
