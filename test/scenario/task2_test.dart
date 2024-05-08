import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/config/themes/main_text_style.dart';
import 'package:media_player/constants/assets_const.dart';
import 'package:media_player/data/music_model.dart';
import 'package:media_player/data/video_model.dart';
import 'package:media_player/features/home/components/cover_music_card.dart';
import 'package:media_player/features/home/components/cover_video_card.dart';
import 'package:media_player/features/home/components/title_section.dart';
import 'package:media_player/features/home/home.dart';
import 'package:media_player/shared_components/app_bar/custom_app_bar.dart';
import 'package:media_player/shared_components/dot_divider.dart';
import 'package:media_player/utils/extension_function.dart';

void main() {
  testWidgets('Structur of CustomAppBar widget is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomAppBar(),
      ),
    );

    final customAppBarFinder = find.byType(CustomAppBar);
    expect(
      customAppBarFinder,
      findsOneWidget,
      reason: 'Expected to find CustomAppBar widget in widget tree',
    );
    final customAppBar = tester.widget<PreferredSizeWidget>(customAppBarFinder);
    expect(
      customAppBar.preferredSize,
      const Size.fromHeight(56),
      reason: 'CustomAppBar should have preferred height of 56',
    );

    final appBarFinder = find.byType(AppBar);
    expect(
      appBarFinder,
      findsOneWidget,
      reason: 'Expected to find an AppBar widget as its root widget',
    );

    final appBar = tester.widget<AppBar>(appBarFinder);
    expect(
      appBar.backgroundColor,
      MainColor.purple5A579C,
      reason: 'AppBar background color should match MainColor.purple5A579C',
    );
    expect(
      appBar.titleSpacing,
      0,
      reason: 'AppBar titleSpacing should be 0',
    );

    expect(
      appBar.leading,
      isA<Padding>(),
      reason: 'AppBar leading should be a Padding widget',
    );

    final leading = appBar.leading as Padding;
    expect(
      leading.padding,
      const EdgeInsets.all(8),
      reason: 'Padding (AppBar leading) padding should be all 8',
    );
    expect(
      leading.child,
      isA<SvgPicture>(),
      reason: 'Padding (AppBar leading) child should be a SvgPicture',
    );
    expect(
      (leading.child as SvgPicture).bytesLoader,
      const SvgAssetLoader(
        AssetsConsts.logo,
      ),
      reason:
          'Expected SvgPicture (on AppBar leading) load asset logo using AssetsConsts.logo',
    );
    expect(
      (leading.child as SvgPicture).colorFilter,
      const ColorFilter.mode(
        MainColor.whiteF2F0EB,
        BlendMode.srcIn,
      ),
      reason:
          'The SvgPicture (on AppBar leading) color filter must match as specified',
    );

    expect(
      appBar.title,
      isA<Padding>(),
      reason: 'AppBar title should be a Padding widget',
    );
    final title = appBar.title as Padding;

    expect(
      (title.padding as EdgeInsets).vertical,
      16,
      reason: 'Padding (AppBar title) padding vertical should be 8',
    );
    expect(title.child, isA<SvgPicture>());
    expect(
      (title.child as SvgPicture).bytesLoader,
      const SvgAssetLoader(
        AssetsConsts.logoName,
      ),
      reason:
          'Expected SvgPicture (on AppBar title) load asset logo using AssetsConsts.logoName',
    );
    expect(
      (title.child as SvgPicture).width,
      120,
      reason:
          'The expected width of the SvgPicture (in the AppBar title) is 120',
    );
    expect(
      (title.child as SvgPicture).colorFilter,
      const ColorFilter.mode(
        MainColor.whiteF2F0EB,
        BlendMode.srcIn,
      ),
      reason:
          'The SvgPicture (on AppBar title) color filter must match as specified',
    );
  });

  testWidgets('CustomAppBar widget display provided leading and title widget',
      (WidgetTester tester) async {
    const leadingWidget = Icon(
      Icons.arrow_back_ios_new_sharp,
      size: 18,
      color: MainColor.whiteFFFFFF,
    );

    const titleWidget = Text('title');

    await tester.pumpWidget(
      const MaterialApp(
        home: CustomAppBar(
          leading: leadingWidget,
          title: titleWidget,
        ),
      ),
    );

    final customAppBarFinder = find.byType(CustomAppBar);
    expect(
      customAppBarFinder,
      findsOneWidget,
      reason: 'Expected to find CustomAppBar widget in widget tree',
    );
    final customAppBar = tester.widget<PreferredSizeWidget>(customAppBarFinder);
    expect(
      customAppBar.preferredSize,
      const Size.fromHeight(56),
      reason: 'CustomAppBar should have preferred height of 56',
    );

    final appBarFinder = find.byType(AppBar);
    expect(
      appBarFinder,
      findsOneWidget,
      reason: 'Expected to find an AppBar widget as its root widget',
    );

    final appBar = tester.widget<AppBar>(appBarFinder);
    expect(
      appBar.backgroundColor,
      MainColor.purple5A579C,
      reason: 'AppBar background color should match MainColor.purple5A579C',
    );
    expect(
      appBar.titleSpacing,
      0,
      reason: 'AppBar titleSpacing should be 0',
    );

    expect(
      appBar.leading,
      isA<Padding>(),
      reason: 'AppBar leading should be a Padding widget',
    );
    final leading = appBar.leading as Padding;

    expect(
      leading.child,
      isA<Icon>(),
      reason:
          'Padding (AppBar leading) child does not match as given parameters [leading]',
    );
    expect(
      (leading.child as Icon).icon,
      Icons.arrow_back_ios_new_sharp,
      reason:
          'Padding (AppBar leading) child does not match as given parameters [leading]',
    );
    expect(
      (leading.child as Icon).color,
      MainColor.whiteFFFFFF,
      reason:
          'Padding (AppBar leading) child does not match as given parameters [leading]',
    );
    expect(
      (leading.child as Icon).size,
      18,
      reason:
          'Padding (AppBar leading) child does not match as given parameters [leading]',
    );

    expect(appBar.title, isA<Padding>());
    final title = appBar.title as Padding;

    expect(title.child, isA<Text>());
    expect(
      (title.child as Text).data,
      titleWidget.data,
      reason:
          'Padding (AppBar title) child does not match as given parameters [title]',
    );
  });

  testWidgets('Structur of CoverMusicCard widget is built correctly',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'Night Changes',
      artist: 'One Direction',
      coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
      sourceType: 'local',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));
    // Find the widget in the test environment
    final coverMusicCard = find.byType(CoverMusicCard);
    expect(
      coverMusicCard,
      findsOneWidget,
      reason: 'CoverMusicCard widget not found in the widget tree',
    );

    // Verify the structure of the widget
    final gestureDetectorFinder = find.byType(GestureDetector);
    expect(
      gestureDetectorFinder,
      findsOneWidget,
      reason: 'Missing GestureDetector root widget within CoverMusicCard',
    );
    final gestureDetector =
        tester.widget<GestureDetector>(gestureDetectorFinder);
    expect(
      gestureDetector.child,
      isA<Stack>(),
      reason: 'GestureDetector child should be a Stack widget',
    );

    final stack = gestureDetector.child as Stack;
    expect(
      stack.alignment,
      Alignment.bottomCenter,
      reason: 'Stack alignment should be Alignment.bottomCenter',
    );
    expect(
      stack.children.length,
      2,
      reason: 'Expected Stack to have exactly 2 child widgets',
    );

    // Check for the container
    final imageContainer = find.descendant(
      of: find.byType(Stack),
      matching: find.byWidgetPredicate((widget) {
        // ignore: sized_box_for_whitespace
        final mockContainer = Container(
          width: 190,
          height: 200,
        );

        return widget is Container &&
            widget.decoration is ShapeDecoration &&
            widget.constraints == mockContainer.constraints;
      }),
    );
    expect(
      imageContainer,
      findsOneWidget,
      reason:
          'Expected a Container with specific properties as a child of Stack',
    );

    // Check for the positioned
    final positioned = find.descendant(
      of: find.byType(Stack),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Positioned &&
            widget.bottom == -1 &&
            widget.child is ClipRRect,
      ),
    );
    expect(
      positioned,
      findsOneWidget,
      reason:
          'Expected a Positioned widget with bottom: -1 and ClipRRect child',
    );

    final clipRRectFinder = find.descendant(
      of: positioned,
      matching: find.byType(ClipRRect),
    );
    expect(
      clipRRectFinder,
      findsOneWidget,
      reason: 'Expected ClipRRect widget within the positioned element',
    );
    final clipRRect = tester.widget<ClipRRect>(clipRRectFinder);
    expect(
      (clipRRect.borderRadius as BorderRadius).bottomLeft,
      const Radius.circular(36),
      reason: 'ClipRRect bottomLeft borderRadius should be Radius.circular(36)',
    );
    expect(
      (clipRRect.borderRadius as BorderRadius).bottomRight,
      const Radius.circular(36),
      reason:
          'ClipRRect bottomRight borderRadius should be Radius.circular(36)',
    );

    // Check for the BackdropFilter
    final backdropFilter = find.descendant(
      of: find.byType(ClipRect),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is BackdropFilter &&
            widget.filter == ImageFilter.blur(sigmaX: 5, sigmaY: 5) &&
            widget.child is Container,
      ),
    );
    expect(
      backdropFilter,
      findsOneWidget,
      reason:
          'Expected BackdropFilter widget with specific properties within ClipRect',
    );

    // Check for the text container
    final textContainerFinder = find.descendant(
      of: find.byType(BackdropFilter),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.alignment == Alignment.centerLeft &&
            widget.decoration is BoxDecoration &&
            widget.child is Column,
      ),
    );
    expect(
      textContainerFinder,
      findsOneWidget,
      reason:
          'Expected Container widget with specific properties within BackdropFilter',
    );

    final textContainer = tester.widget<Container>(textContainerFinder);
    expect(
      (textContainer.padding as EdgeInsets).horizontal,
      48,
      reason:
          'Container (within BackdropFilter) padding should have horizontal padding of 24',
    );
    expect(
      (textContainer.padding as EdgeInsets).vertical,
      16,
      reason:
          'Container (within BackdropFilter) padding should have vertical padding of 8',
    );

    final textContainerDecoration = textContainer.decoration as BoxDecoration;
    expect(
      textContainerDecoration.gradient,
      isA<LinearGradient>(),
      reason:
          'Container (within BackdropFilter) decoration should be a LinearGradient',
    );
    final linearGradient = textContainerDecoration.gradient as LinearGradient;

    expect(
      linearGradient.begin,
      const Alignment(0.00, -1.00),
      reason: 'LinearGradient begin alignment should be Alignment(0.00, -1.00)',
    );
    expect(
      linearGradient.end,
      const Alignment(0, 1),
      reason: 'LinearGradient end alignment should be Alignment(0, 1)',
    );
    expect(
      linearGradient.colors,
      [
        MainColor.black120911,
        MainColor.black0D0D0D,
      ],
      reason: 'LinearGradient colors should be black120911 and black0D0D0D',
    );

    expect(
      find.text(
        music.title!,
      ),
      findsOneWidget,
      reason:
          'Expected to find the music title text: ${music.title} in CoverMusicCard',
    );
    expect(
      find.text(music.artist!),
      findsOneWidget,
      reason:
          'Expected to find the music artist text: ${music.artist} in CoverMusicCard',
    );
  });

  testWidgets('CoverMusicCard render local source',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'Night Changes',
      artist: 'One Direction',
      coverPath: 'assets/imgs/cover_one_direction_night_changes.jpeg',
      sourceType: 'local',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));

    final imageContainer = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is ShapeDecoration &&
          widget.child == null,
    );
    expect(
      imageContainer,
      findsOneWidget,
      reason:
          'For local music source, Container (first child of Stack) should not have a child',
    );

    final decoration =
        tester.widget<Container>(imageContainer).decoration as ShapeDecoration;
    expect(
      decoration.image,
      isA<DecorationImage>(),
      reason: 'Container decoration should be a DecorationImage',
    );
    expect(
      decoration.image?.image,
      AssetImage(music.coverPath!),
      reason: 'DecorationImage image should be AssetImage with music.coverPath',
    );
    expect(
      decoration.image?.fit,
      BoxFit.cover,
      reason: 'DecorationImage fit should be BoxFit.cover',
    );
    expect(
      decoration.shape,
      isA<RoundedRectangleBorder>(),
      reason: 'Container decoration shape should be a RoundedRectangleBorder',
    );
    expect(
      (decoration.shape as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(36),
      reason:
          'RoundedRectangleBorder borderRadius should be BorderRadius.circular(36)',
    );
  });

  testWidgets('CoverMusicCard render network source',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final music = Music(
      title: 'STAY',
      artist: 'The Kid LAROI, Justin Bieber',
      coverPath:
          'https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_justin_bieber_stay.jpeg?raw=true',
      sourceType: 'network',
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CoverMusicCard(music: music),
      ),
    ));

    // check if container child is ClipRRect when music sourceType is network
    final imageContainer = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration == null &&
          widget.child is ClipRRect,
    );
    expect(
      imageContainer,
      findsOneWidget,
      reason:
          'For network music source, Container (first child of Stack) child should be a ClipRRect widget and its decoration should be null',
    );

    final clipRRect =
        tester.widget<Container>(imageContainer).child as ClipRRect;
    expect(
      clipRRect.borderRadius,
      BorderRadius.circular(36),
      reason:
          'ClipRRect (child of container) borderRadius should be Radius.circular(36)',
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
      music.coverPath,
      reason: 'CachedNetworkImage imageUrl should match music.coverPath',
    );

    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
      reason:
          'Expected to find a CircularProgressIndicator while loading network image',
    );
    expect(
      networkImage.fit,
      BoxFit.cover,
      reason: 'CachedNetworkImage fit should be BoxFit.cover',
    );
  });

  testWidgets('Structure of CoverVideoCard widget is built correctly',
      (WidgetTester tester) async {
    // Create a mock Music object for testing
    final video = Video(
      title: "Aquaman And The Lost Kingdom | Trailer",
      creator: "DC",
      releaseDate: "2023-09-14",
      sourceType: "local",
      source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
      coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
      viewsCount: 1082000,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));
    // Find the widget in the test environment
    final coverVideoCard = find.byType(CoverVideoCard);
    expect(
      coverVideoCard,
      findsOneWidget,
      reason: 'CoverVideoCard widget not found in the widget tree',
    );

    // Verify the structure of the widget
    final gestureDetectorFinder = find.byType(GestureDetector);
    expect(
      gestureDetectorFinder,
      findsOneWidget,
      reason: 'Missing GestureDetector root widget within CoverVideoCard',
    );
    final gestureDetector =
        tester.widget<GestureDetector>(find.byType(GestureDetector));
    expect(
      gestureDetector.child,
      isA<Column>(),
      reason:
          "GestureDetector child should be a Column (with Key('column_card_wrapper')) widget",
    );
    final column = gestureDetector.child as Column;
    expect(
      column.crossAxisAlignment,
      CrossAxisAlignment.start,
      reason: 'Column crossAxisAlignment should be CrossAxisAlignment.start',
    );

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270,
      ),
    );
    expect(
      imageWrapper,
      findsOneWidget,
      reason:
          'Expected SizedBox with specific dimensions for image wrapper not found',
    );

    final infoWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) => widget is Padding && widget.child is Column,
      ),
    );
    expect(
      infoWrapper,
      findsOneWidget,
      reason:
          'Expected Padding widget (within column_card_wrapper) with Column child not found',
    );

    final columnFinder =
        find.descendant(of: infoWrapper, matching: find.byType(Column));
    expect(
      columnFinder,
      findsOneWidget,
      reason: 'Column within Padding widget not found',
    );

    final columnInfoWrapper = tester.widget<Column>(columnFinder);
    expect(
      columnInfoWrapper.crossAxisAlignment,
      CrossAxisAlignment.start,
      reason:
          'Inner Column within Padding should have CrossAxisAlignment.start',
    );

    // assert video title
    final videoTitleFinder = find.descendant(
      of: infoWrapper,
      matching: find.text(video.title!),
    );
    expect(
      videoTitleFinder,
      findsOneWidget,
      reason:
          'Expected to find the video title text: ${video.title} within Padding widget',
    );
    final videoTitle = tester.widget<Text>(videoTitleFinder);

    expect(
      videoTitle.maxLines,
      2,
      reason: 'Video title should have maxLines set to 2',
    );
    expect(
      videoTitle.overflow,
      TextOverflow.ellipsis,
      reason: 'Video title text overflow should be TextOverflow.ellipsis',
    );
    expect(
      videoTitle.style,
      MainTextStyle.poppinsW700.copyWith(
        fontSize: 15,
        color: MainColor.whiteF2F0EB,
      ),
      reason:
          'Video title text style should be poppinsW700 with 15 fontSize and MainColor.whiteF2F0EB color',
    );

    // assert other video data
    final wrapFinder =
        find.descendant(of: columnFinder, matching: find.byType(Wrap));
    expect(
      wrapFinder,
      findsOneWidget,
      reason: 'Expected Wrap widget within Column (Padding child) widget',
    );
    final expectedString = [
      video.creator!,
      "${video.viewsCount!.formatViewsCount()} x views",
      video.releaseDate!.toLocalTime()
    ];
    for (var text in expectedString) {
      final videoDataFinder = find.descendant(
        of: wrapFinder,
        matching: find.text(text),
      );
      expect(
        videoDataFinder,
        findsOneWidget,
        reason: 'Expected to find video data text: $text',
      );
      final videoDataText = tester.widget<Text>(videoDataFinder);
      expect(
        videoDataText.overflow,
        TextOverflow.ellipsis,
        reason: 'Video data text overflow should be TextOverflow.ellipsis',
      );
      expect(
        videoDataText.style,
        MainTextStyle.poppinsW400.copyWith(
          fontSize: 12,
          color: MainColor.whiteF2F0EB,
        ),
        reason:
            'Video data text style should be poppinsW400 with 12 fontSize and MainColor.whiteF2F0EB color',
      );
    }

    expect(
      find.descendant(of: wrapFinder, matching: find.byType(DotDivider)),
      findsAtLeastNWidgets(2),
      reason:
          'Expected to find at least 2 DotDivider widgets within Wrap widget',
    );
  });

  testWidgets('CoverVideoCard render local source',
      (WidgetTester tester) async {
    final video = Video(
      title: "Aquaman And The Lost Kingdom | Trailer",
      creator: "DC",
      releaseDate: "2023-09-14",
      sourceType: "local",
      source: "assets/videos/aquaman_and_the_lost_kingdom_trailer.mp4",
      coverPath: "assets/imgs/cover_aquaman_and_the_lost_kingdom_trailer.jpeg",
      viewsCount: 1082000,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270 &&
            widget.child is Image,
        description:
            'Expected a SizedBox with specific dimensions and Image child as a descendant of Key(column_card_wrapper) for local source',
      ),
    );
    expect(
      imageWrapper,
      findsOneWidget,
      reason:
          'Expected SizedBox with specific properties within widget with column_card_wrapper key for local video source not found',
    );

    final image = (tester.widget<SizedBox>(imageWrapper).child as Image).image;
    if (image is AssetImage) {
      expect(
        image.assetName,
        video.coverPath!,
        reason: 'Image assetName should match video.coverPath',
      );
    } else if (image is ExactAssetImage) {
      expect(
        image.assetName,
        video.coverPath!,
        reason: 'Image assetName should match video.coverPath',
      );
    } else {
      fail('Unexpected asset image widget found | use Image.asset instead');
    }
  });

  testWidgets('CoverVideoCard render network source',
      (WidgetTester tester) async {
    final video = Video(
      title: "FutureBuilder (Widget of the Week)",
      creator: "Flutter",
      releaseDate: "2018-01-23",
      sourceType: "network",
      source:
          "https://github.com/AkhmadhetaHPras/host-assets/raw/main/media-player/flutter_future_builder_widget_of_the_week.mp4",
      coverPath:
          "https://github.com/AkhmadhetaHPras/host-assets/blob/main/media-player/cover_flutter_future_builder_widget_of_the_week.jpeg?raw=true",
      viewsCount: 80912801,
    );

    // Build the widget
    await tester.pumpWidget(MediaQuery(
      data: const MediaQueryData(size: Size(480, 800)),
      child: MaterialApp(
        home: Scaffold(
          body: CoverVideoCard(video: video),
        ),
      ),
    ));

    final imageWrapper = find.descendant(
      of: find.byKey(const Key('column_card_wrapper')),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == double.infinity &&
            widget.height == 270 &&
            widget.child is ClipRRect,
        description:
            'Expected a SizedBox with specific dimensions and ClipRRect child as a descendant of Key(column_card_wrapper) for network source',
      ),
    );
    expect(
      imageWrapper,
      findsOneWidget,
      reason:
          'Expected SizedBox with specific properties within widget with column_card_wrapper key for network video source not found',
    );

    // here
    final clipRRect = tester.widget<SizedBox>(imageWrapper).child as ClipRRect;
    expect(
      clipRRect.child,
      isA<CachedNetworkImage>(),
      reason:
          'ClipRRect child should be a CachedNetworkImage for network source, found ${clipRRect.child}',
    );

    final networkImage = clipRRect.child as CachedNetworkImage;
    expect(
      networkImage.imageUrl,
      video.coverPath,
      reason: 'CachedNetworkImage imageUrl should match video.coverPath',
    );

    expect(
      find.byType(CircularProgressIndicator),
      findsOneWidget,
      reason:
          'Expected to find a CircularProgressIndicator while loading network image',
    );
    expect(
      networkImage.fit,
      BoxFit.cover,
      reason: 'CachedNetworkImage fit should be BoxFit.cover',
    );
  });

  testWidgets('Structur of TitleSection is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: TitleSection(title: 'Title Test'),
      ),
    ));

    expect(
      find.byType(TitleSection),
      findsOneWidget,
      reason: 'Expected to find a TitleSection widget in the widget tree',
    );
    final paddingFinder = find.byType(Padding);
    expect(
      paddingFinder,
      findsOneWidget,
      reason: 'Expected Padding widget as TitleSection root widget',
    );
    final padding = tester.widget<Padding>(paddingFinder);
    expect(
      (padding.padding as EdgeInsets).horizontal,
      30,
      reason: 'Padding should have a horizontal value of 15',
    );
    expect(
      (padding.padding as EdgeInsets).vertical,
      20,
      reason: 'Padding should have a vertical value of 10',
    );
    expect(
      padding.child,
      isA<Text>(),
      reason: 'Padding should have a Text child within it',
    );

    final textFinder = find.byType(Text);
    expect(
      textFinder,
      findsOneWidget,
      reason: 'Expected to find a Text widget within the Padding',
    );
    final text = tester.widget<Text>(textFinder);
    expect(
      text.data,
      'Title Test',
      reason: 'Text content should match the provided title',
    );
    expect(
      text.style,
      MainTextStyle.poppinsW600.copyWith(
        fontSize: 20,
        color: MainColor.whiteF2F0EB,
      ),
      reason: 'Text style should match the expected style',
    );
    expect(
      find.text('Title Test'),
      findsOneWidget,
      reason: 'TitleSection title text not found',
    );
  });

  /// HOME TEST
  testWidgets('Home display music and video list', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      key: Key('second_test'),
      home: Scaffold(
        body: Home(),
      ),
    ));

    final musicTitle = find.byWidgetPredicate((widget) =>
        widget is TitleSection && widget.title == 'Music Collections');
    expect(
      musicTitle,
      findsOneWidget,
      reason:
          'Expected to find a TitleSection widget with title "Music Collections"',
    );

    final listWrapper = find.byWidgetPredicate(
      (widget) =>
          widget is SizedBox &&
          widget.height! == 200 &&
          widget.child is ListView &&
          widget.child?.key == const Key('music_list_view'),
    );
    expect(
      listWrapper,
      findsOneWidget,
      reason:
          'Music list view must be wrapped in a SizedBox with a height of 200',
    );

    final musicListFinder = find.byKey(const Key('music_list_view'));
    expect(
      musicListFinder,
      findsOneWidget,
      reason: 'Expected to find a ListView with key "music_list_view"',
    );
    final musicList = tester.widget<ListView>(musicListFinder);
    expect(
      musicList.scrollDirection,
      Axis.horizontal,
      reason: 'Music list scroll direction should be horizontal',
    );

    final videoTitle = find.byWidgetPredicate(
        (widget) => widget is TitleSection && widget.title == 'Videos');
    expect(
      videoTitle,
      findsOneWidget,
      reason: 'Expected to find a TitleSection widget with title "Videos"',
    );

    final videoListFinder = find.byKey(const Key('video_list_view'));
    expect(
      videoListFinder,
      findsOneWidget,
      reason: 'Expected to find a ListView with key "video_list_view"',
    );
    final videoList = tester.widget<ListView>(videoListFinder);
    expect(
      videoList.physics,
      const NeverScrollableScrollPhysics(),
      reason: 'Video list should be disabled for scrolling',
    );
    expect(
      videoList.shrinkWrap,
      true,
      reason: 'Video list should use shrinkWrap to fit its children',
    );

    await tester.pump();
    expect(
      find.byType(CoverMusicCard),
      findsWidgets,
      reason: 'Expected to find instances of CoverMusicCard in the Home widget',
    );
    expect(
      find.byType(CoverVideoCard),
      findsWidgets,
      reason: 'Expected to find instances of CoverVideoCard in the Home widget',
    );
  });

  testWidgets('Structur of Home is built correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    ));

    expect(
      find.byType(Home),
      findsOneWidget,
      reason: 'Expected to find a Home widget in the widget tree',
    );
    final singleChildScrollViewFinder =
        find.byType(SingleChildScrollView).first;
    expect(
      singleChildScrollViewFinder,
      findsOneWidget,
      reason: 'Home should have SingleChildScrollView as its root widget',
    );

    final singleChildScrollView =
        tester.widget<SingleChildScrollView>(singleChildScrollViewFinder);
    expect(
      singleChildScrollView.child,
      isA<SafeArea>(),
      reason: 'SingleChildScrollView child should be a SafeArea widget',
    );

    expect(
      (singleChildScrollView.child as SafeArea).child,
      isA<Column>(),
      reason: 'SafeArea child should be a Column widget',
    );
    final column = (singleChildScrollView.child as SafeArea).child as Column;
    expect(
      column.mainAxisAlignment,
      MainAxisAlignment.start,
      reason: 'Column (SafeArea child) should have MainAxisAlignment.start',
    );
    expect(column.crossAxisAlignment, CrossAxisAlignment.start,
        reason: 'Column (SafeArea child) should have CrossAxisAlignment.start');

    final columnFinder = find.descendant(
        of: find.byType(SafeArea), matching: find.byType(Column).first);
    final titleSectionsFinder = find.descendant(
      of: columnFinder,
      matching: find.byType(TitleSection),
    );
    expect(
      titleSectionsFinder,
      findsNWidgets(2),
      reason:
          'Expected to find 2 TitleSection widgets within the Column (SafeArea child)',
    );

    final musicListViewWrapperFinder = find.descendant(
        of: columnFinder, matching: find.byType(SizedBox).first);
    expect(
      musicListViewWrapperFinder,
      findsOneWidget,
      reason:
          'Expected a SizedBox wrapper for the music list view within Column (SafeArea child)',
    );
    final musicListViewWrapper =
        tester.widget<SizedBox>(musicListViewWrapperFinder);
    expect(
      musicListViewWrapper.height,
      200,
      reason: 'Music list view wrapper height should be 200',
    );
    expect(
      musicListViewWrapper.child,
      isA<ListView>(),
      reason: 'Music list view wrapper child should be a ListView',
    );
    expect(
      musicListViewWrapper.child?.key,
      const Key('music_list_view'),
      reason:
          'Music list view wrapper child key should be widget with "music_list_view" key',
    );

    final musicListViewFinder = find.byKey(const Key('music_list_view'));
    expect(
      musicListViewFinder,
      findsOneWidget,
      reason: 'Expected to find a ListView with key "music_list_view"',
    );
    expect(
      musicListViewFinder.evaluate().single.widget,
      isA<ListView>(),
      reason: 'Widget with "music_list_view" key should be a ListView',
    );

    final videoListViewFinder = find.byKey(const Key('video_list_view'));
    expect(
      videoListViewFinder,
      findsOneWidget,
      reason: 'Expected to find a ListView with key "video_list_view"',
    );
    expect(
      videoListViewFinder.evaluate().single.widget,
      isA<ListView>(),
      reason: 'Widget with "video_list_view" key should be a ListView',
    );
  });
}
