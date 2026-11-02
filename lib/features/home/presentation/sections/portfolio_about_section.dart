import 'package:flutter/material.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioAboutSection extends StatelessWidget {
  const PortfolioAboutSection({
    super.key,
    required this.controller,
    required this.paragraphs,
  });

  final ScrollController controller;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          controller: controller,
          delay: const Duration(milliseconds: 120),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final profile = const ImagePlaceholder(
                label: 'PROFILE\nIMAGE',
                width: 180,
                height: 220,
              );
              final body = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final paragraph in paragraphs) ...[
                    SelectableText(
                      paragraph,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [profile, const SizedBox(height: 28), body],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profile,
                  const SizedBox(width: 56),
                  Expanded(child: body),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
