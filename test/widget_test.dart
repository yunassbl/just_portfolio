import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_portfolio/app/app.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_capabilities_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_contact_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_project_archive_section.dart';
import 'package:just_portfolio/features/home/presentation/widgets/credit_index.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';

import 'fixtures/portfolio_fixtures.dart';
import 'support/widget_test_support.dart';

Widget projectPage(ScrollController controller, List<ProjectItem> projects) {
  return Scaffold(
    body: SingleChildScrollView(
      controller: controller,
      child: PortfolioProjectArchiveSection(
        controller: controller,
        projects: projects,
      ),
    ),
  );
}

Future<void> revealButton(WidgetTester tester, Finder button) async {
  await Scrollable.ensureVisible(tester.element(button), alignment: 0.5);
  await tester.pumpAndSettle();
  final header = find.byType(MobileSectionHeader);
  if (header.evaluate().isNotEmpty) {
    expect(
      tester.getTopLeft(button).dy,
      greaterThan(tester.getBottomLeft(header).dy),
    );
  }
}

void expectSections(WidgetTester tester, List<SectionIndexItem> sections) {
  for (final section in sections) {
    expect(find.byKey(ValueKey(section.id)), findsOneWidget);
  }
  final headings = tester.widgetList<SectionHeading>(
    find.byType(SectionHeading),
  );
  final titled = sections.indexed
      .where((entry) => entry.$2.id != PortfolioSection.intro)
      .toList();
  expect(
    headings.map((heading) => heading.title),
    orderedEquals(titled.map((entry) => entry.$2.label)),
  );
  expect(
    headings.map((heading) => heading.number),
    orderedEquals(
      titled.map((entry) => (entry.$1 + 1).toString().padLeft(2, '0')),
    ),
  );
}

