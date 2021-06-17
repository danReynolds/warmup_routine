import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import './lib/warmup_overlay.dart';
import './lib/warmup_animation.dart';
import './lib/warmup_routine.dart';

class OpenContainerAnimation extends StatefulWidget {
  final Function onComplete;

  OpenContainerAnimation({required this.onComplete});

  _OpenContainerAnimationState createState() => _OpenContainerAnimationState();
}

class _OpenContainerAnimationState extends State<OpenContainerAnimation> {
  late Function _openContainerAnimationStart;
  late Function _openContainerAnimationEnd;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
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

// Example of showing an overlay under which the animations are executing.
class WarmupOverlayExample extends StatefulWidget {
  _WarmupOverlayExampleState createState() => _WarmupOverlayExampleState();
}

class _WarmupOverlayExampleState extends State<WarmupOverlayExample> {
  bool _shouldShowOverlay = true;

  @override
  Widget build(BuildContext context) {
    if (_shouldShowOverlay) {
      return WarmupOverlay(
        onComplete: () {
          setState(() {
            _shouldShowOverlay = false;
          });
        },
        builder: (context) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
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
    } else {
      // Start rest of application
      return MyApp();
    }
  }
}

// If an overlay is not desired, warmup animations can be executed directly
// with the WarmupRoutine widget
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

// The overlay will remain on top of the application above navigation events, so Navigator.push/pop
// can be warmed up as well:

class NavigationWarmupScreen extends StatefulWidget {
  final Function onComplete;

  NavigationWarmupScreen({required this.onComplete});

  _NavigationWarmupScreenState createState() => _NavigationWarmupScreenState();
}

class _NavigationWarmupScreenState extends State<NavigationWarmupScreen> {
  initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return YourWidget();
          },
          fullscreenDialog: true,
        ),
      );

      Future.delayed(
        // Adjust duration as needed
        Duration(milliseconds: 400),
        () {
          Navigator.pop(context);
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
    return Container();
  }
}

class WarmupOverlayNavigationExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WarmupOverlay(
      onComplete: () {
        // Start rest of application
      },
      builder: (context) {
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      animations: [
        WarmupAnimation(
          builder: (context, complete) {
            return NavigationWarmupScreen(onComplete: complete);
          },
          repeat: 2,
        ),
      ],
    );
  }
}

class YourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
