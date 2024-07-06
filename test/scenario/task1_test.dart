import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/config/themes/main_color.dart';
import 'package:media_player/constants/assets_const.dart';
import 'package:media_player/features/splash/components/circle_component.dart';
import 'package:media_player/features/splash/splash_screen.dart';

void main() {
  testWidgets('Structure of the CircleComponent widget is built correctly',
      (WidgetTester tester) async {
    const double scale = 1.5;
    await tester.pumpWidget(const CircleComponent(scale: scale));

    // Find the CircleComponent in the widget tree
    final circle = find.byType(CircleComponent);
    expect(
      circle,
      findsOneWidget,
      reason: 'CircleComponent widget not found',
    );

    // Assert the ClipRRect and Transform.scale properties
    final clipRectFinder = find.byType(ClipRRect).first;
    expect(
      clipRectFinder,
      findsOneWidget,
      reason: 'ClipRRect widget not found within CircleComponent',
    );

    final clipRRect = tester.widget<ClipRRect>(clipRectFinder);
    expect(
      clipRRect.child,
      isA<Transform>(),
      reason:
          'Expected a Transform widget as child of ClipRRect, found ${clipRRect.child}',
    );

    final transform = clipRRect.child as Transform;
    expect(
      transform.transform,
      Matrix4.diagonal3Values(scale, scale, 1),
      reason: 'Transform.scale does not match expected value.',
    );

    // Assert the default Container child
    expect(
      transform.child,
      isA<Container>(),
      reason:
          'Expected a Container widget as child of Transform, found ${transform.child}',
    );
    final container = transform.child as Container;

    expect(
      container.decoration,
      isA<BoxDecoration>(),
      reason:
          'Expected a BoxDecoration for Container decoration, found ${container.decoration}',
    );
    final decoration = container.decoration as BoxDecoration;

    expect(
      decoration.shape,
      equals(BoxShape.circle),
      reason: 'Container decoration shape is not BoxShape.circle',
    );
    expect(
      decoration.color,
      isNull,
      reason: 'Container decoration color is not null',
    );
  });

  testWidgets('CircleComponent renders with color',
      (WidgetTester tester) async {
    const color = Colors.blue;
    await tester.pumpWidget(const CircleComponent(scale: 2.0, color: color));

    final container = tester.widget<Container>(find.byType(Container));
    expect(
      (container.decoration as BoxDecoration).color,
      color,
      reason: 'Container decoration color does not match provided color.',
    );
  });

  testWidgets('CircleComponent renders with child',
      (WidgetTester tester) async {
    final child = Container(
      key: const Key('child_test'),
    );
    await tester.pumpWidget(CircleComponent(
      scale: 1.2,
      child: child,
    ));

    final childFinder = find.byWidgetPredicate((widget) =>
        widget.key == const Key('child_test') && widget is Container);
    expect(childFinder, findsOneWidget,
        reason:
            'Child widgets passed in via parameters are not found in CircleComponent.');
  });

  group('SplashScreen built to specifications:', () {
    final routes = <String, WidgetBuilder>{
      '/home': (_) => const Scaffold(
            body: Text('Home Screen'),
          ),
    };
    testWidgets('has animated opacity with CircleComponent',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      // Verify widget structure
      expect(
        find.byType(Scaffold),
        findsOneWidget,
        reason: 'Scafold widget not found within SplashScreen',
      );
      expect(
        find.byType(SafeArea),
        findsOneWidget,
        reason: 'SafeArea widget not found within SplashScreen',
      );
      expect(
        find.byType(AnimatedOpacity),
        findsNWidgets(5),
        reason: 'Expected 5 AnimatedOpacity widgets in SplashScreen',
      );
      expect(
        find.byType(CircleComponent),
        findsNWidgets(5),
        reason: 'Expected 5 CircleComponent widgets in SplashScreen',
      );

      // Initially, all circles should be invisible
      for (int i = 0; i < 5; i++) {
        expect(
          (find.byType(AnimatedOpacity).at(i).evaluate().single.widget
                  as AnimatedOpacity)
              .opacity,
          0,
          reason:
              'AnimatedOpacity at index $i should have initial opacity of 0',
        );
      }

      // verify circle atribut
      final colors = [
        MainColor.grey989794,
        MainColor.greyB6B5B1,
        MainColor.greyD4D2CE,
        MainColor.black222222,
      ];
      final scales = [3, 1.7, 1.3, 0.8];

      for (var i = 0; i < 4; i++) {
        Finder circleDFinder = find.byWidgetPredicate(
          (widget) =>
              widget is CircleComponent &&
              widget.key == Key('circle_${i + 1}') &&
              widget.scale == scales[i] &&
              widget.color == colors[i],
        );
        expect(
          circleDFinder,
          findsOneWidget,
          reason:
              'CircleComponent with key "circle_${i + 1}" not found or has incorrect properties',
        );
      }
      final lastCircleFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CircleComponent &&
            widget.key == const Key('circle_5') &&
            widget.scale == scales[3],
      );
      expect(
        lastCircleFinder,
        findsOneWidget,
        reason:
            'CircleComponent with key "circle_5" not found or has incorrect properties',
      );

      // Trigger animation completion
      await tester.pump(const Duration(milliseconds: 1800));
      for (int i = 0; i < 5; i++) {
        expect(
          (find.byType(AnimatedOpacity).at(i).evaluate().single.widget
                  as AnimatedOpacity)
              .opacity,
          1,
          reason: 'AnimatedOpacity at index $i should have final opacity of 1',
        );
      }
      await tester.pumpAndSettle();
    });

    testWidgets('display the logo using SvgPicture',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      final circleLogoFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CircleComponent &&
            widget.key == const Key('circle_5') &&
            widget.child is SvgPicture,
      );
      expect(
        circleLogoFinder,
        findsOneWidget,
        reason:
            'CircleComponent with key "circle_5" should have SvgPicture child',
      );

      final svgPictureFinder = find.byType(SvgPicture);
      expect(
        svgPictureFinder,
        findsOneWidget,
        reason: 'Expected to find an SvgPicture widget',
      );
      expect(
        tester.widget<SvgPicture>(svgPictureFinder).bytesLoader,
        const SvgAssetLoader(
          AssetsConsts.logo,
        ),
        reason: 'Expected SvgPicture load asset logo using AssetsConsts.logo',
      );

      // Trigger animation completion
      await tester.pumpAndSettle(const Duration(milliseconds: 2200));
    });

    testWidgets('navigate to Home screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      // Trigger animation and navigatin completion
      await tester.pumpAndSettle(const Duration(milliseconds: 2200));

      expect(find.text('Home Screen'), findsOneWidget,
          reason:
              'Splash screen does not automatically push to MainRoute.home');
      expect(find.byType(SplashScreen), findsNothing,
          reason: 'SplashScreen widget should be removed after navigation');
    });
  });
}
