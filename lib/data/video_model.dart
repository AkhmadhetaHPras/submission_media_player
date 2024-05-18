// coverage:ignore-file
import 'dart:convert';

VideoModel videoModelFromJson(String str) =>
    VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  int? status;
  List<Video>? data;
  String? error;

  VideoModel({
    this.status,
    this.data,
    this.error,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Video>.from(json["data"]!.map((x) => Video.fromJson(x))),
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

class Video {
  String? title;
  String? creator;
  String? creatorPhoto;
  String? description;
  String? releaseDate;
  int? duration;
  String? sourceType;
  String? source;
  String? coverPath;
  int? viewsCount;

  Video({
    this.title,
    this.creator,
    this.creatorPhoto,
    this.description,
    this.releaseDate,
    this.duration,
    this.sourceType,
    this.source,
    this.coverPath,
    this.viewsCount,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        title: json["title"],
        creator: json["creator"],
        creatorPhoto: json["creator_photo"],
        description: json["description"],
        releaseDate: json["release_date"],
        duration: json["duration"],
        sourceType: json["source_type"],
        source: json["source"],
        coverPath: json["cover_path"],
        viewsCount: json["views_count"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "creator": creator,
        "creator_photo": creatorPhoto,
        "description": description,
        "release_date": releaseDate,
        "duration": duration,
        "source_type": sourceType,
        "source": source,
        "cover_path": coverPath,
        "views_count": viewsCount,
      };
}
