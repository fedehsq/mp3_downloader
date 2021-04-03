import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Song.dart';


Future<ExtendedSong> fetchSong(Song song) async {
  final response = await get(
      Uri.https("hub.ilill.li", "/", {"id" : '${song.id}'}));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
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
                          fullSong.lyrics != null ? Text(
                              fullSong.lyrics + "\n") : Text("")
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
        if (await canLaunch(fullSong.urlDownload)) {
          await launch(fullSong.urlDownload);
        } else {
          throw "Could not launch url";
        }
      },

      ),
    );
  }
}
