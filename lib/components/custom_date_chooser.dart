import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateChooser extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final DateTime initialDate;
  final String hintText;

  const CustomDateChooser({
    Key? key,
    required this.onDateSelected,
    required this.initialDate,
    this.hintText = 'Tria una data',
  }) : super(key: key);

  @override
  _CustomDateChooserState createState() => _CustomDateChooserState();
}

class _CustomDateChooserState extends State<CustomDateChooser> {
  late TextEditingController _dateController;
  late DateTime _currentSelectedDate;

  @override
  void initState() {
    super.initState();
    _currentSelectedDate = widget.initialDate;
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy', 'ca').format(_currentSelectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentSelectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B4513),
              onPrimary: Colors.white,
              surface: Color(0xFFFAF3E0),
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: const Color(0xFFFAF3E0),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentSelectedDate) {
      setState(() {
        _currentSelectedDate = picked;
        _dateController.text =
            DateFormat('dd/MM/yyyy', 'ca').format(_currentSelectedDate);
        widget.onDateSelected(_currentSelectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Obtener el tamaño intrínseco del icono para replicarlo en el suffixIcon
    // IconTheme.of(context).size es el tamaño por defecto de los iconos.
    // Si tu icono tiene un tamaño diferente, ajusta aquí.
    final double iconSize =
        IconTheme.of(context).size ?? 24.0; // Valor por defecto si es null

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: SizedBox(
          height: screenHeight * 0.025 * 2,
          child: TextField(
            controller: _dateController,
            readOnly: true, // No permite escribir manualmente
            onTap: () => _selectDate(context), // Abre el selector al tocar
            style: TextStyle(
                color: const Color(0xC2FAF3E0),
                fontFamily: 'Kameron',
                fontSize: screenHeight * 0.025),
            cursorColor: const Color(0XFFFAF3E0),
            textAlign: TextAlign
                .center, // <--- Esta es la línea clave para centrar el texto
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                  color: Color(0x7AFAF3E0), fontFamily: 'Kameron'),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: -2), // Ajusta el padding si es necesario
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xE62C2C2C)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Color(0xE62C2C2C)),
              ),
              filled: true,
              fillColor: const Color(0xE62C2C2C),
              prefixIcon: const Icon(Icons.calendar_month,
                  color: Color(0xFFFAF3E0)), // El icono a la izquierda
              // Añadir un suffixIcon "fantasma" para equilibrar el espacio
              suffixIcon: SizedBox(
                  width:
                      iconSize), // Ajusta el ancho para que coincida con el prefixIcon.
            ),
          ),
        ),
      ),
    );
  }
}
