import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/features/player/components/controll_button.dart';
import 'package:media_player/features/player/components/loading_video_placeholder.dart';
import 'package:media_player/features/player/components/time_display.dart';
import 'package:media_player/features/player/components/video_indicator.dart';
import 'package:media_player/features/player/components/video_information.dart';
import 'package:media_player/features/player/videos_player.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';
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

final routes = <String, WidgetBuilder>{
  '/video-player': (_) => const VideosPlayer(),
};

void main() {
  Video localSourceVideo = Video(
    title: "Aquaman And The Lost Kingdom | Trailer",
    creator: "DC",
    creatorPhoto:
        "https://upload.wikimedia.org/wikipedia/commons/7/7d/DC_Comics_Logo.jpg",
    description:
        "Director James Wan and Aquaman himself, Jason Momoa—along with Patrick Wilson, Amber Heard, Yahya Abdul-Mateen II and Nicole Kidman—return in the sequel to the highest-grossing DC film of all time: “Aquaman and the Lost Kingdom.”\nHaving failed to defeat Aquaman the first time, Black Manta, still driven by the need to avenge his father's death, will stop at nothing to take Aquaman down once and for all. This time Black Manta is more formidable than ever before, wielding the power of the mythic Black Trident, which unleashes an ancient and malevolent force. To defeat him, Aquaman will turn to his imprisoned brother Orm, the former King of Atlantis, to forge an unlikely alliance. Together, they must set aside their differences in order to protect their kingdom and save Aquaman's family, and the world, from irreversible destruction.",
    releaseDate: "2023-09-14",
    sourceType: "local",
    source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
    coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
    viewsCount: 1082000,
  );

  void checkWhenCanShowMore(
    WidgetTester tester,
    Finder inkWellFinder,
    Finder columnFinder,
    bool afterLess,
  ) {
    final reasonClue = afterLess
        ? 'Hitting Less Button does not restore the widget or state:'
        : '';
    expect(
      inkWellFinder,
      findsOneWidget,
      reason:
          '$reasonClue InkWell widget not found within Column in VideoInformation Widget',
    );
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect(
      (inkWell.child as Text).data,
      '...other',
      reason:
          "$reasonClue InkWell child not a Text widget with '...other' text data",
    );

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(
      descriptionFinder,
      findsOneWidget,
      reason:
          "$reasonClue Text widget that containing video description not found within Column in VideoInformation Widget",
    );
    final description = tester.widget<Text>(descriptionFinder);
    expect(
      description.maxLines,
      3,
      reason:
          "$reasonClue maxLines property of Text widget that containing video description is not 3",
    );
  }

  void checkWhenCanLess(
    WidgetTester tester,
    Finder inkWellFinder,
    Finder columnFinder,
  ) {
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect((inkWell.child as Text).data, 'Less',
        reason: "InkWell child not a Text widget with 'Less' text data");

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(
      descriptionFinder,
      findsOneWidget,
      reason:
          "Text widget that containing video description not found within Column in VideoInformation Widget",
    );
    final description = tester.widget<Text>(descriptionFinder);
    expect(
      description.maxLines,
      null,
      reason:
          "maxLines property of Text widget that containing video description should be null",
    );
  }

  testWidgets('Structur of LoadingVideoPlaceholder widget is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: localSourceVideo.sourceType!,
              cover: localSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final loadingVideoPlaceholder = find.byType(LoadingVideoPlaceholder);
    expect(
      loadingVideoPlaceholder,
      findsOneWidget,
      reason:
          'Expected to find a LoadingVideoPlaceholder widget in widget tree',
    );

    final stackFinder = find.byType(Stack).first;
    expect(
      stackFinder,
      findsOneWidget,
      reason:
          'Expected to find a Stack widget as root of LoadingVideoPlaceholder widget',
    );
    final stackWidget = tester.widget<Stack>(stackFinder);

    expect(
      stackWidget.alignment,
      Alignment.center,
      reason: 'Stack alignment should be Alignment.center',
    );

    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270),
    );

    expect(
      videoWrapperFinder,
      findsOneWidget,
      reason:
          'Expected to find a SizedBox widget with the specified dimensions within Stack widget child',
    );
    expect(
      stackWidget.children.last,
      isA<CircularProgressIndicator>(),
      reason: 'Stack should have a CircularProgressIndicator as the last child',
    );
    expect(
      (stackWidget.children.last as CircularProgressIndicator).color,
      MainColor.purple5A579C,
      reason:
          'CircularProgressIndicator color should match MainColor.purple5A579C',
    );
  });

  testWidgets('LoadingVideoPlaceholder render local source',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: localSourceVideo.sourceType!,
              cover: localSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack).first;
    expect(
      stackFinder,
      findsOneWidget,
      reason:
          'Expected to find a Stack widget as root of LoadingVideoPlaceholder widget',
    );
    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270 &&
          widget.child is Image),
    );

    expect(
      videoWrapperFinder,
      findsOneWidget,
      reason:
          'Expected to find a SizedBox with specified dimension and an Image child',
    );
    final image =
        (tester.widget<SizedBox>(videoWrapperFinder).child as Image).image;
    if (image is AssetImage) {
      expect(
        image.assetName,
        localSourceVideo.coverPath!,
        reason: 'Expected an Image.asset with matching cover path',
      );
    } else if (image is ExactAssetImage) {
      expect(
        image.assetName,
        localSourceVideo.coverPath!,
        reason: 'Expected an Image.asset with matching cover path',
      );
    } else {
      fail('Unexpected asset image widget found | use Image.asset instead');
    }
  });

  testWidgets('LoadingVideoPlaceholder render network source',
      (WidgetTester tester) async {
    final networkSourceVideo = Video(
      title: "FutureBuilder (Widget of the Week)",
      creator: "Flutter",
      creatorPhoto:
          "https://logowik.com/content/uploads/images/flutter5786.jpg",
      description:
          "Have a Future and need some widgets to display its values? Try FutureBuilder! Add a Future and a build method, and you'll create widgets based on the Future state and update them as it changes.",
      releaseDate: "2018-01-23",
      sourceType: "network",
      source:
          "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-player/flutter_future_builder_widget_of_the_week.mp4",
      coverPath:
          "https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_flutter_future_builder_widget_of_the_week.jpeg?raw=true",
      viewsCount: 80912801,
    );

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: LoadingVideoPlaceholder(
              sourceType: networkSourceVideo.sourceType!,
              cover: networkSourceVideo.coverPath!,
            ),
          ),
        ),
      ),
    );

    final stackFinder = find.byType(Stack).first;
    expect(
      stackFinder,
      findsOneWidget,
      reason:
          'Expected to find a Stack widget as root of LoadingVideoPlaceholder widget',
    );
    final videoWrapperFinder = find.descendant(
      of: stackFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is SizedBox &&
          widget.width == double.infinity &&
          widget.height == 270 &&
          widget.child is ClipRRect),
    );

    expect(
      videoWrapperFinder,
      findsOneWidget,
      reason:
          'Expected to find a SizedBox with specified dimension and an ClipRRect child for network source',
    );

    final clipRRect =
        tester.widget<SizedBox>(videoWrapperFinder).child as ClipRRect;

    expect(
      clipRRect.child,
      isA<CachedNetworkImage>(),
      reason: 'Expected ClipRRect child to be a CachedNetworkImage',
    );

    final networkImage = clipRRect.child as CachedNetworkImage;
    expect(
      networkImage.imageUrl,
      networkSourceVideo.coverPath,
      reason: 'CachedNetworkImage URL should match video cover path',
    );

    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
      reason: 'Expected to find a CircularProgressIndicator',
    );
    expect(
      networkImage.fit,
      BoxFit.cover,
      reason: 'CachedNetworkImage fit property should be BoxFit.cover',
    );
  });

  testWidgets('Structur of VideoIndicator widget is built correctly',
      (WidgetTester tester) async {
    Duration position = const Duration();
    Duration duration = const Duration(seconds: 197);
    VideoPlayerController controller = VideoPlayerController.asset(
      localSourceVideo.source!,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VideoIndicator(
            position: position,
            duration: duration,
            controller: controller,
            isVisible: true,
          ),
        ),
      ),
    );

    expect(
      find.byType(VideoIndicator),
      findsOneWidget,
      reason: 'Expected to found VideoIndicator widget in widget tree',
    );

    final containerFinder = find.byType(Container).first;
    expect(
      containerFinder,
      findsOneWidget,
      reason: 'Expected to find a Container widget as its root widget',
    );
    final container = tester.widget<Container>(containerFinder);

    expect(
      (container.padding as EdgeInsets).top,
      20.0,
      reason: 'Container top padding should be 20',
    );
    expect(
      container.decoration,
      isA<BoxDecoration>(),
      reason: 'Expected Container decoration is a BoxDecoration',
    );
    expect(
      (container.decoration as BoxDecoration).gradient,
      isA<LinearGradient>(),
      reason: 'The expected BoxDecoration gradient is LinearGradient',
    );

    final linearGradient =
        (container.decoration as BoxDecoration).gradient as LinearGradient;
    expect(
      linearGradient.begin,
      Alignment.bottomCenter,
      reason: 'LinearGradient begin alignment should be Alignment.bottomCenter',
    );
    expect(
      linearGradient.end,
      Alignment.topCenter,
      reason: 'LinearGradient end alignment should be Alignment.bottomCenter',
    );

    final colors = [
      MainColor.black000000,
      MainColor.black000000.withOpacity(0.5),
      MainColor.black000000.withOpacity(0.2),
      Colors.transparent,
    ];
    expect(
      linearGradient.colors,
      colors,
      reason: 'The color of the LinearGradient must be as specified',
    );

    expect(
      container.child,
      isA<Column>(),
      reason: 'Container child should be a Column widget',
    );
    final columnFinder = find.byType(Column);
    expect(
      columnFinder,
      findsOneWidget,
      reason: 'Expected to find a Column widget',
    );
    final column = container.child as Column;
    expect(
      column.mainAxisSize,
      MainAxisSize.min,
      reason: 'Column mainAxisSize should be MainAxisSize.min',
    );

    final timeDisplayFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is Padding &&
          (widget.padding as EdgeInsets).horizontal == 16 &&
          widget.child is TimeDisplay),
    );
    expect(
      timeDisplayFinder,
      findsOneWidget,
      reason:
          'Expected to find a TimeDisplay widget with padding horizontal set to 8 within column widget',
    );
    expect(
      find.text(position.toString().split(".")[0]),
      findsOneWidget,
      reason: 'VideosPlayer display video position',
    );
    expect(
      find.text(duration.toString().split(".")[0]),
      findsOneWidget,
      reason: 'VideosPlayer display video duration',
    );

    final videoProgressFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(VideoProgressIndicator),
    );
    expect(
      videoProgressFinder,
      findsOneWidget,
      reason: 'Expected to find a VideoProgressIndicator widget',
    );
  });

  testWidgets('Structur of VideoInformation widget is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: VideoInformation(
              video: localSourceVideo,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byType(VideoInformation),
      findsOneWidget,
      reason: 'Expected to find a VideoInformation widget in widget tree',
    );

    final columnFinder = find.byType(Column);
    expect(
      columnFinder,
      findsOneWidget,
      reason: 'Expected to find a Column widget as its root widget',
    );
    final column = tester.widget<Column>(columnFinder);
    expect(
      column.crossAxisAlignment,
      CrossAxisAlignment.start,
      reason: 'Column crossAxisAlignment should be CrossAxisAlignment.start',
    );

    final titleFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == localSourceVideo.title);
    expect(
      titleFinder,
      findsOneWidget,
      reason: 'Expected to find a Text widget for video title',
    );
    final title = tester.widget<Text>(titleFinder);
    expect(
      title.maxLines,
      3,
      reason:
          'Text widget with video title text data should have maxLines set to 3',
    );
    expect(
      title.overflow,
      TextOverflow.ellipsis,
      reason:
          'Text widget with video title text data should have overflow set to elipsis',
    );
    expect(
      title.style,
      MainTextStyle.poppinsW600.copyWith(
        fontSize: 18,
        color: MainColor.whiteF2F0EB,
      ),
      reason:
          'Text widget with video title text data should have style as specified',
    );

    final paddingChannelWrapperFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Padding &&
            (widget.padding as EdgeInsets).vertical == 16 &&
            widget.child is Row,
      ),
    );
    expect(
      paddingChannelWrapperFinder,
      findsOneWidget,
      reason:
          'Expected padding widget with vertical padding set to 8 and have row widget child within column',
    );
    final rowChannelWrapperFinder = find.descendant(
      of: paddingChannelWrapperFinder,
      matching: find.byType(Row),
    );
    expect(
      rowChannelWrapperFinder,
      findsOneWidget,
      reason:
          'Expected a Row widget as wrapper for Channel information within padding widget',
    );

    final sizedboxWrapperChannelImageFinder = find.descendant(
      of: rowChannelWrapperFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.height == 36 &&
            widget.width == 36 &&
            widget.child is ClipRRect,
      ),
    );
    expect(
      sizedboxWrapperChannelImageFinder,
      findsOneWidget,
      reason:
          'Expected a SizedBox with ClipRRect child and specified dimension',
    );

    final channelImageFinder = find.descendant(
      of: sizedboxWrapperChannelImageFinder,
      matching: find.byType(CachedNetworkImage),
    );
    expect(
      channelImageFinder,
      findsOneWidget,
      reason: 'Expected a CachedNetworkImage widget within ClipRRect widget',
    );
    final channelImage = tester.widget<CachedNetworkImage>(channelImageFinder);
    expect(
      channelImage.imageUrl,
      localSourceVideo.creatorPhoto,
      reason: 'CachedNetworkImage image URL should match video.creatorPhoto',
    );
    expect(
      channelImage.fit,
      BoxFit.cover,
      reason: 'CachedNetworkImage fit should be BoxFit.cover',
    );

    final channelImageLoader = find.byType(CircularProgressIndicator);
    expect(channelImageLoader, findsOneWidget,
        reason: 'Expected a CircularProgressIndicator for image loading');

    expect(
      tester.widget<CircularProgressIndicator>(channelImageLoader).color,
      MainColor.purple5A579C,
      reason: 'Progress indicator color should match MainColor.purple5A579C',
    );

    final channelNameFinder = find.descendant(
      of: rowChannelWrapperFinder,
      matching: find.byType(Text),
    );
    expect(
      channelNameFinder,
      findsOneWidget,
      reason:
          'Expected a Text widget for channel name within row widget (inside padding)',
    );
    final channelName = tester.widget<Text>(channelNameFinder);
    expect(
      channelName.data,
      localSourceVideo.creator,
      reason: 'Channel name should match video.creator',
    );
    expect(
      channelName.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 14,
        color: MainColor.whiteFFFFFF,
      ),
      reason: 'Expected Channel name text style as specified',
    );

    final rowDetailsWrapperFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Row &&
            widget.children.first is Text &&
            widget.children[1] is DotDivider &&
            widget.children.last is Text,
      ),
    );
    expect(
      rowDetailsWrapperFinder,
      findsOneWidget,
      reason:
          'Expected a Row widget for details (views count[first child], DotDivider[second child], and release date[third/last child])',
    );

    final viewsFinder = find.descendant(
      of: rowDetailsWrapperFinder,
      matching: find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data ==
              "${localSourceVideo.viewsCount!.formatViewsCount()} x views"),
    );
    expect(
      viewsFinder,
      findsOneWidget,
      reason:
          "Expected a Text widget for Views count with format 'video.viewsCount.formatViewsCount() x views' within Row widget (insidE Column directly)",
    );
    final viewsCount = tester.widget<Text>(viewsFinder);
    expect(
      viewsCount.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 13,
        color: MainColor.whiteFFFFFF,
      ),
      reason: 'Expected views count text style as specified',
    );

    final releaseFinder = find.descendant(
      of: rowDetailsWrapperFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            widget.data == localSourceVideo.releaseDate!.toLocalTime(),
      ),
    );
    expect(
      releaseFinder,
      findsOneWidget,
      reason:
          "Expected a Text widget for Release date with format 'video.releaseDate.toLocalTime()' within Row widget (insidE Column directly)",
    );
    final releaseDate = tester.widget<Text>(releaseFinder);
    expect(
      releaseDate.style,
      MainTextStyle.poppinsW500.copyWith(
        fontSize: 13,
        color: MainColor.whiteFFFFFF,
      ),
      reason: 'Expected release date text style as specified',
    );

    final descriptionFinder = find.descendant(
      of: columnFinder,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Text && widget.data == localSourceVideo.description,
      ),
    );
    expect(
      descriptionFinder,
      findsOneWidget,
      reason:
          'Expected a Text widget for description within Column (root widget)',
    );
    final description = tester.widget<Text>(descriptionFinder);
    expect(
      description.style,
      MainTextStyle.poppinsW400.copyWith(
        fontSize: 12,
        color: MainColor.whiteFFFFFF,
      ),
      reason: 'Expected description text style as specified',
    );
    expect(
      description.maxLines,
      3,
      reason: 'Text widget for Description should have maxLines set to 3',
    );

    final inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    expect(
      inkWellFinder,
      findsOneWidget,
      reason: 'Expected an InkWell widget with in Column (root widget)',
    );
    final inkWell = tester.widget<InkWell>(inkWellFinder);
    expect(
      inkWell.child,
      isA<Text>(),
      reason: 'InkWell widget child should be a Text widget',
    );
    expect(
        (inkWell.child as Text).style,
        MainTextStyle.poppinsW400.copyWith(
          fontSize: 12,
          color: Colors.blue,
        ),
        reason: 'Expected InkWell child text style as specified');

    expect(
      (inkWell.child as Text).data,
      '...other',
      reason: 'InkWell child text data should be "...other"',
    );
  });

  testWidgets('VideoInformation widget can handle show more action',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(480, 800)),
        child: MaterialApp(
          home: Scaffold(
            body: VideoInformation(
              video: localSourceVideo,
            ),
          ),
        ),
      ),
    );

    final columnFinder = find.byType(Column);
    expect(
      columnFinder,
      findsOneWidget,
      reason: 'Expected to find a Column widget as its root widget',
    );
    Finder inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    checkWhenCanShowMore(tester, inkWellFinder, columnFinder, false);

    await tester.tap(inkWellFinder);
    await tester.pump();

    inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );

    checkWhenCanLess(tester, inkWellFinder, columnFinder);

    await tester.tap(inkWellFinder);
    await tester.pump();

    inkWellFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(InkWell),
    );
    checkWhenCanShowMore(tester, inkWellFinder, columnFinder, true);
  });

  testWidgets(
      'VideosPlayer display ControllButton, VideoIndicator, and VideoInformation',
      (WidgetTester tester) async {
    MockNavigatorObserver mockNavigatorObserver = MockNavigatorObserver();
    capturedVideo = null;

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

      final columnFinder = find.byKey(const Key('root_widget'));
      expect(
        columnFinder,
        findsOneWidget,
        reason: "Expected a widget with 'root_widget' key",
      );
      expect(
        columnFinder.evaluate().first.widget,
        isA<Column>(),
        reason: "Expected a widget with 'root_widget' key is a Column widget",
      );

      final rootColumn = tester.widget<Column>(columnFinder);
      expect(
        rootColumn.crossAxisAlignment,
        CrossAxisAlignment.start,
        reason:
            'Column (root widget) crossAxisAlignment should be CrossAxisAlignment.start',
      );

      expect(
        rootColumn.children.length,
        3,
        reason:
            'The expected length of the Column child (root widget) is 3 (FutureBuilder, SizedBox, and Expanded)',
      );

      expect(
        rootColumn.children.first,
        isA<FutureBuilder<void>>(),
        reason:
            'The first expected child of Column (the root widget) is FutureBuilder',
      );

      final videoSectionFinder = find.byKey(const Key('video_section'));
      expect(
        videoSectionFinder,
        findsOneWidget,
        reason: 'Expected found a widget with "video_section" key',
      );
      expect(
        videoSectionFinder.evaluate().first.widget,
        isA<GestureDetector>(),
        reason: 'Expected widget with "video_section" key is a GestureDetector',
      );

      final stackVideoAndControllWrapperFinder = find.descendant(
        of: videoSectionFinder,
        matching: find.byWidgetPredicate(
          (widget) => widget is Stack && widget.alignment == Alignment.center,
        ),
      );
      expect(
        stackVideoAndControllWrapperFinder,
        findsOneWidget,
        reason:
            'Expected Stack widget with center alignment within widget with "video_section" key (direct child of "video_section" widget)',
      );

      final sizedBoxVideoPlayerFinder = find.descendant(
        of: stackVideoAndControllWrapperFinder,
        matching: find.byWidgetPredicate((widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270 &&
            widget.child is Stack),
      );
      expect(
        sizedBoxVideoPlayerFinder,
        findsOneWidget,
        reason:
            'Expected SizedBox widget with specified properties within Stack (direct child of "video_section" widget) widget',
      );

      final stackVideoPlayerFinder = find.descendant(
        of: sizedBoxVideoPlayerFinder,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Stack && widget.alignment == Alignment.bottomLeft,
        ),
      );
      expect(
        stackVideoPlayerFinder,
        findsOneWidget,
        reason:
            'Expected Stack widget with bottomLeft alignment within Sizebox (that has width = double.infinity)',
      );

      final stackVideoPlayer = tester.widget<Stack>(stackVideoPlayerFinder);
      expect(
        stackVideoPlayer.children.length,
        2,
        reason:
            'Expected Stack widget with bottom left alignment has 2 child (VideoPlayer and AnimatedOpacity)',
      );
      expect(
        stackVideoPlayer.children.first,
        isA<VideoPlayer>(),
        reason:
            'Expected first child of Stack widget with bottom left alignment is a VideoPlayer',
      );
      expect(
        stackVideoPlayer.children.last,
        isA<AnimatedOpacity>(),
        reason:
            'Expected second child of Stack widget with bottomLeft alignment is a AnimatedOpacity',
      );

      expect(
        (stackVideoPlayer.children.last as AnimatedOpacity).opacity,
        1,
        reason:
            'Expected AnimatedOpacity (second child of Stack widget with bottomLeft alignment) opacity initially set to 1',
      );
      expect(
        (stackVideoPlayer.children.last as AnimatedOpacity).child,
        isA<VideoIndicator>(),
        reason:
            'Expected AnimatedOpacity (second child of Stack widget with bottomLeft alignment) child is a VideoIndicator',
      );

      final animatedOpacityControllButtonFinder = find.descendant(
        of: stackVideoAndControllWrapperFinder,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedOpacity &&
              widget.opacity == 1 &&
              widget.child is ControllButton,
        ),
      );
      expect(
        animatedOpacityControllButtonFinder,
        findsOneWidget,
        reason:
            'Expected AnimatedOpacity widget with specified properties within  Stack widget with center alignment',
      );
      final controllButton = (animatedOpacityControllButtonFinder
              .evaluate()
              .first
              .widget as AnimatedOpacity)
          .child as ControllButton;
      expect(
        controllButton.icon,
        Icons.play_arrow,
        reason: 'ControllButton icon should be Icons.play_arrow',
      );
      expect(
        controllButton.bgColor,
        MainColor.black000000.withOpacity(0.2),
        reason:
            'ControllButton bgColor should be MainColor.black000000.withOpacity(0.2)',
      );
      expect(
        controllButton.splashR,
        26,
        reason: 'ControllButton splashR should be 26',
      );
      expect(
        controllButton.icSize,
        36,
        reason: 'ControllButton splashR should be 36',
      );

      expect(
        rootColumn.children.elementAt(1),
        isA<SizedBox>(),
        reason:
            'The second expected child of Column (the root widget) is Sizedbox',
      );
      expect(
        (rootColumn.children.elementAt(1) as SizedBox).height,
        4,
        reason:
            'Expected Sizedbox (second child of Column-root widget) height set to 4',
      );

      expect(
        rootColumn.children.elementAt(2),
        isA<Expanded>(),
        reason:
            'The third expected child of Column (the root widget) is Expanded',
      );
      final scrollViewFinder = find.descendant(
        of: find.byType(Expanded),
        matching: find.byType(SingleChildScrollView),
      );
      expect(
        scrollViewFinder,
        findsOneWidget,
        reason:
            'Expected a SingleChildScrollView widget within Expanded widget',
      );
      final scrollView = tester.widget<SingleChildScrollView>(scrollViewFinder);
      expect(
        scrollView.padding,
        const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        reason:
            'The vertical SingleChildScrollView padding should be set to 12 and the horizontal set to 8',
      );
      expect(
        scrollView.child,
        isA<VideoInformation>(),
        reason:
            'Expected VideoInformation widget as child of SingleChildScrollView',
      );

      final videoInformation = scrollView.child as VideoInformation;
      expect(
        videoInformation.video,
        video,
        reason:
            'VideoInformation video should match video (Video object captured from argument navigation)',
      );
    } else {
      fail(
          'The video object is not forwarded to the VideosPlayer page via an arguments');
    }
  });
}
