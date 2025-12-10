import 'package:flutter/material.dart';

class DateSelectionInfoRow extends StatelessWidget {
  const DateSelectionInfoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(
          bottom: 10.0), // Espacio antes del contenedor de fecha
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centrar el texto y los iconos
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: const Color(0xFFE5BD65), // Color del fondo del texto
              borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Quan vols començar?',
                  style: TextStyle(
                    color: Colors.black, // Color del texto
                    fontFamily: 'Roboto', // Fuente del texto
                    fontSize: screenHeight * 0.023,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                    width: screenHeight *
                        0.01), // Espacio entre el texto y el icono 'i'
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Informació'),
                        backgroundColor:
                            const Color.fromARGB(234, 229, 188, 101),
                        titleTextStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Kameron',
                          fontSize: screenHeight * 0.025,
                        ),
                        content: const Text(
                            'Encara no podràs començar a afegir cerveses fins que arribi la data que hagis escollit.\n\n'
                            'Un cop hagi passat un any des d\'aquesta data, podràs veure el teu Birra Wrapped.'),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Colors.black, // Color del texto del botón
                              backgroundColor: const Color.fromARGB(
                                  88, 44, 44, 44), // Color de fondo del botón
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('D\'acord'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: screenHeight * 0.015, // Tamaño del círculo i
                    backgroundColor:
                        const Color(0xFFE5BD65), // Color de fondo del círculo i
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.black, // Color del icono i
                      size: screenHeight * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
