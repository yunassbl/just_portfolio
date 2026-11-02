import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioTechStackSection extends StatelessWidget {
  const PortfolioTechStackSection({
    super.key,
    required this.controller,
    required this.groups,
  });

  final ScrollController controller;
  final List<TechStackGroup> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          controller: controller,
          delay: const Duration(milliseconds: 120),
          child: Column(
            children: groups
                .map((group) => _StackGroupRow(group: group))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _StackGroupRow extends StatelessWidget {
  const _StackGroupRow({required this.group});

  final TechStackGroup group;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 700;
            final title = Text(
              group.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
              ),
            );
            final items = Text(
              group.items.join(' / '),
              style: Theme.of(context).textTheme.bodyLarge,
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, const SizedBox(height: 8), items],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 220, child: title),
                Expanded(child: items),
              ],
            );
          },
        ),
      ),
    );
  }
}
