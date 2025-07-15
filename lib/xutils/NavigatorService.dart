import 'package:flutter/material.dart';
import '../route-generator.dart';
import 'GlobalContext.dart';

class NavigatorService{
  static void goto(String routeName, {Object? arguments}) {
    BuildContext context = GlobalContext.getContext;
    Navigator.push(context, RouteGenerator.generateRoute(RouteSettings(name: routeName, arguments: arguments)));
  }

  void gotoAndRmStack(String routeName, {Object? arguments}) {
    BuildContext context = GlobalContext.getContext;
    Navigator.pushAndRemoveUntil(context, RouteGenerator.generateRoute(RouteSettings(name: routeName, arguments: arguments)), (route)=>false);
  }

  static void pop(){
    Navigator.pop(GlobalContext.getContext);
  }
}