import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/components/music_cover_image.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:media_player/shared_components/app_bar/back_button_app_bar_leading.dart';
import 'package:media_player/shared_components/app_bar/custom_app_bar.dart';
import 'package:media_player/shared_components/dot_divider.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => MusicPlayerState();
}

@visibleForTesting
class MusicPlayerState extends State<MusicPlayer> {
  late Music music;
  AudioPlayer newPlayer = AudioPlayer();
  bool play = false;
  Duration duration = const Duration();
  Duration position = const Duration();
  Source? source;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    music = ModalRoute.of(context)!.settings.arguments as Music;
    initPlayerState();
  }

  initPlayerState() {
    setState(() {
      source = music.sourceType == "local"
          ? AssetSource(
              music.source!.replaceFirst("assets/", ""),
            )
          : UrlSource(music.source!);
    });
    newPlayer.setSource(source!).then((value) async {
      final dur = await newPlayer.getDuration() ?? const Duration();
      setState(() {
        duration = dur;
      });
    });
  }

  void initPlayer() async {
    newPlayer.onPositionChanged.listen((pos) {
      setState(() {
        position = pos;
      });
      if (pos.inSeconds.toDouble() == duration.inSeconds.toDouble()) {
        setState(() {
          play = false;
        });
      }
    });
  }

  Future<void> playAudio() async {
    newPlayer.setVolume(1.0);
    newPlayer.play(
      source!,
      mode: PlayerMode.mediaPlayer,
    );
    setState(() {
      play = true;
    });
  }

  Future<void> pauseAudio() async {
    newPlayer.pause();
    setState(() {
      play = false;
    });
  }

  void seekToSecond(double value) {
    Duration newDuration = Duration(seconds: value.toInt());

    newPlayer.seek(newDuration);
  }

  Future<void> playPause() async {
    if (play) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  @override
  void dispose() {
    super.dispose();
    newPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.black222222,
      appBar: const CustomAppBar(leading: BackButtonAppBarLeading()),
      body: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
            child: MusicCoverImage(
                sourceType: music.sourceType!, cover: music.coverPath!),
          ),
          Text(
            music.title!,
            style: MainTextStyle.poppinsW600
                .copyWith(fontSize: 18, color: MainColor.whiteF2F0EB),
          ),
          Text(
            music.artist!,
            style: MainTextStyle.poppinsW400
                .copyWith(fontSize: 12, color: MainColor.whiteF2F0EB),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                music.albumName!,
                style: MainTextStyle.poppinsW400
                    .copyWith(fontSize: 13, color: MainColor.whiteFFFFFF),
              ),
              const DotDivider(),
              Text(
                music.releaseYear!,
                style: MainTextStyle.poppinsW400
                    .copyWith(fontSize: 13, color: MainColor.whiteFFFFFF),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Slider(
            value: position.inSeconds.toDouble(),
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            thumbColor: MainColor.purple5A579C,
            activeColor: MainColor.purple5A579C,
            onChanged: seekToSecond,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TimeDisplay(
              position: position,
              duration: duration,
            ),
          ),
          ControllButton(
            icon: play ? Icons.pause : Icons.play_arrow,
            bgColor: MainColor.whiteF2F0EB,
            onPressed: playPause,
            splashR: 25,
            icSize: 32,
          ),
        ],
      ),
    );
  }
}
