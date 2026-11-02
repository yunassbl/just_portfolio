import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  bool _visibilityCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scheduleVisibilityCheck);
    _scheduleVisibilityCheck();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      _timer?.cancel();
      _timer = null;
      _visible = true;
    }
    _scheduleVisibilityCheck();
  }

  @override
  void didUpdateWidget(covariant ScrollReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_scheduleVisibilityCheck);
      widget.controller.addListener(_scheduleVisibilityCheck);
    }
    _scheduleVisibilityCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_scheduleVisibilityCheck);
    super.dispose();
  }

  void _scheduleVisibilityCheck() {
    if (!mounted || _visible || _visibilityCheckScheduled) return;
    _visibilityCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityCheckScheduled = false;
      _updateVisibility();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _reveal() {
    _timer?.cancel();
    _timer = null;
    if (!mounted || _visible) return;
    setState(() => _visible = true);
  }

  void _updateVisibility() {
    if (!mounted || _visible) return;

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery?.disableAnimations ?? false) {
      _reveal();
      return;
    }

    // Once entry starts the delay, further layout/scroll events must not reset it.
    if (_timer != null) return;

    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportHeight = mediaQuery?.size.height ?? 0;
    final enteredViewport = top < viewportHeight * widget.triggerRatio;
    final notPassedViewport = bottom > viewportHeight * 0.08;

    if (!enteredViewport || !notPassedViewport) return;

    if (widget.delay == Duration.zero) {
      _reveal();
    } else {
      _timer = Timer(widget.delay, _reveal);
    }
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

    return _RevealLayoutObserver(
      key: _key,
      onGeometryChanged: _visible ? null : _scheduleVisibilityCheck,
      child: reduceMotion
          ? widget.child
          : AnimatedOpacity(
              opacity: _visible ? 1 : 0,
              duration: duration,
              curve: Curves.easeOutCubic,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: _visible ? 0 : offset,
                  end: _visible ? 0 : offset,
                ),
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

// Observe actual rendering work, including ancestor-only position changes.
// This never requests recurring frames, and stops observing after reveal.
class _RevealLayoutObserver extends SingleChildRenderObjectWidget {
  const _RevealLayoutObserver({
    super.key,
    required this.onGeometryChanged,
    required super.child,
  });

  final VoidCallback? onGeometryChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderRevealLayoutObserver(onGeometryChanged);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderRevealLayoutObserver renderObject,
  ) {
    renderObject.onGeometryChanged = onGeometryChanged;
  }
}

class _RenderRevealLayoutObserver extends RenderProxyBox {
  _RenderRevealLayoutObserver(this.onGeometryChanged);

  VoidCallback? onGeometryChanged;
  Rect? _lastPaintBounds;

  @override
  void performLayout() {
    super.performLayout();
    onGeometryChanged?.call();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (onGeometryChanged != null) {
      final bounds = localToGlobal(Offset.zero) & size;
      if (bounds != _lastPaintBounds) {
        _lastPaintBounds = bounds;
        onGeometryChanged!();
      }
    }
    super.paint(context, offset);
  }
}
