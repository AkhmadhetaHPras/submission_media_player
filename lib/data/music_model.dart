// coverage:ignore-file
import 'dart:convert';

MusicModel musicModelFromJson(String str) =>
    MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
  int? status;
  List<Music>? data;
  String? error;

  MusicModel({
    this.status,
    this.data,
    this.error,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Music>.from(json["data"]!.map((x) => Music.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "error": error,
      };
}

class Music {
  String? title;
  String? artist;
  String? albumName;
  String? releaseYear;
  int? duration;
  String? sourceType;
  String? source;
  String? coverPath;

  Music({
    this.title,
    this.artist,
    this.albumName,
    this.releaseYear,
    this.duration,
    this.sourceType,
    this.source,
    this.coverPath,
  });

  factory Music.fromJson(Map<String, dynamic> json) => Music(
        title: json["title"],
        artist: json["artist"],
        albumName: json["album_name"],
        releaseYear: json["release_year"],
        duration: json["duration"],
        sourceType: json["source_type"],
        source: json["source"],
        coverPath: json["cover_path"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "artist": artist,
        "album_name": albumName,
        "release_year": releaseYear,
        "duration": duration,
        "source_type": sourceType,
        "source": source,
        "cover_path": coverPath,
      };
}
