import 'package:flutter/material.dart';

// Class used to wrap any arbitrary widget containing the animation to warm up.
// Supports navigator page animations, and repeating the animation any number of times.

class WarmupAnimationData extends InheritedWidget {
  const WarmupAnimationData({
    @required this.onComplete,
    @required Widget child,
  })  : assert(child != null),
        super();

  final Function onComplete;

  static WarmupAnimationData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WarmupAnimationData>();
  }

  @override
  bool updateShouldNotify(WarmupAnimationData old) =>
      onComplete != old.onComplete || child != old.child;
}

class WarmupAnimation extends StatefulWidget {
  final Widget Function(BuildContext context, Function() complete) builder;
  final int repeat;

  WarmupAnimation({@required this.builder, this.repeat = 1});

  _WarmupAnimationState createState() => _WarmupAnimationState();
}

class _WarmupAnimationState extends State<WarmupAnimation> {
  int _repeat;

  @override
  initState() {
    super.initState();
    _repeat = widget.repeat;
  }

  _onComplete(onComplete) {
    if (_repeat == 0) {
      onComplete();
    } else {
      setState(() {
        _repeat -= 1;
      });
    }
  }

  @override
  build(context) {
    return Builder(
      key: Key("warmup-animation-$_repeat"),
      builder: (innerContext) {
        final warmupAnimationData = WarmupAnimationData.of(innerContext);
        return widget.builder(
          innerContext,
          () => _onComplete(warmupAnimationData.onComplete),
        );
      },
    );
  }
}
