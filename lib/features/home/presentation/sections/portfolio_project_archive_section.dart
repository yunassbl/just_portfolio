import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioProjectArchiveSection extends StatefulWidget {
  const PortfolioProjectArchiveSection({
    super.key,
    required this.controller,
    required this.projects,
  });

  final ScrollController controller;
  final List<ProjectItem> projects;

  @override
  State<PortfolioProjectArchiveSection> createState() =>
      _PortfolioProjectArchiveSectionState();
}

class _PortfolioProjectArchiveSectionState
    extends State<PortfolioProjectArchiveSection> {
  ProjectCategory _category = ProjectCategory.all;
  String? _selectedId;

  List<ProjectItem> get _filteredProjects {
    if (_category == ProjectCategory.all) return widget.projects;
    return widget.projects
        .where((project) => project.category == _category)
        .toList();
  }

  void _selectCategory(ProjectCategory category) {
    setState(() {
      _category = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filteredProjects;
    final selected = projects.isEmpty
        ? null
        : projects.firstWhere(
            (project) => project.id == _selectedId,
            orElse: () => projects.first,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          controller: widget.controller,
          delay: const Duration(milliseconds: 120),
          child: _FilterBar(selected: _category, onChanged: _selectCategory),
        ),
        const SizedBox(height: 28),
        if (selected == null)
          Text(
            widget.projects.isEmpty
                ? '아직 등록된 프로젝트가 없습니다.'
                : '이 카테고리에 등록된 프로젝트가 없습니다.',
            style: Theme.of(context).textTheme.bodyLarge,
          )
        else
          ScrollReveal(
            controller: widget.controller,
            delay: const Duration(milliseconds: 200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 860;

                if (!wide) {
                  return Column(
                    children: projects
                        .map((project) => _MobileProjectTile(project: project))
                        .toList(),
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: projects.indexed
                            .map(
                              (entry) => _ProjectListRow(
                                number: (entry.$1 + 1).toString().padLeft(
                                  2,
                                  '0',
                                ),
                                project: entry.$2,
                                selected: entry.$2.id == selected.id,
                                onTap: () =>
                                    setState(() => _selectedId = entry.$2.id),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 36),
                    Expanded(
                      flex: 6,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: _ProjectDetailPanel(
                          key: ValueKey(selected.id),
                          project: selected,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final ProjectCategory selected;
  final ValueChanged<ProjectCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ProjectCategory.values
          .map(
            (category) => Semantics(
              button: true,
              selected: selected == category,
              child: InkWell(
                onTap: () => onChanged(category),
                borderRadius: BorderRadius.circular(999),
                child: TextPill(
                  label: category.label,
                  selected: selected == category,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ProjectListRow extends StatelessWidget {
  const _ProjectListRow({
    required this.project,
    required this.number,
    required this.selected,
    required this.onTap,
  });

  final ProjectItem project;
  final String number;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primary : AppTheme.text;

    return InkWell(
      onTap: onTap,
      onHover: (hovered) {
        if (hovered) onTap();
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: Text(
                  number,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: color),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${project.category.label} / ${project.year} / ${project.status}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailPanel extends StatelessWidget {
  const _ProjectDetailPanel({super.key, required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    return ThinPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImagePlaceholder(label: 'PROJECT\nIMAGE', height: 220),
          const SizedBox(height: 22),
          Text(
            project.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(project.subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          SelectableText(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          MetaBlock(label: 'ROLE', value: project.role),
          MetaBlock(label: 'TECH', value: project.techStack.join(' / ')),
          const SizedBox(height: 8),
          for (final item in project.highlights) BulletLine(text: item),
          const SizedBox(height: 14),
          _ProjectLinks(project: project),
        ],
      ),
    );
  }
}

class _MobileProjectTile extends StatelessWidget {
  const _MobileProjectTile({required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ThinPanel(
        padding: 0,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            title: Text(project.title),
            subtitle: Text('${project.category.label} / ${project.status}'),
            children: [
              const ImagePlaceholder(label: 'PROJECT\nIMAGE', height: 150),
              const SizedBox(height: 16),
              SelectableText(
                project.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              MetaBlock(label: 'TECH', value: project.techStack.join(' / ')),
              _ProjectLinks(project: project),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectLinks extends StatelessWidget {
  const _ProjectLinks({required this.project});

  final ProjectItem project;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 10,
      children: [
        if (portfolioLinkUri(project.githubUrl) != null)
          _LinkText(label: 'GitHub', value: project.githubUrl),
        if (portfolioLinkUri(project.demoUrl) != null)
          _LinkText(label: '데모', value: project.demoUrl),
        if (portfolioLinkUri(project.storeUrl) != null)
          _LinkText(label: '스토어', value: project.storeUrl),
      ],
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ExternalLinkText(label: label, value: value);
  }
}
