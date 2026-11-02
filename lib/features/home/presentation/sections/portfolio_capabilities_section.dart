import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_data.dart';
import 'package:just_portfolio/features/home/presentation/widgets/portfolio_primitives.dart';
import 'package:just_portfolio/features/home/presentation/widgets/scroll_reveal.dart';

class PortfolioCapabilitiesSection extends StatefulWidget {
  const PortfolioCapabilitiesSection({
    super.key,
    required this.controller,
    required this.capabilities,
  });

  final ScrollController controller;
  final List<Capability> capabilities;

  @override
  State<PortfolioCapabilitiesSection> createState() =>
      _PortfolioCapabilitiesSectionState();
}

class _PortfolioCapabilitiesSectionState
    extends State<PortfolioCapabilitiesSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.capabilities.isEmpty) {
      return Text(
        '아직 등록된 역량이 없습니다.',
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    final selectedIndex = _selectedIndex.clamp(
      0,
      widget.capabilities.length - 1,
    );
    final selected = widget.capabilities[selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollReveal(
          controller: widget.controller,
          delay: const Duration(milliseconds: 120),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 780;
              final nav = _CapabilityNav(
                capabilities: widget.capabilities,
                selectedIndex: selectedIndex,
                onChanged: (index) => setState(() => _selectedIndex = index),
              );
              final detail = AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                child: _CapabilityDetail(
                  key: ValueKey(selectedIndex),
                  capability: selected,
                ),
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [nav, const SizedBox(height: 22), detail],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 230, child: nav),
                  const SizedBox(width: 36),
                  Expanded(child: detail),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CapabilityNav extends StatelessWidget {
  const _CapabilityNav({
    required this.capabilities,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<Capability> capabilities;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 8,
      children: [
        for (final (index, capability) in capabilities.indexed)
          Semantics(
            button: true,
            selected: selectedIndex == index,
            child: InkWell(
              onTap: () => onChanged(index),
              onHover: (hovered) {
                if (hovered) onChanged(index);
              },
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                child: Text(
                  capability.navLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selectedIndex == index
                        ? AppTheme.primary
                        : AppTheme.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CapabilityDetail extends StatelessWidget {
  const _CapabilityDetail({super.key, required this.capability});

  final Capability capability;

  @override
  Widget build(BuildContext context) {
    return ThinPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capability.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            capability.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: capability.tools
                .map((tool) => TextPill(label: tool))
                .toList(),
          ),
          const SizedBox(height: 24),
          for (final item in capability.experiences) BulletLine(text: item),
        ],
      ),
    );
  }
}
