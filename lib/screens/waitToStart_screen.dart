import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_button.dart';
import 'package:birrawrapped/components/custom_days_left_card.dart';
import 'package:birrawrapped/components/custom_logout_button.dart';
import 'package:birrawrapped/components/custom_title.dart';
import 'package:birrawrapped/components/wrapped_banner.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/wrapped_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaittostartScreen extends StatefulWidget {
  const WaittostartScreen({Key? key}) : super(key: key);

  @override
  _WaittostartScreenState createState() => _WaittostartScreenState();
}

class _WaittostartScreenState extends State<WaittostartScreen> {
  final _wrappedService = WrappedService();
  bool _showWrappedBanner = false;

  @override
  void initState() {
    super.initState();
    _checkWrapped();
  }

  Future<void> _checkWrapped() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = context.read<UserProvider>().getUserId();
      final showBanner =
          await _wrappedService.checkAndShowWrapped(context, userId);
      if (mounted) setState(() => _showWrappedBanner = showBanner);
    });
    print(_showWrappedBanner);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    //final screenWidth =
    MediaQuery.of(context).size.width; // Obtenemos el ancho de la pantalla

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const CustomTitle(),
                  SizedBox(
                      height:
                          screenHeight * 0.10), // Espacio después del título

                  // Usamos un Stack para superponer los elementos
                  if (_showWrappedBanner) WrappedBanner(),
                  Stack(
                    clipBehavior: Clip
                        .none, // Permite que los hijos se desborden de los límites del Stack
                    alignment: Alignment
                        .center, // Centra los hijos horizontalmente dentro del Stack
                    children: [
                      // El Container de la fecha (el "fondo")
                      CustomDaysLeftCard(),
                      // El DateSelectionInfoRow (el que sobresale)
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/chooseDay');
                      },
                      child: Text("CANVIAR DATA")),
                  SizedBox(height: screenHeight * 0.08),
                  LogoutButton(
                    onPressed: () {
                      print('Tanca la sessió');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
