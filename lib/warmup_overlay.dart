import 'package:flutter/material.dart';
import './warmup_animation.dart';
import './warmup_routine.dart';

class WarmupOverlay extends StatefulWidget {
  final Function onComplete;
  final Widget Function(BuildContext context)? placeholderBuilder;
  final Widget Function(BuildContext context)? builder;
  final List<WarmupAnimation> animations;

  WarmupOverlay({
    required this.onComplete,
    required this.animations,
    this.placeholderBuilder,
    this.builder,
  });

  _WarmupOverlayState createState() => _WarmupOverlayState();
}

class _WarmupOverlayState extends State<WarmupOverlay> {
  OverlayEntry? _entry;

  // The overlay cannot be fully opaque or the animation won't actually
  // cache the shaders.
  final double _overlayOpacity = 0.99;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _entry = OverlayEntry(
          opaque: false,
          builder: (BuildContext overlayContext) {
            return Opacity(
              opacity: _overlayOpacity,
              child: widget.builder!(overlayContext),
            );
          },
        );
      });
      Overlay.of(context)!.insert(_entry!);
    });
  }

  @override
  build(context) {
    if (_entry == null) {
      return widget.placeholderBuilder == null
          ? Container()
          : widget.placeholderBuilder!(context);
    }
    return WarmupRoutine(
      animations: widget.animations,
      onComplete: () {
        widget.onComplete();
        _entry!.remove();
      },
    );
  }
}
