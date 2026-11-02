import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

const _mobileSize = Size(390, 844);
const _duration = Duration(milliseconds: 400);
const _delay = Duration(milliseconds: 300);

class _RevealFixture {
  final controller = ScrollController();
  final leadingHeight = ValueNotifier<double>(740);
  final reduceMotion = ValueNotifier<bool>(false);
  final childHeight = ValueNotifier<double>(60);
  var builds = 0;

  Future<void> mount(WidgetTester tester, {Duration delay = _delay}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = _mobileSize;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      leadingHeight.dispose();
      reduceMotion.dispose();
      childHeight.dispose();
    });
    await tester.pumpWidget(
      MediaQuery.fromView(
        view: tester.view,
        child: ValueListenableBuilder<bool>(
          valueListenable: reduceMotion,
          builder: (context, reduceMotion, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(disableAnimations: reduceMotion),
            child: child!,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: leadingHeight,
                    builder: (context, height, child) =>
                        SizedBox(height: height),
                  ),
                  Builder(
                    builder: (context) {
                      builds++;
                      return ScrollReveal(
                        controller: controller,
                        delay: delay,
                        duration: _duration,
                        child: ValueListenableBuilder<double>(
                          valueListenable: childHeight,
                          builder: (context, height, child) => SizedBox(
                            height: height,
                            width: 100,
                            child: const ColoredBox(color: Colors.orange),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 1000),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      MediaQuery.of(
        tester.element(find.byType(ScrollReveal)),
      ).disableAnimations,
      reduceMotion.value,
    );
  }
}

double _opacity(WidgetTester tester) => tester
    .widget<FadeTransition>(
      find.descendant(
        of: find.byType(ScrollReveal),
        matching: find.byType(FadeTransition),
      ),
    )
    .opacity
    .value;

double _translation(WidgetTester tester) => tester
    .widget<Transform>(
      find.descendant(
        of: find.byType(ScrollReveal),
        matching: find.byType(Transform),
      ),
    )
    .transform
    .getTranslation()
    .y;

Future<void> _finishReveal(WidgetTester tester) async {
  await tester.pump(_delay);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  expect(_opacity(tester), inExclusiveRange(0, 1));
  expect(_translation(tester), inExclusiveRange(0, 32 * 0.55));
  await tester.pump(_duration);
  expect(_opacity(tester), 1);
  expect(_translation(tester), 0);
  expect(tester.binding.hasScheduledFrame, isFalse);
}

void main() {
  testWidgets('애니메이션을 켠 첫 진입은 지연 후 fade와 이동을 완료한다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 680;
    await fixture.mount(tester);
    expect(_opacity(tester), 0);
    expect(_translation(tester), 32 * 0.55);
    await tester.pump(const Duration(milliseconds: 299));
    expect(_opacity(tester), 0);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_opacity(tester), inExclusiveRange(0, 1));
    await tester.pump(_duration);
    expect(_opacity(tester), 1);
    expect(_translation(tester), 0);
  });

  testWidgets('조상 레이아웃만 바뀌어 기준선에 진입해도 스크롤 없이 등장한다', (tester) async {
    final fixture = _RevealFixture();
    await fixture.mount(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(_opacity(tester), 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
    final builds = fixture.builds;
    final size = tester.getSize(find.byType(ScrollReveal));

    fixture.leadingHeight.value = 680;
    await tester.pump();
    expect(fixture.builds, builds);
    expect(tester.getSize(find.byType(ScrollReveal)), size);
    expect(tester.getTopLeft(find.byType(ScrollReveal)).dy, 680);
    expect(fixture.controller.offset, 0);
    await _finishReveal(tester);
  });

  testWidgets('자식 높이가 바뀌어 위쪽 가시 기준에 진입해도 재판정한다', (tester) async {
    final fixture = _RevealFixture()
      ..leadingHeight.value = 0
      ..childHeight.value = 40;
    await fixture.mount(tester);
    expect(_opacity(tester), 0); // bottom 40 < 844 * 0.08
    final builds = fixture.builds;
    fixture.childHeight.value = 120;
    await tester.pump();
    expect(fixture.builds, builds);
    expect(fixture.controller.offset, 0);
    await _finishReveal(tester);
  });

  testWidgets('뷰포트 높이가 커져 기준선에 진입하면 스크롤 없이 등장한다', (tester) async {
    final fixture = _RevealFixture();
    await fixture.mount(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(_opacity(tester), 0);

    tester.view.physicalSize = const Size(390, 1000);
    await tester.pump();
    expect(tester.getTopLeft(find.byType(ScrollReveal)).dy, 740);
    expect(fixture.controller.offset, 0);
    await _finishReveal(tester);
  });

  testWidgets('레이아웃·뷰포트 변경 후에도 기준 밖이면 숨고 스크롤 진입 시 등장한다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 1100;
    await fixture.mount(tester);
    fixture.leadingHeight.value = 1000;
    tester.view.physicalSize = const Size(390, 900);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(_opacity(tester), 0);
    expect(_translation(tester), 32 * 0.55);
    expect(tester.binding.hasScheduledFrame, isFalse);

    fixture.controller.jumpTo(350);
    await tester.pump();
    expect(tester.getTopLeft(find.byType(ScrollReveal)).dy, 650);
    await _finishReveal(tester);
  });

  testWidgets('등장한 요소는 재배치·뷰포트 축소·스크롤 후에도 다시 숨지 않는다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 680;
    await fixture.mount(tester);
    await _finishReveal(tester);

    fixture.leadingHeight.value = 1100;
    tester.view.physicalSize = const Size(390, 600);
    await tester.pump();
    expect(_opacity(tester), 1);
    expect(_translation(tester), 0);
    fixture.controller.jumpTo(800);
    await tester.pump();
    fixture.controller.jumpTo(0);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(_opacity(tester), 1);
    expect(_translation(tester), 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('연속 스크롤과 레이아웃 재판정은 예약된 등장 지연을 연장하지 않는다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 680;
    await fixture.mount(tester);
    for (var index = 1; index <= 5; index++) {
      fixture.leadingHeight.value = 680 - index.toDouble();
      fixture.controller.jumpTo(index.toDouble());
      await tester.pump(const Duration(milliseconds: 50));
      expect(_opacity(tester), 0);
    }
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_opacity(tester), inExclusiveRange(0, 1));
    await tester.pump(_duration);
    expect(_opacity(tester), 1);
  });

  testWidgets('모션 줄이기는 화면 밖 요소도 지연 없이 표시하고 설정 해제 후 유지한다', (tester) async {
    final fixture = _RevealFixture()
      ..leadingHeight.value = 1100
      ..reduceMotion.value = true;
    await fixture.mount(tester, delay: const Duration(seconds: 5));
    expect(find.byType(ColoredBox), findsOneWidget);
    expect(find.byType(AnimatedOpacity), findsNothing);
    expect(find.byType(Transform), findsNothing);

    fixture.reduceMotion.value = false;
    await tester.pump();
    expect(_opacity(tester), 1);
    expect(_translation(tester), 0);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('등장 지연 중 모션 줄이기를 켜면 즉시 표시하고 타이머를 정리한다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 680;
    await fixture.mount(tester, delay: const Duration(seconds: 5));
    expect(_opacity(tester), 0);
    fixture.reduceMotion.value = true;
    await tester.pump();
    expect(find.byType(AnimatedOpacity), findsNothing);
    expect(find.byType(Transform), findsNothing);
    fixture.reduceMotion.value = false;
    await tester.pump();
    expect(_opacity(tester), 1);
    expect(_translation(tester), 0);
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });

  testWidgets('등장 지연과 위치 재판정 예약 중 dispose해도 콜백이 남지 않는다', (tester) async {
    final fixture = _RevealFixture()..leadingHeight.value = 680;
    await fixture.mount(tester, delay: const Duration(seconds: 5));
    fixture.controller.jumpTo(1);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 6));
    expect(tester.takeException(), isNull);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });
}
