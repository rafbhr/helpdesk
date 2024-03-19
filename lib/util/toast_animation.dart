import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AnimationType { opacity, translateX }

class SlideInToastMessageAnimation extends StatelessWidget {
  final Widget child;
  final int duration;

  SlideInToastMessageAnimation(this.child, this.duration);

  @override
  Widget build(BuildContext context) {
    final movieTween = MovieTween()
      ..tween(
        'opacity',
        Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 500),
      )
      ..tween(
        'translateX',
        Tween(begin: 0.0, end: 0.0),
        duration: Duration(milliseconds: 250),
      );

    return PlayAnimationBuilder<Movie>(
      tween: movieTween,
      duration: movieTween.duration,
      onStarted: () => debugPrint('onStart'),
      onCompleted: () => debugPrint('onComplete'),
      builder: (context, movie, child) => Opacity(
        opacity: movie.get<double>('opacity'),
        child: Transform.translate(
            offset: Offset(movie.get<double>('translateX'), 0),
            child: child),
      ),
    );
  }
}
