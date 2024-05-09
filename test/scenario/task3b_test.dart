import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:mockito/mockito.dart';

Music? capturedMusic;
Duration musicDuration = const Duration();
bool? mockPlayState;

class MockNavigatorObserver extends Mock
    implements NavigatorObserver, WidgetsBindingObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.arguments is Music) {
      capturedMusic = route.settings.arguments as Music;
    }
  }
}

class MockAudioPlayer extends Mock implements AudioPlayer {
  PlayerState mockState = PlayerState.stopped;
  double mockVolume = 1.0;
  Duration positionAfterSeek = const Duration();

  @override
  Future<void> play(Source source,
      {double? volume,
      double? balance,
      AudioContext? ctx,
      Duration? position,
      PlayerMode? mode}) async {
    mockState = PlayerState.playing;
  }

  @override
  Future<void> pause() async {
    mockState = PlayerState.paused;
  }

  @override
  Future<void> stop() async {
    mockState = PlayerState.stopped;
  }

  @override
  Future<void> setVolume(double volume) async {
    mockVolume = volume;
  }

  @override
  Future<void> setSource(Source source) async {}

  @override
  Future<Duration?> getDuration() async {
    musicDuration = Duration(seconds: capturedMusic!.duration!);
    return musicDuration;
  }

  @override
  Stream<Duration> get onPositionChanged => Stream.value(positionAfterSeek);

  @override
  Future<void> seek(Duration position) async {
    if (position == musicDuration) {
      mockPlayState = false;
    }
    positionAfterSeek = position;
  }
}

final routes = <String, WidgetBuilder>{
  '/music-player': (_) => const MusicPlayer(),
};

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    capturedMusic = null;
  });

  testWidgets(
      'MusicPlayer can perform audio operations (initialize player, play, pause, and seek to second)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
        routes: routes,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
    await tester.pump();
    expect(
      find.byType(Home),
      findsOneWidget,
      reason: 'Expected to find a Home widget on initial load',
    );
    await tester.tap(find.byType(CoverMusicCard).first);
    await tester.pumpAndSettle();
    if (capturedMusic != null) {
      final Music music = capturedMusic!;
      final musicPlayerFinder = find.byType(MusicPlayer);
      expect(
        musicPlayerFinder,
        findsOneWidget,
        reason:
            'Expected to navigate to the MusicPlayer after tapping CoverMusicCard component',
      );

      /// [Initialize Player]
      final musicPlayer = tester.widget<StatefulWidget>(musicPlayerFinder);

      final musicPlayerElement = musicPlayer.createElement();
      final musicPlayerState = musicPlayerElement.state as MusicPlayerState;
      final mockPlayer = MockAudioPlayer();
      musicPlayerState.newPlayer = mockPlayer;

      /// [Verify initial state]
      expect(
        find.text(music.title!),
        findsOneWidget,
        reason: 'Expected to find music title text',
      );
      expect(
        musicPlayerState.play,
        isFalse,
        reason: 'Play state on MusicPlayer should be initially false',
      );
      expect(
        mockPlayer.mockState,
        PlayerState.stopped,
        reason: 'AudioPlayer should be in stopped state initially',
      );
      musicPlayerState.music = music;
      await tester.pump();
      musicPlayerState.initPlayerState();
      await tester.pumpAndSettle();
      final capturedSource = music.sourceType == "local"
          ? AssetSource(
              music.source!.replaceFirst("assets/", ""),
            )
          : UrlSource(music.source!);
      expect(
        musicPlayerState.source.toString(),
        capturedSource.toString(),
        reason:
            'MusicPlayer source should match captured music source (as passed on argument)',
      );

      expect(
        musicPlayerState.duration,
        await mockPlayer.getDuration(),
        reason: '''
MusicPlayer duration should match captured music duration from argument.
In this case, duration atribut on music object should be match with the true duration of the music.
''',
      );

      /// [Play]
      final icnButtonFinder = find.byType(ControllButton);
      expect(
        icnButtonFinder,
        findsOneWidget,
        reason: 'Expected to find a ControllButton widget in the MusicPlayer',
      );
      final icnButton = tester.widget<ControllButton>(icnButtonFinder);
      expect(
        icnButton.onPressed.toString(),
        musicPlayerState.playPause.toString(),
        reason: 'ControllButton onPressed should call playPause',
      );

      await musicPlayerState.playPause();
      await tester.pumpAndSettle();
      expect(
        musicPlayerState.play,
        isTrue,
        reason:
            'Calling the playPause method for the first time will change the play state to true (because initial state of play is false)',
      );
      expect(
        mockPlayer.mockVolume,
        1,
        reason:
            'After calling the playPause method for the first time, volume state should be 1.0',
      );
      expect(
        mockPlayer.mockState,
        PlayerState.playing,
        reason:
            'Calling the playPause method for the first time will trigger the invocation of AudioPlayer.play',
      );

      /// [Seek to Second]
      final Slider slider = tester.widget<Slider>(find.byType(Slider).first);
      expect(
        slider.onChanged.toString(),
        musicPlayerState.seekToSecond.toString(),
        reason: 'Slider onChanged should call seekToSecond',
      );

      musicPlayerState.seekToSecond(120);
      await tester.pump();
      expect(
        mockPlayer.positionAfterSeek,
        const Duration(seconds: 120),
        reason:
            'Calling seekToSecond should trigger the invocation of AudioPlayer.seek',
      );
      expect(
        musicPlayerState.play,
        isTrue,
        reason:
            'Calling seekToSecond with second < music.duration does not make the play state change (in this case the play state should remain true)',
      );

      musicPlayerState.seekToSecond(musicDuration.inSeconds.toDouble());
      await tester.pump();
      expect(
        mockPlayer.positionAfterSeek,
        musicDuration,
        reason:
            'Calling seekToSecond should trigger the invocation of AudioPlayer.seek',
      );
      expect(
        mockPlayState,
        isFalse,
        reason:
            'Calling seekToSecond with second == music.duration make the play state to false',
      );

      /// [Pause]
      await musicPlayerState.playPause();
      await tester.pumpAndSettle();
      expect(
        musicPlayerState.play,
        isFalse,
        reason:
            'Calling the playPause method for the second time will change the play state from true to false again',
      );
      expect(
        mockPlayer.mockState,
        PlayerState.paused,
        reason:
            'Calling the playPause method a second time will also trigger the invocation of AudioPlayer.play',
      );
    } else {
      fail(
        'The music object is not forwarded to the MussicPlayer page via an argument',
      );
    }
  });
}
