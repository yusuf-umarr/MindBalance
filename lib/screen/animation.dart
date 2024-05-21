
import 'package:flutter/material.dart';

class AnimatedWidgetContainer extends StatelessWidget {
  final Widget data;

  const AnimatedWidgetContainer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double val, Widget? child) {
        return 
        // Opacity(
        //   opacity: val,
          // child:
           Padding(
            padding: EdgeInsets.only(top: val * 20),
            child: child,
          );
        // );
      },
      child: data,
    );
  }
}
