import 'package:flutter/material.dart';

class AnimatedNavigation {
  Route scaleAnimation(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500), // Slow transition
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        var tween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation, // Smooth scaling
          child: child,
        );
      },
    );
  }

   Route fadeAnimation(Widget screen) {
    return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                 screen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              );
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration:
                const Duration(milliseconds: 600), // Smoother transition
          );
  }

  Route slideAnimation(Widget screen) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 500), // Animation duration
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut; // Smooth curve for animation

      var tween = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // Start from the right
        end: Offset.zero, // End at the current position
      ).chain(CurveTween(curve: curve));

      var slideAnimation = animation.drive(tween);

      return SlideTransition(
        position: slideAnimation, // Sliding transition
        child: child,
      );
    },
  );
}

}
