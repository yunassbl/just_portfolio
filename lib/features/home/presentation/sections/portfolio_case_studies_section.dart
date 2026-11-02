import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioCaseStudiesSection extends StatelessWidget {
  const PortfolioCaseStudiesSection({
    super.key,
    required this.controller,
    required this.caseStudies,
  });

  final ScrollController controller;
  final List<CaseStudy> caseStudies;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, study) in caseStudies.indexed)
          ScrollReveal(
            controller: controller,
            delay: Duration(milliseconds: 110 + (index * 80)),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: _CaseFile(study: study),
            ),
          ),
      ],
    );
  }
}

class _CaseFile extends StatelessWidget {
  const _CaseFile({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    return ThinPanel(
      padding: 26,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          final meta = _CaseMeta(study: study);
          final body = _CaseBody(study: study);

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [meta, const SizedBox(height: 28), body],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 260, child: meta),
              const SizedBox(width: 42),
              Expanded(child: body),
            ],
          );
        },
      ),
    );
  }
}

class _CaseMeta extends StatelessWidget {
  const _CaseMeta({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          study.number,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(study.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(study.summary, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 28),
        MetaBlock(label: 'STATUS', value: study.status),
        MetaBlock(label: 'PLATFORM', value: study.platform),
        MetaBlock(label: 'ROLE', value: study.role),
      ],
    );
  }
}

class _CaseBody extends StatelessWidget {
  const _CaseBody({required this.study});

  final CaseStudy study;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CaseDetail(label: '문제', text: study.problem),
        _CaseDetail(label: '원인 분석', text: study.analysis),
        _CaseDetail(label: '접근 방향', text: study.decision),
        _CaseDetail(label: '실행', text: study.implementation),
        _CaseDetail(label: '검증', text: study.validation),
        _CaseDetail(label: '결과', text: study.result),
      ],
    );
  }
}

class _CaseDetail extends StatelessWidget {
  const _CaseDetail({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
