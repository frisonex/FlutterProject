import 'package:asegensa/views/screens/despacho_fecha_screen.dart';
import 'package:asegensa/views/screens/login_screen.dart';
import 'package:asegensa/views/screens/producto_bodega_screen.dart';
import 'package:asegensa/views/screens/menu_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen(),),
      GoRoute(path: '/menu_screen', builder: (context, state) => MenuScreen(),),
      GoRoute(path: '/despacho_fecha_screen', builder: (context, state) => const DespachoFechaScreen(),),
      GoRoute(path: '/producto_bodega_screen', builder: (context, state) => const ProductoBodegaScreen()),
      // GoRoute(path: '/event/list_event', builder: (context, state) => const EventListScreen()),
      // GoRoute(path: '/event/register_user', builder: (context, state) => const EventRegisterUser()),
      // GoRoute(path: '/client/client_list_event', builder: (context, state) => const ClientListEvent()),
      // GoRoute(path: '/client/client_dni', builder: (context, state) => const ClientDniScreen()),
      // GoRoute(path: '/data_client_invoice', builder: (context, state) => const DataClientInvoiceClientScreen()),
    ],
  );
}
