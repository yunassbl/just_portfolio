import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';

class CreditIndex extends StatelessWidget {
  const CreditIndex({
    super.key,
    required this.sections,
    required this.activeIndex,
    required this.progress,
    required this.onSectionTap,
    required this.name,
  });

  final List<SectionIndexItem> sections;
  final int activeIndex;
  final double progress;
  final ValueChanged<PortfolioSection> onSectionTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 56),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final (index, item) in sections.indexed)
                      _IndexButton(
                        item: item,
                        number: (index + 1).toString().padLeft(2, '0'),
                        active: index == activeIndex,
                        onTap: () => onSectionTap(item.id),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _VerticalProgress(progress: progress),
          ],
        ),
      ),
    );
  }
}

class MobileSectionHeader extends StatelessWidget {
  const MobileSectionHeader({
    super.key,
    required this.sections,
    required this.activeIndex,
    required this.progress,
  });

  final List<SectionIndexItem> sections;
  final int activeIndex;
  final double progress;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();
    final index = activeIndex.clamp(0, sections.length - 1);
    final item = sections[index];
    final number = (index + 1).toString().padLeft(2, '0');
    final total = sections.length.toString().padLeft(2, '0');

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.background.withValues(alpha: 0.92),
        border: const Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '$number / $total',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                minHeight: 1,
                backgroundColor: AppTheme.border,
                valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndexButton extends StatelessWidget {
  const _IndexButton({
    required this.item,
    required this.number,
    required this.active,
    required this.onTap,
  });

  final SectionIndexItem item;
  final String number;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.primary : AppTheme.muted;

    return Semantics(
      button: true,
      selected: active,
      label: '$number ${item.label}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 26,
                child: Text(
                  number,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerticalProgress extends StatelessWidget {
  const _VerticalProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1,
      height: 160,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppTheme.border),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: progress.clamp(0.0, 1.0),
            child: const DecoratedBox(
              decoration: BoxDecoration(color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
