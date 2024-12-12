import 'dart:developer';
import 'package:flutter/material.dart';

class AppNavigationObserver extends RouteObserver<ModalRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('onPush -- Route: ${route.settings.name} -- Previous Route: ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('didReplace -- Route: ${newRoute?.settings.name} -- Previous Route: ${oldRoute?.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log('didPop -- Route: ${route.settings.name} -- Previous Route: ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log('didRemove -- Route: ${route.settings.name} -- Previous Route: ${previousRoute?.settings.name}');
  }
}