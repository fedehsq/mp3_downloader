import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Song.dart';

Future<ExtendedSong> fetchSong(Song song) async {
  var response = await get(
      Uri.https("hub.ilill.li", "/", {"id" : '${song.id}'}));
  if (response.statusCode == 200) {
    // page must be load, await
    var json = jsonDecode(response.body);
    while (json['status'] != 'finished' && json['status'] != 'downloading') {
      response = await get(
          Uri.https("hub.ilill.li", "/", {"id" : '${song.id}'}));
      json = jsonDecode(response.body);
    }
    return ExtendedSong.fromJson(song, jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

class SongPage extends StatefulWidget {
  final Song song;

  const SongPage({Key key, this.song}) : super(key: key);

  @override
  _SongPageState createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  ExtendedSong fullSong;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.song.title),),
      body: FutureBuilder<ExtendedSong>(
          future: fetchSong(widget.song),
          builder: (context, AsyncSnapshot<ExtendedSong> snapshot) {
            if (snapshot.hasData) {
              fullSong = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(title: Text('Artist: ${fullSong.artist}')),
                    ListTile(title: Text('Time: ${fullSong.duration}')),
                    ListTile(title: Text('Bitrate: ${fullSong.bpm}')),
                    ListTile(title: Text('Size: ${fullSong.filesize}')),
                    ExpansionTile(title: Text('Lyrics'),
                        children: [
                         Text(fullSong.lyrics + "\n")
                        ]),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      floatingActionButton: ElevatedButton(
        child: Text('Download'),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)
                )
            )
        ), onPressed: () async {
        if (fullSong.urlDownload == null || fullSong.urlDownload.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Net error'),
            duration: const Duration(seconds: 1),
            action: SnackBarAction(
              label: 'RELOAD',
              onPressed: () {
                setState(() {
                });
              },
            ),
          ));
        } else {
          launch(fullSong.urlDownload);
        }
      },
      ),
    );
  }
}
