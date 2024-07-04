import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:media_player/constants/assets_const.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/data/video_model.dart';

abstract class Repository {
  static List<Music> musics = [];
  static List<Video> videos = [];

  /// Load the music JSON file from the data source (musics.json).
  /// The data obtained is then inserted into the [musics] list.
  static Future<void> getMusics() async {
    try {
      String jsonString = await rootBundle.loadString(AssetsConsts.musicJson);

      Map<String, dynamic> data = json.decode(jsonString);

      final MusicModel response = MusicModel.fromJson(data);
      if (response.status == 200) {
        for (var data in response.data!) {
          musics.add(data);
        }
      } else {
        log(response.error ?? "unknown");
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /// Load the music JSON file from the data source (videos.json).
  /// The data obtained is then inserted into the [videos] list.
  static Future<void> getVideos() async {
    try {
      String jsonString = await rootBundle.loadString(AssetsConsts.videoJson);

      Map<String, dynamic> data = json.decode(jsonString);

      final VideoModel response = VideoModel.fromJson(data);
      if (response.status == 200) {
        for (var data in response.data!) {
          videos.add(data);
        }
      } else {
        log(response.error ?? "unknown");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
