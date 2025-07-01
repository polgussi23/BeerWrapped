import 'package:beerwrapped/components/custom_button.dart';
import 'package:beerwrapped/components/custom_title.dart';
import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../services/login_service.dart';
import '../components/custom_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginService = LoginService();
  String _errorMessage = '';

  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _loginService.loginUser(
        _usernameController.text,
        _passwordController.text,
      );
      print(
          'Login exitós! Token: ${response.accessToken}, User ID: ${response.userId}, StartDay: ${response.startDay}, Message: ${response.message}');
      Navigator.of(context).pushReplacementNamed('/chooseDay');
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });

      print('Error en el login: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Changed to start
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: <Widget>[
                  const CustomTitle(), // Use CustomTitle here
                  SizedBox(
                      height: screenHeight *
                          0.10), // Space between title and container
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width as needed
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.025, horizontal: 40.0),
                    decoration: BoxDecoration(
                      color: const Color(0x7FFAF3E0),
                      borderRadius: BorderRadius.circular(
                          10.0), // Optional: rounded corners
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Fit content in Container
                      children: <Widget>[
                        CustomTextField(
                          hintText: 'Usuari',
                          controller: _usernameController,
                          icon: const Icon(Icons.person,
                              color: Color(0xFFFAF3E0)),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.04), // Space between text fields
                        CustomTextField(
                          hintText: 'Contrasenya',
                          controller: _passwordController,
                          icon: const Icon(Icons.password,
                              color: Color(0xFFFAF3E0)),
                          obscureText: true,
                        ),
                        //const SizedBox(height: 25), // Space before button
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04), // Space before button
                  CustomButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Inicia sessió'),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.15),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      // ROW PER AL TEXT INFERIOR
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrem horitzontalment
                      children: <Widget>[
                        Text(
                          'No tens compte?',
                          style: TextStyle(
                            color: Color(0xFFFAF3E0), // Color FAF3E0
                            fontFamily: 'Kameron',
                            fontSize: screenHeight * 0.023,
                          ),
                        ),
                        const SizedBox(width: 5), // Espai entre els dos textos
                        GestureDetector(
                          onTap: () {
                            // Navegar a la pàgina de registre ('register_screen')
                            Navigator.of(context).pushNamed(
                                '/register'); // Asumeix que la ruta és '/register'
                          },
                          child: Text(
                            'Registra\'t',
                            style: TextStyle(
                              color: Color(0xFFFAF3E0), // Color FAF3E0
                              fontWeight: FontWeight.bold, // Text en negreta
                              decoration:
                                  TextDecoration.underline, // Subratllat
                              decorationColor: Color(0xFFFAF3E0),
                              decorationThickness: 2.5,
                              fontFamily: 'Kameron',
                              fontSize: screenHeight * 0.025,
                            ),
                          ),
                        ),
                      ],
                    ),
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
