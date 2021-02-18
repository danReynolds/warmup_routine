import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import './lib/warmup_overlay.dart';
import './lib/warmup_animation.dart';
import './lib/warmup_routine.dart';

class OpenContainerAnimation extends StatefulWidget {
  final Function onComplete;

  OpenContainerAnimation({@required this.onComplete});

  _OpenContainerAnimationState createState() => _OpenContainerAnimationState();
}

class _OpenContainerAnimationState extends State<OpenContainerAnimation> {
  Function _openContainerAnimationStart;
  Function _openContainerAnimationEnd;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openContainerAnimationStart();
      Future.delayed(
        Duration(milliseconds: 400),
        () {
          _openContainerAnimationEnd();
          Future.delayed(
            Duration(milliseconds: 400),
            () {
              widget.onComplete();
            },
          );
        },
      );
    });
  }

  @override
  build(context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
      floatingActionButton: OpenContainer(
        closedShape: CircleBorder(),
        closedColor: Colors.yellow,
        transitionType: ContainerTransitionType.fade,
        openColor: Colors.white,
        openElevation: 0,
        closedBuilder: (_, openContainer) {
          _openContainerAnimationStart = openContainer;
          return FloatingActionButton(
            heroTag: 'add',
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              openContainer();
            },
          );
        },
        openBuilder: (_, closeContainer) {
          _openContainerAnimationEnd = closeContainer;
          return Scaffold(
            body: Container(
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}

class WarmupOverlayExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WarmupOverlay(
      onComplete: () {
        // Start rest of application
      },
      animations: [
        WarmupAnimation(
          builder: (context, complete) {
            // Replace with your animation of choice
            return OpenContainerAnimation(onComplete: complete);
          },
          repeat: 4,
        ),
      ],
    );
  }
}

class WarmupRoutineExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WarmupRoutine(
      animations: [
        WarmupAnimation(
          builder: (context, complete) {
            // Replace with your animation of choice
            return OpenContainerAnimation(onComplete: complete);
          },
          repeat: 4,
        ),
      ],
      onComplete: () {
        // Start rest of application
      },
    );
  }
}
