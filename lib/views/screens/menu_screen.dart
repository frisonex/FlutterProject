import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asegensa/routes/navigation_service.dart';
import 'package:asegensa/themes/app_theme.dart';
import 'package:asegensa/widgets/custom_event_card.dart';
import 'package:asegensa/widgets/custom_top_buttom.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // final SecureStorageHelper _secureStorageHelper = SecureStorageHelper();
  late NavigationService navigationService;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 25), vsync: this)
      ..repeat(reverse: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService = NavigationService(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void clearInputs() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final cards = [
              CustomEventCard(
                title: "Despachos por fecha",
                buttonText: "Consultar",
                widthFactor: isPortrait ? 0.75 : 0.22,
                heightFactor: isPortrait ? 0.33 : 0.40,
                icon: FaIcon(FontAwesomeIcons.calendarCheck,
                    color: Colors.white, size: size.width * 0.05),
                onPressed: () => navigationService.navigateToDespachoFechaScreen(context),
              ),
              CustomEventCard(
                title: "Producto por bodega",
                buttonText: "Consultar",
                widthFactor: isPortrait ? 0.75 : 0.22,
                heightFactor: isPortrait ? 0.33 : 0.40,
                icon: FaIcon(FontAwesomeIcons.boxOpen,
                    color: Colors.white, size: size.width * 0.05),
                onPressed: () => navigationService.navigateToProductoBodegaScreen(context),
              ),
            ];

            return Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: AppTheme().animatedRadialGradient(_controller),
                  ),
                  child: isPortrait
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cards[0],
                      SizedBox(height: size.height * 0.04),
                      cards[1],
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: cards,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Menú principal',
                        style: TextStyle(color: Colors.white, fontSize: size.width * 0.0225, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                ),
                CustomTopButton(
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  iconColor: Colors.white,
                  positionRight: true,
                  onPressed: () async {
                    navigationService.navigateToLogin(context);
                    await FirebaseAuth.instance.signOut();
                    clearInputs();
                    // _secureStorageHelper.storeValue('access_token', '0');
                    // _secureStorageHelper.storeValue('role', '0');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
