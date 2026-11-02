import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_portfolio/app/app.dart';
import 'package:just_portfolio/features/home/data/portfolio_content.dart';

import 'support/widget_test_support.dart';

void main() {
  configureStrictHitTesting();

  test('C1 실제 콘텐츠의 섹션 ID는 중복되지 않는다', () {
    final ids = PortfolioContent.data.sections
        .map((section) => section.id)
        .toList();
    expect(
      ids.toSet().length,
      ids.length,
      reason: 'sections에 같은 ID가 두 번 들어 있습니다: $ids',
    );
  });

  test('C2 실제 콘텐츠의 프로젝트 ID는 중복되지 않는다', () {
    final ids = PortfolioContent.data.projects
        .map((project) => project.id)
        .toList();
    expect(
      ids.toSet().length,
      ids.length,
      reason: 'projects에 같은 ID가 두 번 들어 있습니다: $ids',
    );
  });

  for (final size in [const Size(390, 844), const Size(1440, 900)]) {
    testWidgets('C3 실제 콘텐츠로 전체 화면이 예외 없이 렌더링된다: $size', (tester) async {
      await pumpTestApp(tester, const AppBrandSite(), size: size);
      expect(tester.takeException(), isNull);
    });
  }
}
