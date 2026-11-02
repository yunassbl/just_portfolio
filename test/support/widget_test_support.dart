import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';

void configureStrictHitTesting() {
  setUp(() {
    final previous = WidgetController.hitTestWarningShouldBeFatal;
    WidgetController.hitTestWarningShouldBeFatal = true;
    addTearDown(() => WidgetController.hitTestWarningShouldBeFatal = previous);
  });
}

Future<void> pumpTestApp(
  WidgetTester tester,
  Widget app, {
  Size size = const Size(1200, 900),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        devicePixelRatio: 1,
        disableAnimations: true,
      ),
      child: app,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpTestHome(
  WidgetTester tester,
  Widget home, {
  Size size = const Size(1200, 900),
}) => pumpTestApp(
  tester,
  MaterialApp(theme: AppTheme.dark(), home: home),
  size: size,
);
