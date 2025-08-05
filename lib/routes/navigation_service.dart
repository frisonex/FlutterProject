import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  final BuildContext context;
  bool? isLogin;

  NavigationService(this.context);


  void navigateToLogin(BuildContext context) {
    context.go('/');
  }

  void navigateToMenu(BuildContext context) {
    context.go('/menu_screen');
  }

  void navigateToDespachoFechaScreen(BuildContext context) {
    context.go('/despacho_fecha_screen');
  }

  void navigateToProductoBodegaScreen(BuildContext context) {
    context.go('/producto_bodega_screen');
  }

}
