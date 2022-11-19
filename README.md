## Update:

Don't use this. The iOS jank issue relating to shader warmup is now largely mitigated by shader pre-compilation as described [here](https://github.com/flutter/flutter/issues/79298?fbclid=IwAR2Mmv5QnZUSRw7uDaa21unLCt-QXTv8pv3C0VBcw9iv_Mb2RX7pMhzGIQQ). Huge thanks to the Flutter team!

# warmup_routine

A library for handling animation warmup generically as discussed in: https://github.com/flutter/flutter/issues/76180

This solution is not very scalable for applications with many animations to warm up and is meant mostly as an example of an approach applications could take
to warmup their animations until a more permanent solution is available.

## Usage

### Warmup overlay

The most common way to warmup animations is to use a pseudo splash screen that executes the animations while the application is starting up.

```dart
import 'package:warmup_routine/warmup_overlay.dart';
import 'package:warmup_routine/warmup_animation.dart';

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
    }
  } else {
    // Start rest of application
    MyApp();
  }
}
```

### Warmup routine

If an overlay is not desired, a warmup routine can be executed anywhere in your existing directly:

```dart
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
```

### Navigator example

```dart
// The overlay will remain on top of the application above navigation events, so Navigator.push/pop
// can be warmed up as well:

class NavigationWarmupScreen extends StatefulWidget {
  final Function onComplete;

  NavigationWarmupScreen({@required this.onComplete});

  _NavigationWarmupScreenState createState() => _NavigationWarmupScreenState();
}

class _NavigationWarmupScreenState extends State<NavigationWarmupScreen> {
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
```

Full examples in [GitHub repo](https://github.com/danReynolds/warmup_routine/blob/master/example.dart)
