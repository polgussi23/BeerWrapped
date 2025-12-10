import 'package:beerwrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomDaysLeftCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomDaysLeftCardState();
}

class _CustomDaysLeftCardState extends State<CustomDaysLeftCard> {
  String _startingDay = "";
  int _daysLeft = 0;

  //@override
  //void initState() {}

  void _getStartingDay() {
    DateTime? date = context.read<UserProvider>().getStartDay();
    DateTime today = DateTime.now();
    if (date != null) {
      _startingDay = DateFormat('dd/MM/yyyy').format(date);
      _daysLeft = date.difference(today).inDays;
    } else
      _startingDay = "No hi ha data de començament!";
  }

  @override
  Widget build(BuildContext context) {
    _getStartingDay();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth =
        MediaQuery.of(context).size.width; // Obtenemos el ancho de la pantalla

    return Container(
        width: screenWidth * 0.9,
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.025, horizontal: 40.0),
        margin: EdgeInsets.only(
            top: screenHeight *
                0.05), // Añadimos un margen superior para que el DateSelectionInfoRow pueda sobresalir
        decoration: BoxDecoration(
          color: const Color(0x7FFAF3E0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dia d'inici: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Kameron",
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "${_startingDay}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: "Kameron",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Falten",
                  style: TextStyle(
                    fontSize: 30,
                    height: 0,
                    fontFamily: "Kameron",
                  ),
                ),
                Text(
                  "$_daysLeft",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    height: 0,
                    fontFamily: "Kameron",
                  ),
                ),
                Text(
                  "dies",
                  style: TextStyle(
                    fontSize: 30,
                    height: 0,
                    fontFamily: "Kameron",
                  ),
                )
              ],
            )
          ],
        ));
  }
}
