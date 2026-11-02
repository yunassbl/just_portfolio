import 'package:flutter/material.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_about_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_capabilities_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_case_studies_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_contact_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_intro_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_project_archive_section.dart';
import 'package:just_portfolio/features/home/presentation/sections/portfolio_tech_stack_section.dart';
import 'package:just_portfolio/features/home/presentation/widgets/credit_index.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scene_section.dart';

class BrandHomePage extends StatefulWidget {
  const BrandHomePage({super.key, required this.content});

  final PortfolioData content;

  List<SectionIndexItem> get sections => content.sections;

  @override
  State<BrandHomePage> createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  final _scrollController = ScrollController();
  final _activeIndex = ValueNotifier<int>(0);
  final _progress = ValueNotifier<double>(0);
  final Map<PortfolioSection, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    _syncSectionKeys();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void didUpdateWidget(covariant BrandHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncSectionKeys();
    if (_activeIndex.value >= widget.sections.length) _activeIndex.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  void _syncSectionKeys() {
    final ids = widget.sections.map((section) => section.id).toSet();
    assert(ids.length == widget.sections.length, '섹션 ID는 중복될 수 없습니다.');
    _sectionKeys.removeWhere((id, _) => !ids.contains(id));
    for (final id in ids) {
      _sectionKeys.putIfAbsent(id, () => GlobalKey());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _activeIndex.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return;
    _progress.value = position.maxScrollExtent > 0
        ? (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0)
        : 0;

    var nextIndex = 0;
    var closestDistance = double.infinity;
    for (final (index, section) in widget.sections.indexed) {
      final renderObject = _sectionKeys[section.id]?.currentContext
          ?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) continue;
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final distance = (top - position.viewportDimension * 0.28).abs();
      if (distance < closestDistance) {
        closestDistance = distance;
        nextIndex = index;
      }
    }
    if (_activeIndex.value != nextIndex) _activeIndex.value = nextIndex;
  }

  Future<void> _scrollToSection(PortfolioSection id) async {
    final targetContext = _sectionKeys[id]?.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 460),
      curve: Curves.easeOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth >= 1000;
          final content = _MainScrollContent(
            content: widget.content,
            controller: _scrollController,
            sectionKeys: _sectionKeys,
            viewportHeight: constraints.maxHeight,
            desktop: desktop,
            onWorkPressed: _sectionKeys.containsKey(PortfolioSection.projects)
                ? () => _scrollToSection(PortfolioSection.projects)
                : null,
            onContactPressed: _sectionKeys.containsKey(PortfolioSection.contact)
                ? () => _scrollToSection(PortfolioSection.contact)
                : null,
          );
          final navigation = ValueListenableBuilder<int>(
            valueListenable: _activeIndex,
            builder: (context, activeIndex, _) {
              return ValueListenableBuilder<double>(
                valueListenable: _progress,
                builder: (context, progress, _) {
                  if (desktop) {
                    return CreditIndex(
                      name: widget.content.name,
                      sections: widget.sections,
                      activeIndex: activeIndex,
                      progress: progress,
                      onSectionTap: _scrollToSection,
                    );
                  }
                  return MobileSectionHeader(
                    sections: widget.sections,
                    activeIndex: activeIndex,
                    progress: progress,
                  );
                },
              );
            },
          );
          return SelectionArea(
            child: Stack(
              children: [
                if (desktop && widget.sections.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      navigation,
                      Expanded(child: content),
                    ],
                  )
                else
                  content,
                if (!desktop && widget.sections.isNotEmpty)
                  Align(alignment: Alignment.topCenter, child: navigation),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MainScrollContent extends StatelessWidget {
  const _MainScrollContent({
    required this.content,
    required this.controller,
    required this.sectionKeys,
    required this.viewportHeight,
    required this.desktop,
    required this.onWorkPressed,
    required this.onContactPressed,
  });

  final ScrollController controller;
  final PortfolioData content;
  final Map<PortfolioSection, GlobalKey> sectionKeys;
  List<SectionIndexItem> get sections => content.sections;
  final double viewportHeight;
  final bool desktop;
  final VoidCallback? onWorkPressed;
  final VoidCallback? onContactPressed;

  Widget _buildSection(PortfolioSection id) => switch (id) {
    PortfolioSection.intro => PortfolioIntroSection(
      content: content,
      controller: controller,
      onWorkPressed: onWorkPressed,
      onContactPressed: onContactPressed,
    ),
    PortfolioSection.about => PortfolioAboutSection(
      controller: controller,
      paragraphs: content.aboutParagraphs,
    ),
    PortfolioSection.capabilities => PortfolioCapabilitiesSection(
      controller: controller,
      capabilities: content.capabilities,
    ),
    PortfolioSection.caseStudies => PortfolioCaseStudiesSection(
      controller: controller,
      caseStudies: content.caseStudies,
    ),
    PortfolioSection.projects => PortfolioProjectArchiveSection(
      controller: controller,
      projects: content.projects,
    ),
    PortfolioSection.stack => PortfolioTechStackSection(
      controller: controller,
      groups: content.techStackGroups,
    ),
    PortfolioSection.contact => PortfolioContactSection(
      controller: controller,
      content: content,
    ),
  };

  double _heightFactor(PortfolioSection id) => switch (id) {
    PortfolioSection.intro => 0.96,
    PortfolioSection.about => 0.7,
    PortfolioSection.capabilities => 0.72,
    PortfolioSection.caseStudies ||
    PortfolioSection.projects ||
    PortfolioSection.contact => 0.9,
    PortfolioSection.stack => 0.68,
  };

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return const Center(child: Text('표시할 섹션이 없습니다.'));
    }
    return SingleChildScrollView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(
        desktop ? 52 : 18,
        desktop ? 0 : 86,
        desktop ? 52 : 18,
        0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (index, section) in sections.indexed)
                KeyedSubtree(
                  key: ValueKey(section.id),
                  child: SceneSection(
                    key: sectionKeys[section.id],
                    minHeight: viewportHeight * _heightFactor(section.id),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (section.id != PortfolioSection.intro) ...[
                          SectionHeading(
                            controller: controller,
                            number: (index + 1).toString().padLeft(2, '0'),
                            title: section.label,
                          ),
                          SizedBox(
                            height: section.id == PortfolioSection.contact
                                ? 40
                                : 32,
                          ),
                        ],
                        _buildSection(section.id),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
    );
  }
}
