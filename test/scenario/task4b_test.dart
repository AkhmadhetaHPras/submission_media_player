import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/components/video_indicator.dart';
import 'package:media_player/features/player/videos_player.dart';
import 'package:mockito/mockito.dart';
import 'package:video_player/video_player.dart';

Video? capturedVideo;

class MockNavigatorObserver extends Mock
    implements NavigatorObserver, WidgetsBindingObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print('pushed $route');
    if (route.settings.arguments is Video) {
      capturedVideo = route.settings.arguments as Video;
    }
  }
}

class MockVideoController extends Mock implements VideoPlayerController {
  @override
  VideoPlayerValue value = const VideoPlayerValue(duration: Duration.zero);

  @override
  Future<void> initialize() async {
    value = value.copyWith(
      duration: Duration(seconds: capturedVideo!.duration!),
      isInitialized: true,
    );
  }

  @override
  Future<void> play() async {
    value = value.copyWith(
      isPlaying: true,
    );
  }

  @override
  Future<void> pause() async {
    value = value.copyWith(
      isPlaying: false,
    );
  }

  @override
  Future<void> setLooping(bool looping) async {
    value = value.copyWith(isLooping: looping);
  }

  @override
  Future<void> setVolume(double volume) async {
    value = value.copyWith(volume: volume.clamp(0.0, 1.0));
  }
}

