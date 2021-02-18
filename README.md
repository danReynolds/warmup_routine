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

class WarmupOverlayExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WarmupOverlay(
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

Full example in [GitHub repo](https://github.com/danReynolds/warmup_routine/blob/master/example.dart)