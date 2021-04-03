import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mp3_downloader/SongPage.dart';
import 'Song.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool search = false;
  String query = "";

  Future<List<Song>> fetchSongs(String item) async {
    final response = await get(
        Uri.https("expl.lillill.li", "/2/unknown", {"q" : item}));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Song> songs = [];
      for (var s in jsonDecode(response.body)) {
        songs.add(Song.fromJson(s));
      }
      return songs;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: search ? IconButton(icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  setState(() {
                    query = "";
                    search = !search;
                  }))
              : null,
          actions: !search ? [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    setState(() {
                      search = !search;
                    })
            )
          ] : null,
          title: !search ? Text(widget.title) :
          TextField(
            onSubmitted: (value) =>
                setState(() {
                  query = value;
                }),
            autofocus: true,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Song, Artist, Album...",
            ),
          )
      ),
      body: query.isEmpty ? Center(
        child: Text(
          'Start looking for a song!',
        ),
      ) : FutureBuilder<List<Song>>(
          future: fetchSongs(query),
          builder: (context, AsyncSnapshot<List<Song>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SongPage(song: snapshot.data[index])),
                      ),
                      trailing: Icon(Icons.chevron_right),
                      leading: Icon(Icons.music_note),
                      title: Text(snapshot.data[index].title),
                      subtitle: Text("Time: " + snapshot.data[index].duration
                          + "   -   Bitrate: " + '${snapshot.data[index].bpm}'),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}
