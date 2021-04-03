import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'SearchPage.dart';

// https://suggestqueries.google.com/complete/search?client=youtube&ds=yt&callback=suggestionCallback&q=sfera
// https://expl.lillill.li/2/unknown?q=sfera LIST SFERA
// https://hub.ilill.li/?id=131740856&_=1617432012340 SELECT A SFERA SONG, SHOW TEXT
// https://il.ilill.li/force/T5DNZCxzwd/ // DOWNLOAD

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'MP3 downloader'),
    );
  }
}