final routes = <String, WidgetBuilder>{
  '/video-player': (_) => const VideosPlayer(),
};

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    capturedVideo = null;
  });

  testWidgets(
      'VideosPlayer can perform videos player operation (initialize player, play, pause, and seek video)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: const Home(),
          routes: routes,
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
    await tester.pump();
    final firstVideoFinder = find.byType(CoverVideoCard).first;
    expect(
      firstVideoFinder,
      findsOneWidget,
      reason: 'Cannot find the first CoverVideoCard widget in Home',
    );
    await tester.tap(firstVideoFinder);
    await tester.pump();
    await tester.pump();

    if (capturedVideo != null) {
      final Video video = capturedVideo!;
      final videoPlayerFinder = find.byType(VideosPlayer);
      expect(
        videoPlayerFinder,
        findsOneWidget,
        reason:
            'Expected to navigate to the VideosPlayer after tapping CoverVideoCard component',
      );

      /// [Initialize Player]
      final videoPlayer = tester.widget<StatefulWidget>(videoPlayerFinder);

      final videoPlayerElement = videoPlayer.createElement();
      final videoPlayerState = videoPlayerElement.state as VideosPlayerState;

      /// [Verify initial state]
      videoPlayerState.video = video;
      await tester.pump();
      final mockPlayer = MockVideoController();
      videoPlayerState.controller = mockPlayer;
      await tester.pump();
      videoPlayerState.initVideoController();
      await tester.pump();

      expect(
        videoPlayerState.controller.value.isInitialized,
        isTrue,
        reason:
            'The controller should have been initialized after calling initVideoController() (because inside the function there should be a controller.initialize() call)',
      );
      expect(
        videoPlayerState.duration,
        Duration(seconds: video.duration!),
        reason:
            'After initializing the controller, the duration state must be equal to controller.value.duration',
      );
      expect(
        videoPlayerState.controller.value.isLooping,
        isTrue,
        reason:
            'After calling initVideoController(), video controller looping should be set to true',
      );
      expect(
        videoPlayerState.controller.value.volume,
        1.0,
        reason:
            'After calling initVideoController(), video controller volume should be set to 1.0',
      );
      expect(
        videoPlayerState.controller.value.isPlaying,
        isFalse,
        reason:
            'Calling initVideoController() not change the state of controller isPlaying to true, it remains false',
      );
      expect(
        videoPlayerState.controller.value.isCompleted,
        isFalse,
        reason:
            'Calling initVideoController() not change the state of controller isCompleted to true, it remains false',
      );

      // video section
      final videoSectionFinder = find.byKey(const Key('video_section'));
      expect(
        videoSectionFinder,
        findsOneWidget,
        reason: 'Expected found a widget with "video_section" key',
      );
      final videoSection = tester.widget<GestureDetector>(videoSectionFinder);
      expect(
        videoSection.onTap.toString(),
        videoPlayerState.switchControllVisibility.toString(),
        reason:
            'GestureDetector widget with key "video_section" onTap callback should be switchControllVisibility',
      );

      // video indicator
      final videoIndicatorFinder = find.byType(VideoIndicator);
      expect(
        videoIndicatorFinder,
        findsOneWidget,
        reason: 'Expected found a VideoIndicator widget',
      );
      final videoIndicator =
          tester.widget<VideoIndicator>(videoIndicatorFinder);

      // animatedopacity (parent of Video Indicator)
      final aOVideoIndicatorFinder = find.ancestor(
        of: videoIndicatorFinder,
        matching: find.byType(AnimatedOpacity),
      );
      expect(
        aOVideoIndicatorFinder,
        findsOneWidget,
        reason:
            'Expected to find the AnimatedOpacity widget which is the ancestor of VideoIndicator',
      );
      final aOVideoIndicator =
          tester.widget<AnimatedOpacity>(aOVideoIndicatorFinder);
      expect(
        aOVideoIndicator.duration,
        videoPlayerState.animDuration,
        reason:
            'The duration property of AnimatedOpacity (ancestor of VideoIndicator) must be equal to the animDuration state',
      );
      expect(
        aOVideoIndicator.opacity,
        1,
        reason:
            'The opacity property of AnimatedOpacity (ancestor of VideoIndicator) must be equal to 1 (initially)',
      );

      // video progress indicator
      final videoProgressFinder = find.byType(VideoProgressIndicator);
      expect(
        videoProgressFinder,
        findsOneWidget,
        reason:
            'Expected to find a VideoProgressIndicator widget (cause there is VideoIndicator component)',
      );
      final videoProgress =
          tester.widget<VideoProgressIndicator>(videoProgressFinder);
      expect(
        videoProgress.controller,
        videoIndicator.controller,
        reason:
            'The controller property of VideoProgressIndicator must use the controller passed to VideoIndicator',
      );
      expect(
        videoProgress.allowScrubbing,
        videoIndicator.isVisible,
        reason:
            'The allowScrubbing property of VideoProgressIndicator must be equal to isVisible state',
      );

      // controll button
      final controllButtonFinder = find.byType(ControllButton);
      expect(
        controllButtonFinder,
        findsOneWidget,
        reason: 'Expected to find ControllButton widget',
      );
      final controllButton =
          tester.widget<ControllButton>(controllButtonFinder);
      expect(
        controllButton.icon,
        Icons.play_arrow,
        reason:
            'The icon of the ControllButton should be Icons.play_arrow (initially, because the isPlaying condition of the controller is false)',
      );
      expect(
        controllButton.onPressed.toString(),
        videoPlayerState.playPause.toString(),
        reason: 'OnPressed callback of ControllButton should use playPause()',
      );
      // animatedopacity (parent of controll button)
      final aOControllButtonFinder = find.ancestor(
        of: controllButtonFinder,
        matching: find.byType(AnimatedOpacity),
      );
      expect(
        aOControllButtonFinder,
        findsOneWidget,
        reason:
            'Expected to find the AnimatedOpacity widget which is the ancestor of ControllButton',
      );
      final aOControllButton =
          tester.widget<AnimatedOpacity>(aOControllButtonFinder);
      expect(
        aOControllButton.duration,
        videoPlayerState.animDuration,
        reason:
            'The duration property of AnimatedOpacity (ancestor of ControllButton) must be equal to the animDuration state',
      );
      expect(
        aOControllButton.opacity,
        1,
        reason:
            'The opacity property of AnimatedOpacity (ancestor of ControllButton) must be equal to 1 (initially)',
      );

      expect(
        videoPlayerState.isVisible,
        isTrue,
        reason: 'Expected isVisible state is true (initially)',
      );

      /// [Play]
      await videoPlayerState.playPause();
      await tester.pump();
      expect(
        videoPlayerState.controller.value.isPlaying,
        isTrue,
        reason:
            'After calling playPause() on the first time (trigger by tapping ControllButton widget), controller.value.isPlaying should be true',
      );
      expect(
        videoPlayerState.isVisible,
        isFalse,
        reason:
            'After calling playPause() on the first time (trigger by tapping ControllButton widget), isVisible state should be false',
      );

      /// [switch visible only]
      videoPlayerState.switchControllVisibility();
      await tester.pump(const Duration(milliseconds: 2500));
      expect(
        videoPlayerState.isVisible,
        isFalse,
        reason:
            'After calling switchControllVisibility() (trigger by tapping GestureDetector widget) when controller isPlaying state is true and there is no more action (within 2500 ms), isVisible state should be false',
      );

      /// [Pause]
      // fail
      await videoPlayerState.playPause();
      await tester.pump(const Duration(milliseconds: 2500));
      expect(
        videoPlayerState.isVisible,
        isFalse,
        reason:
            'After calling playPause() (triggered by tapping the ControllButton widget) but not preceded by the trigger of calling switchControllVisibility(), isVisible state must be false',
      );
      expect(
        videoPlayerState.controller.value.isPlaying,
        isTrue,
        reason:
            'After calling playPause() (triggered by tapping the ControllButton widget) but not preceded by the trigger of calling switchControllVisibility() to change isVisible to true, controller.value.isPlaying state should be true (not paused)',
      );

      // success
      videoPlayerState.switchControllVisibility();
      await videoPlayerState.playPause();
      await tester.pump(const Duration(milliseconds: 2500));
      expect(
        videoPlayerState.isVisible,
        isTrue,
        reason:
            'After calling playPause() (triggered by tapping the ControllButton widget) and preceded by the trigger of calling switchControllVisibility(), isVisible state should be true',
      );
      expect(
        videoPlayerState.controller.value.isPlaying,
        isFalse,
        reason:
            'After calling playPause() (triggered by tapping the ControllButton widget) and preceded by the trigger of calling switchControllVisibility() to change isVisible to true, controller.value.isPlaying state should be false (paused)',
      );
    } else {
      fail(
          'The video object is not forwarded to the VideosPlayer page via an arguments');
    }
  });
}
