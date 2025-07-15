import 'package:flutter/material.dart';

class GlobalContext {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static get getContext => navigatorKey.currentContext;
}