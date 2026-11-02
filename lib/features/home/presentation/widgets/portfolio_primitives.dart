import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';
import 'package:url_launcher/url_launcher.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.controller,
    required this.number,
    required this.title,
  });

  final ScrollController controller;
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      controller: controller,
      offset: 28,
      duration: const Duration(milliseconds: 720),
      child: Semantics(
        header: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

class ThinPanel extends StatelessWidget {
  const ThinPanel({super.key, required this.child, this.padding = 22});

  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}

class BulletLine extends StatelessWidget {
  const BulletLine({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 4,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class TextPill extends StatelessWidget {
  const TextPill({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppTheme.primary.withValues(alpha: 0.10) : null,
        border: Border.all(
          color: selected ? AppTheme.primary : AppTheme.border,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? AppTheme.primary : AppTheme.text,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    super.key,
    required this.label,
    this.width,
    this.height = 180,
  });

  final String label;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: '$label placeholder',
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.surfaceAlt,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class MetaBlock extends StatelessWidget {
  const MetaBlock({super.key, required this.label, required this.value});

  final String label;
  final String value;

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
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class ExternalLinkText extends StatelessWidget {
  const ExternalLinkText({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final uri = portfolioLinkUri(value);
    final enabled = uri != null;

    return TextButton(
      onPressed: uri == null ? null : () => _open(uri),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: enabled ? AppTheme.primary : AppTheme.muted,
      ),
      child: Text(
        label.isEmpty ? value : '$label: $value',
        textAlign: TextAlign.start,
      ),
    );
  }

  Future<void> _open(Uri uri) async {
    await launchUrl(Uri.base.resolveUri(uri), webOnlyWindowName: '_blank');
  }
}

Uri? portfolioLinkUri(String rawValue) {
  final value = rawValue.trim();
  if (value.isEmpty || value == '-') return null;

  final uri = Uri.tryParse(value);
  if (uri == null) return null;
  if (uri.scheme == 'mailto' || uri.scheme == 'tel') {
    return uri.path.isEmpty ? null : uri;
  }
  if (uri.scheme == 'http' || uri.scheme == 'https') {
    return uri.host.isEmpty ? null : uri;
  }
  if (uri.hasScheme) return null;

  if (RegExp(r'^\+?[\d\s().-]+$').hasMatch(value)) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.replaceAll('0', '').isEmpty) return null;
    return Uri(scheme: 'tel', path: value.replaceAll(RegExp(r'[\s().-]'), ''));
  }
  if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
    return Uri(scheme: 'mailto', path: value);
  }

  if (uri.path.endsWith('.pdf')) return uri;
  if (value.contains(' ') || !value.contains('.')) return null;
  final webUri = Uri.tryParse('https://$value');
  return webUri != null && webUri.host.isNotEmpty ? webUri : null;
}
