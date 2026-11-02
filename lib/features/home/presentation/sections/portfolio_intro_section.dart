import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioIntroSection extends StatelessWidget {
  const PortfolioIntroSection({
    super.key,
    required this.controller,
    required this.content,
    required this.onWorkPressed,
    required this.onContactPressed,
  });

  final ScrollController controller;
  final PortfolioData content;
  final VoidCallback? onWorkPressed;
  final VoidCallback? onContactPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 820;
          final textBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                controller: controller,
                offset: 28,
                child: Text(
                  content.name,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: wide ? 64 : 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ScrollReveal(
                controller: controller,
                delay: const Duration(milliseconds: 90),
                offset: 28,
                child: Text(
                  content.role,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 44),
              ScrollReveal(
                controller: controller,
                delay: const Duration(milliseconds: 180),
                offset: 32,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Text(
                    content.tagline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: wide ? 34 : 28,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              ScrollReveal(
                controller: controller,
                delay: const Duration(milliseconds: 300),
                offset: 32,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 690),
                  child: Text(
                    content.heroDescription,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              ScrollReveal(
                controller: controller,
                delay: const Duration(milliseconds: 420),
                offset: 24,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (onWorkPressed != null)
                      FilledButton(
                        onPressed: onWorkPressed,
                        child: const Text('프로젝트 보기'),
                      ),
                    if (onContactPressed != null)
                      OutlinedButton(
                        onPressed: onContactPressed,
                        child: const Text('연락하기'),
                      ),
                  ],
                ),
              ),
            ],
          );

          final metaBlock = ScrollReveal(
            controller: controller,
            delay: const Duration(milliseconds: 520),
            offset: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.introMeta
                  .map(
                    (item) => MetaBlock(label: item.label, value: item.value),
                  )
                  .toList(),
            ),
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [textBlock, const SizedBox(height: 44), metaBlock],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 7, child: textBlock),
              const SizedBox(width: 64),
              Expanded(flex: 3, child: metaBlock),
            ],
          );
        },
      ),
    );
  }
}
