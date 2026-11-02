import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioContactSection extends StatelessWidget {
  const PortfolioContactSection({
    super.key,
    required this.controller,
    required this.content,
  });

  final ScrollController controller;
  final PortfolioData content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          controller: controller,
          delay: const Duration(milliseconds: 120),
          child: Text(
            content.contactMessage,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 34, height: 1.35),
          ),
        ),
        const SizedBox(height: 42),
        ScrollReveal(
          controller: controller,
          delay: const Duration(milliseconds: 220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final contact in content.contacts.where(
                (item) => item.value.trim().isNotEmpty,
              ))
                _ContactRow(contact: contact),
              const SizedBox(height: 72),
              Text(
                content.creditLine1,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content.creditLine2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.contact});

  final ContactItem contact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 132,
              child: Text(
                contact.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ExternalLinkText(label: '', value: contact.value),
            ),
          ],
        ),
      ),
    );
  }
}
