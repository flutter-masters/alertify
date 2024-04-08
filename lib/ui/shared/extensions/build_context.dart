import 'package:flutter/material.dart';

extension NavigatorX on BuildContext {
  NavigatorState get _navigator => Navigator.of(this);

  Future<T?> pushNamed<T extends Object?>(String routeName) {
    return _navigator.pushNamed(routeName);
  }

  Future<T?> pushReplacementNamed<T extends Object?>(String routeName) {
    return _navigator.pushReplacementNamed(routeName);
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(String routeName) {
    return _navigator.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  void pop<T extends Object?>([T? result]) {
    return _navigator.pop(result);
  }
}

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
}

extension MediaQueryX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
}
