library warmup_routine;

import 'package:flutter/material.dart';
import './warmup_animation.dart';

class WarmupRoutine extends StatefulWidget {
  final List<WarmupAnimation> animations;
  final void Function() onComplete;

  WarmupRoutine({required this.animations, required this.onComplete});

  _WarmupAnimationState createState() => _WarmupAnimationState();
}

class _WarmupAnimationState extends State<WarmupRoutine> {
  int _animationIndex = 0;

  _onWarmupAnimationComplete() {
    if (_animationIndex < widget.animations.length - 2) {
      setState(() {
        _animationIndex += 1;
      });
    } else {
      widget.onComplete();
    }
  }

  @override
  build(context) {
    return WarmupAnimationData(
      onComplete: _onWarmupAnimationComplete,
      child: widget.animations[_animationIndex],
    );
  }
}