void main() {
  configureStrictHitTesting();

  testWidgets('고정 데이터가 앱 제목과 모든 화면 영역에 전달된다', (tester) async {
    final data = fixtureData();
    await pumpTestApp(tester, AppBrandSite(content: data));
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).title,
      data.siteTitle,
    );
    expect(find.text(data.name), findsWidgets);
    expect(find.text(data.role), findsWidgets);
    expect(find.text(fixtureContacts[0].value), findsOneWidget);
    expect(find.text(fixtureContacts[1].value), findsOneWidget);
    expect(find.text(data.aboutParagraphs[0]), findsOneWidget);
    expect(find.text(fixtureCapabilities[0].title), findsOneWidget);
    expect(find.text(data.caseStudies[0].title), findsOneWidget);
    expect(find.text(fixtureProjects[0].title), findsWidgets);
    expect(find.text(data.techStackGroups[0].title), findsOneWidget);
    expect(find.text(data.contactMessage), findsOneWidget);
    expectSections(tester, fixtureSections);
    expect(tester.takeException(), isNull);
  });

  testWidgets('F1 프로젝트 0개이면 빈 상태를 표시한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpTestHome(tester, projectPage(controller, const []));
    expect(find.text('아직 등록된 프로젝트가 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('F2 빈 카테고리와 전체 목록 사이를 안전하게 전환한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final projects = [fixtureProjects[0]];
    await pumpTestHome(tester, projectPage(controller, projects));
    await tester.tap(find.text(ProjectCategory.web.label));
    await tester.pumpAndSettle();
    expect(find.text('이 카테고리에 등록된 프로젝트가 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text(ProjectCategory.all.label));
    await tester.pumpAndSettle();
    expect(find.text(projects[0].title), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('F3 역량 0개이면 안내 문구를 표시한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpTestHome(
      tester,
      Scaffold(
        body: PortfolioCapabilitiesSection(
          controller: controller,
          capabilities: const [],
        ),
      ),
    );
    expect(find.text('아직 등록된 역량이 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in [const Size(390, 844), const Size(1440, 900)]) {
    testWidgets('F4 섹션 삭제 시 메뉴와 본문 번호 및 개수가 일치한다: $size', (tester) async {
      final sections = fixtureSections
          .where((section) => section.id != PortfolioSection.caseStudies)
          .toList();
      await pumpTestApp(
        tester,
        AppBrandSite(content: fixtureData(sections: sections)),
        size: size,
      );
      expect(
        find.byKey(const ValueKey(PortfolioSection.caseStudies)),
        findsNothing,
      );
      expectSections(tester, sections);
      final navigation = find.byType(CreditIndex);
      if (navigation.evaluate().isNotEmpty) {
        for (final section in sections) {
          expect(
            find.descendant(of: navigation, matching: find.text(section.label)),
            findsOneWidget,
          );
        }
        expect(
          tester.widget<CreditIndex>(navigation).sections.length,
          sections.length,
        );
      } else {
        final total = sections.length.toString().padLeft(2, '0');
        expect(find.text('01 / $total'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('F5 섹션 재정렬 후 본문과 메뉴가 같은 순서를 따른다: $size', (tester) async {
      const sections = [
        SectionIndexItem(id: PortfolioSection.intro, label: '시작'),
        SectionIndexItem(id: PortfolioSection.contact, label: '문의'),
        SectionIndexItem(id: PortfolioSection.projects, label: '작업'),
        SectionIndexItem(id: PortfolioSection.about, label: '소개'),
      ];
      await pumpTestApp(
        tester,
        AppBrandSite(content: fixtureData(sections: sections)),
        size: size,
      );
      expectSections(tester, sections);
      for (var index = 1; index < sections.length; index++) {
        final before = find.byKey(ValueKey(sections[index - 1].id));
        final after = find.byKey(ValueKey(sections[index].id));
        expect(
          tester.getTopLeft(before).dy,
          lessThan(tester.getTopLeft(after).dy),
        );
      }
      final navigation = find.byType(CreditIndex);
      if (navigation.evaluate().isNotEmpty) {
        for (var index = 1; index < sections.length; index++) {
          final before = find.descendant(
            of: navigation,
            matching: find.text(sections[index - 1].label),
          );
          final after = find.descendant(
            of: navigation,
            matching: find.text(sections[index].label),
          );
          expect(
            tester.getTopLeft(before).dy,
            lessThan(tester.getTopLeft(after).dy),
          );
        }
      } else {
        final total = sections.length.toString().padLeft(2, '0');
        expect(find.text('01 / $total'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    });

    for (final target in [
      (PortfolioSection.contact, '연락하기'),
      (PortfolioSection.projects, '프로젝트 보기'),
    ]) {
      testWidgets('F5 재정렬 후 이동 버튼은 ID로 목적지에 도착한다: $target / $size', (
        tester,
      ) async {
        const sections = [
          SectionIndexItem(id: PortfolioSection.intro, label: '시작'),
          SectionIndexItem(id: PortfolioSection.contact, label: '문의'),
          SectionIndexItem(id: PortfolioSection.projects, label: '작업'),
          SectionIndexItem(id: PortfolioSection.about, label: '소개'),
        ];
        await pumpTestApp(
          tester,
          AppBrandSite(content: fixtureData(sections: sections)),
          size: size,
        );
        final button = find.text(target.$2);
        await revealButton(tester, button);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(
          tester.getTopLeft(find.byKey(ValueKey(target.$1))).dy,
          closeTo(0, 1),
        );
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('F5 데스크톱 메뉴는 ID로 목적지에 이동한다', (tester) async {
    const sections = [
      SectionIndexItem(id: PortfolioSection.intro, label: '시작'),
      SectionIndexItem(id: PortfolioSection.contact, label: '문의'),
      SectionIndexItem(id: PortfolioSection.about, label: '소개'),
    ];
    await pumpTestApp(
      tester,
      AppBrandSite(content: fixtureData(sections: sections)),
    );
    await tester.tap(
      find.descendant(of: find.byType(CreditIndex), matching: find.text('문의')),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey(PortfolioSection.contact)))
          .dy,
      closeTo(0, 1),
    );
    expect(tester.takeException(), isNull);
  });

  for (final missing in [PortfolioSection.projects, PortfolioSection.contact]) {
    testWidgets('F6 목적지 섹션이 없으면 해당 이동 버튼만 숨긴다: $missing', (tester) async {
      final sections = fixtureSections
          .where((section) => section.id != missing)
          .toList();
      await pumpTestApp(
        tester,
        AppBrandSite(content: fixtureData(sections: sections)),
        size: const Size(390, 844),
      );
      expect(
        find.text('프로젝트 보기'),
        missing == PortfolioSection.projects ? findsNothing : findsOneWidget,
      );
      expect(
        find.text('연락하기'),
        missing == PortfolioSection.contact ? findsNothing : findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('F7 섹션 0개이면 빈 상태를 표시한다', (tester) async {
    await pumpTestApp(
      tester,
      AppBrandSite(content: fixtureData(sections: const [])),
    );
    expect(find.text('표시할 섹션이 없습니다.'), findsOneWidget);
    expect(find.byType(CreditIndex), findsNothing);
    expect(find.byType(MobileSectionHeader), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final values in [
    ('', '+1 202 555 0123'),
    ('fixture@example.com', ''),
    ('', ''),
    ('   ', '\t'),
  ]) {
    testWidgets('F8 비어 있는 이메일과 전화번호는 숨긴다: $values', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final data = fixtureData(
        contacts: [
          ContactItem(label: '고정 이메일', value: values.$1),
          ContactItem(label: '고정 전화번호', value: values.$2),
        ],
      );
      await pumpTestHome(
        tester,
        Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: PortfolioContactSection(
              controller: controller,
              content: data,
            ),
          ),
        ),
        size: const Size(390, 844),
      );
      expect(
        find.text('고정 이메일'),
        values.$1.trim().isEmpty ? findsNothing : findsOneWidget,
      );
      expect(
        find.text('고정 전화번호'),
        values.$2.trim().isEmpty ? findsNothing : findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  test('F9 이메일·전화·웹 링크를 구분하고 빈 값과 임의 스킴은 비활성화한다', () {
    expect(portfolioLinkUri('fixture@example.com')?.scheme, 'mailto');
    expect(
      portfolioLinkUri('mailto:fixture@example.com')?.path,
      'fixture@example.com',
    );
    expect(portfolioLinkUri('tel:+12025550123')?.path, '+12025550123');
    expect(
      portfolioLinkUri('+1 (202) 555-0123').toString(),
      'tel:+12025550123',
    );
    expect(portfolioLinkUri('http://example.com')?.scheme, 'http');
    expect(portfolioLinkUri('https://example.com')?.scheme, 'https');
    expect(portfolioLinkUri('example.com')?.host, 'example.com');
    expect(portfolioLinkUri('resume.pdf')?.path, 'resume.pdf');
    expect(portfolioLinkUri(''), isNull);
    expect(portfolioLinkUri('-'), isNull);
    expect(portfolioLinkUri('000-0000-0000'), isNull);
    expect(portfolioLinkUri('javascript:alert(1)'), isNull);
  });

  testWidgets('F10 좁은 화면에서 프로젝트를 실제로 펼칠 수 있다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final project = fixtureProjects[0];
    await pumpTestHome(
      tester,
      projectPage(controller, [project]),
      size: const Size(390, 844),
    );
    await tester.tap(find.text(project.title));
    await tester.pumpAndSettle();
    expect(find.text(project.description), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in [390.0, 700.0, 999.0, 1000.0, 1440.0]) {
    testWidgets('F11 고정 콘텐츠의 폭별 레이아웃이 넘치지 않는다: $width', (tester) async {
      await pumpTestApp(
        tester,
        AppBrandSite(content: fixtureData()),
        size: Size(width, 800),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('실행 중 프로젝트가 전부 삭제되어도 정상적으로 갱신한다', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await pumpTestHome(tester, projectPage(controller, fixtureProjects));
    await pumpTestHome(tester, projectPage(controller, const []));
    expect(find.text('아직 등록된 프로젝트가 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('실행 중 섹션 재정렬과 전체 삭제를 반영한다', (tester) async {
    await pumpTestApp(tester, AppBrandSite(content: fixtureData()));
    await pumpTestApp(
      tester,
      AppBrandSite(
        content: fixtureData(
          sections: const [
            SectionIndexItem(id: PortfolioSection.contact, label: '문의'),
            SectionIndexItem(id: PortfolioSection.intro, label: '시작'),
          ],
        ),
      ),
    );
    expect(find.byType(SectionHeading), findsOneWidget);
    await pumpTestApp(
      tester,
      AppBrandSite(content: fixtureData(sections: const [])),
    );
    expect(find.text('표시할 섹션이 없습니다.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
