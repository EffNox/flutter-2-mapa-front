part of 'helpers.dart';

Route navigateToPgFadeIn(BuildContext context, Widget pg) {
  return PageRouteBuilder(
      pageBuilder: (_, __, ___) => pg,
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          child: child,
            opacity: Tween<double>(begin: 0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)));
      });
}
