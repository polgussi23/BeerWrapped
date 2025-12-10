import 'package:beerwrapped/components/custom_background.dart';
import 'package:beerwrapped/components/custom_button.dart';
import 'package:beerwrapped/components/custom_days_left_card.dart';
import 'package:beerwrapped/components/custom_logout_button.dart';
import 'package:beerwrapped/components/custom_title.dart';
import 'package:flutter/material.dart';

class WaittostartScreen extends StatefulWidget {
  const WaittostartScreen({Key? key}) : super(key: key);

  @override
  _WaittostartScreenState createState() => _WaittostartScreenState();
}

class _WaittostartScreenState extends State<WaittostartScreen> {
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
