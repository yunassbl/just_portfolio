import 'dart:async';

import 'package:flutter/material.dart';

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({
    super.key,
    required this.controller,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 720),
    this.offset = 32,
    this.triggerRatio = 0.86,
  });

  final ScrollController controller;
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  final double triggerRatio;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  final _key = GlobalKey();
  Timer? _timer;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void didUpdateWidget(covariant ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;
    oldWidget.controller.removeListener(_updateVisibility);
    widget.controller.addListener(_updateVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateVisibility());
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_updateVisibility);
    super.dispose();
  }

  void _updateVisibility() {
    if (!mounted || _visible) return;

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery?.disableAnimations ?? false) {
      setState(() => _visible = true);
      return;
    }

    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportHeight = mediaQuery?.size.height ?? 0;
    final enteredViewport = top < viewportHeight * widget.triggerRatio;
    final notPassedViewport = bottom > viewportHeight * 0.08;

    if (!enteredViewport || !notPassedViewport) return;

    _timer?.cancel();
    _timer = Timer(widget.delay, () {
      if (!mounted) return;
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    final reduceMotion = mediaQuery?.disableAnimations ?? false;
    final compact = (mediaQuery?.size.width ?? 0) < 640;
    final offset = compact ? widget.offset * 0.55 : widget.offset;
    final duration = compact
        ? Duration(
            milliseconds: (widget.duration.inMilliseconds * 0.72).round(),
          )
        : widget.duration;

    if (reduceMotion) {
      return KeyedSubtree(key: _key, child: widget.child);
    }

    return KeyedSubtree(
      key: _key,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: duration,
        curve: Curves.easeOutCubic,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: offset, end: _visible ? 0 : offset),
          duration: duration,
          curve: Curves.easeOutCubic,
          builder: (context, translateY, child) {
            return Transform.translate(
              offset: Offset(0, translateY),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
