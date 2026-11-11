import 'package:flutter/material.dart';

/// App-wide navigator for routes that must be pushed above the root app.
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(Widget page) {
    return navigatorKey.currentState?.push<dynamic>(
      MaterialPageRoute<dynamic>(builder: (_) => page),
    );
  }

  Future<dynamic>? navigateToNamed(String routeName, {Object? arguments}) {
    return navigatorKey.currentState?.pushNamed<dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  void goBack() {
    final navigator = navigatorKey.currentState;
    if (navigator?.canPop() ?? false) {
      navigator!.pop();
    }
  }

  void clearAndNavigateTo(Widget page) {
    navigatorKey.currentState?.pushAndRemoveUntil<dynamic>(
      MaterialPageRoute<dynamic>(builder: (_) => page),
      (route) => false,
    );
  }
}
