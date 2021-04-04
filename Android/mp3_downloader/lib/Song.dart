
class Song {
  final String title;
  final int id;
  final String duration;
  final int bpm;
  Song(this.title, this.id, this.duration, this.bpm);

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      json['title'],
      json['id'],
      json['duration'],
      json['bpm']
    );
  }
}

class ExtendedSong extends Song {
  final String artist;
  final String filename;
  final String filesize;
  final String lyrics;
  final String urlDownload;
  ExtendedSong(Song song,
      this.artist, this.filename, this.filesize, this.urlDownload, this.lyrics) :
        super(song.title, song.id, song.duration, song.bpm);

  factory ExtendedSong.fromJson(Song s, Map<String, dynamic> json) {
    return ExtendedSong(
      s,
      json['artist'],
      json['filename'],
      json['filesize'] ?? 'Unknown',
      json['force'],
      json['lyrics'] ?? 'Not available'
    );
  }

}