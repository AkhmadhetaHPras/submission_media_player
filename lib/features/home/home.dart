import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/data/repository.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/components/title_section.dart';
import 'package:media_player/shared_components/app_bar/custom_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Music> musics = [];
  List<Video> videos = [];

  @override
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Repository.getMusics();
    await Repository.getVideos();
    setState(() {
      musics = Repository.musics;
      videos = Repository.videos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.black222222,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleSection(title: "Music Collections"),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  key: const Key('music_list_view'),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    final item = musics[i];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 15 : 0,
                        right: i == musics.length - 1 ? 15 : 0,
                      ),
                      child: CoverMusicCard(music: item),
                    );
                  },
                  separatorBuilder: (_, i) => const SizedBox(width: 20),
                  itemCount: musics.length,
                ),
              ),
              const SizedBox(height: 10),
              const TitleSection(title: "Videos"),
              ListView.separated(
                key: const Key('video_list_view'),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: videos.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(bottom: i == 4 ? 16 : 0),
                  child: CoverVideoCard(video: videos[i]),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
