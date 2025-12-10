import 'package:beerwrapped/components/custom_button.dart';
import 'package:beerwrapped/components/custom_title.dart';
import 'package:beerwrapped/providers/user_provider.dart';
import 'package:beerwrapped/services/startDay_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_background.dart';
import '../components/custom_date_chooser.dart';
import '../components/date_selection_info_row.dart';
import '../components/custom_logout_button.dart';
import 'package:intl/intl.dart';

class ChooseDayScreen extends StatefulWidget {
  const ChooseDayScreen({Key? key}) : super(key: key);

  @override
  _ChooseDayScreenState createState() => _ChooseDayScreenState();
}

class _ChooseDayScreenState extends State<ChooseDayScreen> {
  final _startDayService = StartDateService();
  DateTime _selectedDate = DateTime.now();

  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _handleChooseDay() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    //1. Quin usuari soc?
    int userId = context.read<UserProvider>().getUserId() ?? 0;
    //2. Quina data vull enviar?
    // _selectedDate

    //3. Envio el meu usuari i la data a la API
    try {
      await _startDayService.setStartDate(
          userId, DateFormat('yyyy-MM-dd').format(_selectedDate));
      print("Data afegida correctament!");
      context.read<UserProvider>().setStartDay(_selectedDate);
      Navigator.of(context).pushReplacementNamed('/waittostart');
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });

      print('Error en afegir startDay: $_errorMessage');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth =
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
                      Container(
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
                        child: CustomDateChooser(
                          initialDate: _selectedDate,
                          onDateSelected: (newDate) {
                            setState(() {
                              _selectedDate = newDate;
                            });
                          },
                          hintText: 'Tria una data',
                        ),
                      ),
                      // El DateSelectionInfoRow (el que sobresale)
                      const Positioned(
                        top:
                            15, // Lo posicionamos en la parte superior del Stack
                        child: DateSelectionInfoRow(),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  CustomButton(
                    onPressed: _isLoading ? null : _handleChooseDay,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('TRIA'),
                  ),
                  SizedBox(height: screenHeight * 0.15),
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
