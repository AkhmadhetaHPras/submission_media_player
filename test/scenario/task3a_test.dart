import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/components/music_cover_image.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:media_player/features/player/music_player.dart';
import 'package:media_player/shared_components/app_bar/back_button_app_bar_leading.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:mockito/mockito.dart';

final localMusic = Music(
  title: 'Night Changes',
  artist: 'One Direction',
  coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
  sourceType: 'local',
);

final networkMusic = Music(
  title: 'STAY',
  artist: 'The Kid LAROI, Justin Bieber',
  coverPath:
      'https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_justin_bieber_stay.jpeg?raw=true',
  sourceType: 'network',
);

Music? capturedMusic;
bool back = false;

class MockNavigatorObserver extends Mock
    implements NavigatorObserver, WidgetsBindingObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print('pushed $route');
    if (route.settings.arguments is Music) {
      capturedMusic = route.settings.arguments as Music;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name == '/music-player') {
      back = true;
    }
  }
}

final routes = <String, WidgetBuilder>{
  '/music-player': (_) => const MusicPlayer(),
};

void main() {
  void timeDisplayCheck(Slider slider, Duration duration) {
    expect(
      find.byType(TimeDisplay),
      findsOneWidget,
      reason: 'Music player must have a TimeDisplay component',
    );
    expect(
      find.text(duration.toString().split(".")[0]),
      findsNWidgets(2),
      reason:
          'Music player does not display text of music position and music duration (both initially 0:00:00)',
    );
  }

  testWidgets('BackButtonAppBarLeading built to specification',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: AppBar(leading: const BackButtonAppBarLeading())),
    );

    expect(
      find.byType(BackButtonAppBarLeading),
      findsOneWidget,
      reason:
          'Expected to find BackButtonAppBarLeading widget in the widget tree',
    );

    final icBtnFinder = find.byKey(const Key('back_btn'));
    expect(
      icBtnFinder,
      findsOneWidget,
      reason: 'Expected to find widget with key "back_btn"',
    );
    expect(
      icBtnFinder.evaluate().first.widget,
      isA<IconButton>(),
      reason: 'Expected widget with key "back_btn" is an IconButton',
    );
    expect(
      tester.widget<IconButton>(icBtnFinder).splashRadius,
      18,
      reason: 'IconButton splash radius should be 18',
    );

    final icBtn = tester.widget<IconButton>(icBtnFinder);
    expect(
      icBtn.icon,
      isA<Icon>(),
      reason: 'IconButton icon should be an Icon',
    );
    final icon = icBtn.icon as Icon;
    expect(
      icon.icon,
      Icons.arrow_back_ios_new_sharp,
      reason: 'Icon should use Icons.arrow_back_ios_new_sharp',
    );
    expect(
      icon.size,
      18,
      reason: 'Icon size should be 18',
    );
    expect(
      icon.color,
      MainColor.whiteFFFFFF,
      reason: 'Icon color should match MainColor.whiteFFFFFF',
    );
  });

  testWidgets('DotDivider built to specification', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DotDivider()),
    );
    expect(
      find.byType(DotDivider),
      findsOneWidget,
      reason: 'Expected to find DotDivider widget in widget tree',
    );

    final paddingFinder = find.byType(Padding);
    expect(
      paddingFinder,
      findsOneWidget,
      reason: 'Expected a Padding widget as its root widget',
    );

    final padding = tester.widget<Padding>(paddingFinder);
    expect(
      padding.padding.horizontal,
      12,
      reason: 'Padding should have horizontal padding of 6',
    );
    expect(
      padding.child,
      isA<Icon>(),
      reason: 'Padding child should be an Icon',
    );

    final icon = padding.child as Icon;
    expect(
      icon.icon,
      Icons.circle,
      reason: 'Icon should use Icons.circle',
    );
    expect(
      icon.size,
      6,
      reason: 'Icon size should be 6',
    );
    expect(
      icon.color,
      MainColor.whiteF2F0EB,
      reason: 'Icon color should match MainColor.whiteF2F0EB',
    );
  });

  testWidgets('ControllButton built to specification',
      (WidgetTester tester) async {
    bool tapped = false;
    onPressedMock() {
      tapped = true;
    }

    await tester.pumpWidget(
      MaterialApp(
          home: ControllButton(
        icon: Icons.abc,
        bgColor: MainColor.grey989794,
        onPressed: onPressedMock,
        splashR: 18,
        icSize: 24,
      )),
    );
    expect(
      find.byType(ControllButton),
      findsOneWidget,
      reason: 'Expected to find ControllButton widget in widget tree',
    );

    final materialFinder = find.byType(Material).first;
    expect(
      materialFinder,
      findsOneWidget,
      reason: 'Expected to find a Material widget as its root widget',
    );

    final material = tester.widget<Material>(materialFinder);
    expect(
      material.color,
      MainColor.grey989794,
      reason: 'Material color should match bgColor',
    );
    expect(
      material.shape,
      const OvalBorder(),
      reason: 'Material shape should be OvalBorder',
    );
    expect(
      material.child,
      isA<IconButton>(),
      reason: 'Material child should be an IconButton',
    );

    final icnBtn = material.child as IconButton;
    expect(
      icnBtn.splashRadius,
      18,
      reason: 'IconButton splash radius should match splashR',
    );
    expect(
      icnBtn.iconSize,
      24,
      reason: 'IconButton icon size should match icSize',
    );
    expect(
      icnBtn.icon,
      isA<Icon>(),
      reason: 'IconButton icon should be an Icon',
    );

    final icon = icnBtn.icon as Icon;
    expect(icon.icon, Icons.abc, reason: 'Icon icon data should match icon');
    expect(
      icon.color,
      isNull,
      reason:
          'Icon color should be null (inherit from IconButton) when color is not provided',
    );

    expect(
      icnBtn.onPressed.toString(),
      onPressedMock.toString(),
      reason: 'onPressed callback should match onPressed',
    );

    await tester.tap(materialFinder);
    expect(
      tapped,
      isTrue,
      reason: 'onPressed should be called on tap',
    );
  });

  testWidgets('ControllButton render with icon color',
      (WidgetTester tester) async {
    bool tapped = false;
    onPressedMock() {
      tapped = true;
    }

    await tester.pumpWidget(
      MaterialApp(
          home: ControllButton(
        icon: Icons.ac_unit,
        bgColor: MainColor.greyB6B5B1,
        onPressed: onPressedMock,
        splashR: 24,
        icSize: 32,
        icColor: MainColor.purple5A579C,
      )),
    );
    expect(
      find.byType(ControllButton),
      findsOneWidget,
      reason: 'Expected to find ControllButton widget in widget tree',
    );

    final materialFinder = find.byType(Material).first;
    expect(
      materialFinder,
      findsOneWidget,
      reason: 'Expected to find a Material widget as its root widget',
    );

    final material = tester.widget<Material>(materialFinder);
    expect(
      material.color,
      MainColor.greyB6B5B1,
      reason: 'Material color should match bgColor',
    );
    expect(
      material.shape,
      const OvalBorder(),
      reason: 'Material shape should be OvalBorder',
    );
    expect(
      material.child,
      isA<IconButton>(),
      reason: 'Material child should be an IconButton',
    );

    final icnBtn = material.child as IconButton;
    expect(
      icnBtn.splashRadius,
      24,
      reason: 'IconButton splash radius should match splashR',
    );
    expect(
      icnBtn.iconSize,
      32,
      reason: 'IconButton icon size should match icSize',
    );
    expect(
      icnBtn.icon,
      isA<Icon>(),
      reason: 'IconButton icon should be an Icon',
    );

    final icon = icnBtn.icon as Icon;
    expect(
      icon.icon,
      Icons.ac_unit,
      reason: 'Icon icon data should match icon',
    );
    expect(icon.color, MainColor.purple5A579C,
        reason: 'Icon color should match icColor');

    expect(
      icnBtn.onPressed.toString(),
      onPressedMock.toString(),
      reason: 'onPressed callback should match onPressed',
    );

    await tester.tap(materialFinder);
    expect(
      tapped,
      isTrue,
      reason: 'onPressed should be called on tap',
    );
  });

  testWidgets('MusicCoverImage widget render local source',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MusicCoverImage(
          sourceType: localMusic.sourceType!,
          cover: localMusic.coverPath!,
        ),
      ),
    );

    expect(
      find.byType(MusicCoverImage),
      findsOneWidget,
      reason: 'Expected to find a MusicCoverImage widget in the widget tree',
    );
    final firstontainerFinder = find.byType(Container).first;
    expect(
      firstontainerFinder,
      findsOneWidget,
      reason: 'Expected a Container widget as its root widget',
    );
    final firstContainer = tester.widget<Container>(firstontainerFinder);
    expect(
      firstContainer.decoration,
      isA<BoxDecoration>(),
      reason: 'Container (root widget) decoration should be a BoxDecoration',
    );
    expect(
      firstContainer.child,
      isNull,
      reason: 'Container (root widget) should not have a child widget',
    );
    expect(
      (firstContainer.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(20),
      reason:
          'Container (root widget) decoration should have a borderRadius circulars of 20',
    );
    expect(
      (firstContainer.decoration as BoxDecoration).image,
      isA<DecorationImage>(),
      reason:
          'Container (root widget) decoration should have an image property (DecorationImage)',
    );
    final decorationImage =
        (firstContainer.decoration as BoxDecoration).image as DecorationImage;
    expect(
      decorationImage.image,
      AssetImage(localMusic.coverPath!),
      reason:
          'Image property of DecorationImage should use AssetImage with localMusic.coverPath',
    );
    expect(
      decorationImage.fit,
      BoxFit.cover,
      reason: 'DecorationImage fit should be BoxFit.cover',
    );
  });

  testWidgets('MusicCoverImage widget render network source',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MusicCoverImage(
          sourceType: networkMusic.sourceType!,
          cover: networkMusic.coverPath!,
        ),
      ),
    );

    expect(
      find.byType(MusicCoverImage),
      findsOneWidget,
      reason: 'Expected to find a MusicCoverImage widget in the widget tree',
    );
    final firstontainerFinder = find.byType(Container).first;
    expect(
      firstontainerFinder,
      findsOneWidget,
      reason: 'Expected a Container widget as its root widget',
    );
    final firstContainer = tester.widget<Container>(firstontainerFinder);
    expect(
      firstContainer.decoration,
      isNull,
      reason:
          'Container (root widget) decoration should be null for network source',
    );
    expect(
      firstContainer.child,
      isA<ClipRRect>(),
      reason: 'Container child should be a ClipRRect for network source',
    );
    final clipRRect = firstContainer.child as ClipRRect;
    expect(
      clipRRect.borderRadius,
      BorderRadius.circular(20),
      reason: 'ClipRRect should have a borderRadius circular of 20',
    );
    expect(
      clipRRect.child,
      isA<CachedNetworkImage>(),
      reason:
          'ClipRRect child should be a CachedNetworkImage for network source',
    );
    final networkImage = clipRRect.child as CachedNetworkImage;

    expect(
      networkImage.imageUrl,
      networkMusic.coverPath,
      reason: 'CachedNetworkImage imageUrl should match music.coverPath',
    );
    expect(
      networkImage.fit,
      BoxFit.cover,
      reason: 'CachedNetworkImage fit should be BoxFit.cover',
    );
    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
      reason:
          'Expected to find a CircularProgressIndicator while loading network image',
    );
  });

  testWidgets(
      'MusicPlayer display MusicCoverImage, ControllButton, and its informations',
      (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = MockNavigatorObserver();
    capturedMusic = null;

    await tester.pumpWidget(
      MaterialApp(
        home: const Home(),
        routes: routes,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );
    await tester.pump();
    final firstMusicFinder = find.byType(CoverMusicCard).first;
    expect(
      firstMusicFinder,
      findsOneWidget,
      reason: 'Cannot find the first CoverMusicCard widget in Home',
    );
    await tester.tap(firstMusicFinder);
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

      /// display music cover image and its informations
      final musicCoverImageFinder = find.byType(MusicCoverImage);
      final musicCoverImage =
          tester.widget<MusicCoverImage>(musicCoverImageFinder);
      expect(
        musicCoverImageFinder,
        findsOneWidget,
        reason: 'Expected to find a MusicCoverImage widget in MusicPlayer',
      );
      expect(
        musicCoverImage.sourceType,
        music.sourceType,
        reason: 'MusicCoverImage sourceType should match music.sourceType',
      );
      expect(
        musicCoverImage.cover,
        music.coverPath,
        reason: 'MusicCoverImage cover should match music.coverPath',
      );

      expect(
        find.text(music.title!),
        findsOneWidget,
        reason: 'Expected to find music title text',
      );
      expect(
        find.text(music.artist!),
        findsOneWidget,
        reason: 'Expected to find music artist text',
      );
      expect(
        find.text(music.albumName!),
        findsOneWidget,
        reason: 'Expected to find music album name text',
      );
      expect(
        find.text(music.releaseYear!),
        findsOneWidget,
        reason: 'Expected to find music release year text',
      );

      /// has a slider with time and duration according to the music source
      final sliderFinder = find.byType(Slider);

      expect(sliderFinder, findsOneWidget,
          reason: 'Expected to find a Slider widget');
      final slider = tester.widget<Slider>(sliderFinder);
      expect(
        slider.value,
        0.0,
        reason: 'Slider value should be initially 0.0',
      );
      expect(
        slider.min,
        0.0,
        reason: 'Slider minimum value should be 0.0',
      );
      expect(
        slider.thumbColor,
        MainColor.purple5A579C,
        reason: 'Slider thumb color should match MainColor.purple5A579C',
      );
      expect(
        slider.activeColor,
        MainColor.purple5A579C,
        reason: 'Slider active color should match MainColor.purple5A579C',
      );

      const initDuration = Duration();
      expect(
        slider.max,
        initDuration.inSeconds.toDouble(),
        reason: 'Slider max value should match music duration',
      );
      timeDisplayCheck(slider, initDuration);

      final icnButtonFinder = find.byType(ControllButton);
      expect(
        icnButtonFinder,
        findsOneWidget,
        reason: 'Expected to find a ControllButton widget',
      );
      final icnButton = tester.widget<ControllButton>(icnButtonFinder);
      expect(
        icnButton.icon,
        Icons.play_arrow,
        reason: 'ControllButton icon should be play_arrow',
      );
      expect(
        icnButton.bgColor,
        MainColor.whiteF2F0EB,
        reason:
            'ControllButton background color should match MainColor.whiteF2F0EB',
      );
      expect(icnButton.splashR, 25,
          reason: 'ControllButton splash radius should be 25');
      expect(icnButton.icSize, 32,
          reason: 'ControllButton icon size should be 32');

      final icnButtonBackFinder = find.byKey(const Key('back_btn'));

      await tester.tap(icnButtonBackFinder);
      await tester.pump();
      expect(
        back,
        isTrue,
        reason:
            'Expected to navigate back after tapping BackButtonAppBarLeading',
      );
    } else {
      fail(
        'The music object is not forwarded to the MussicPlayer page via an argument',
      );
    }
  });
}
