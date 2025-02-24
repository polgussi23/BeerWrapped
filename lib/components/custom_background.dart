// lib/components/background_personalitzat.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomBackground extends StatelessWidget {
  final Widget? child;

  const CustomBackground({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryData.fromView(View.of(context)); // Manté la mida sense que el teclat afecti
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final spittingBeerImageHeight = screenHeight * 0.65;
    final spittingBeerImageWidth = spittingBeerImageHeight / 1.168; // 1.168 és la relació entre amplada i altura de la imatge original!
    
    return Container(
      width: screenWidth,          // Forcem l'amplada del Container a ser tota l'amplada de la pantalla
      height: screenHeight,         // Forcem l'altura del Container a ser tota l'altura de la pantalla
      color: Color(0xFF333333), // Color de fons gris fosc (podeu ajustar-lo)
      child: Stack(
        children: [
          // Imatge cervesa minimalista (superior esquerra)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Transform.rotate(
              angle: degreesToRadians(-16),
              child: Image.asset(
                'assets/images/minimalist_beer.png', // Ruta a la imatge cervesa minimalista
                height: MediaQuery.of(context).size.height * 0.22, // Ajusta l'amplada segons necessitis
                opacity: AlwaysStoppedAnimation(0.5), // Redueix l'opacitat una mica
              ),
            ),
          ),
          // Imatge cervesa minimalista (superior dreta)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Transform.rotate( // Rotem la imatge per a que sigui similar a l'exemple
              angle: degreesToRadians(14), // Un petit angle de rotació en radians (podeu ajustar-lo)
              child: Image.asset(
                'assets/images/minimalist_beer.png', // Ruta a la imatge cervesa minimalista
                height: MediaQuery.of(context).size.height * 0.22, // Ajusta l'amplada
                opacity: AlwaysStoppedAnimation(0.5), // Redueix l'opacitat una mica
              ),
            ),
          ),
          // Imatge cervesa "spitting_beer" (inferior centre)
          Positioned(
            
            top: screenHeight * 0.43, // Posició inferior una mica fora de la pantalla per a que sembli tallada
            //left: screenWidth * 0.2, // Posició esquerra per centrar-la horitzontalment aproximadament
            left: spittingBeerImageLefPosition(screenWidth, spittingBeerImageWidth),
            //right: -screenWidth*0.3, // Posició dreta per centrar-la horitzontalment aproximadament
            child: Transform.rotate(
              angle: degreesToRadians(-10),
              child: Image.asset(
                'assets/images/spitting_beer.png', // Ruta a la imatge cervesa gran
                height: spittingBeerImageHeight, // Amplada 120% de la pantalla per a que sobresurti
                opacity: const AlwaysStoppedAnimation(0.3), // Ajusta l'opacitat
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: const SizedBox(height: 0),
            //child: child, // Contingut de la pantalla
          ),
        ],
      ),
    );
  }

  double degreesToRadians(double x){
    return x * math.pi / 180;
  }

  double spittingBeerImageLefPosition(double screenWidth, double imageWidth){
    return screenWidth - (imageWidth/1.35);
  }
}