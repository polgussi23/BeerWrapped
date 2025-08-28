import 'package:beerwrapped/components/custom_button.dart';
import 'package:beerwrapped/components/custom_title.dart';
import 'package:beerwrapped/services/register_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_text_field.dart';
import '../components/custom_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerService = RegisterService();
  String _errorMessage = '';

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _checkControllers(_usernameController.text, _emailController.text,
          _passwordController.text);

      final response = await _registerService.registerUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
      print(
          'Registre exitós! Token: ${response.refreshToken}, User ID: ${response.userId}');
      // Guardem l'accesToken i el refreshToken
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken',
          response.accessToken); // AccessToken a SharedPreferences
      final storage = FlutterSecureStorage();
      await storage.write(
          key: 'refreshToken',
          value: response.refreshToken); // RefreshToken a FlutterSecureStorage
      // Anem a la pantalla de selecció de dia
      Navigator.of(context).pushReplacementNamed('/chooseDay');
    } catch (error) {
      setState(() {
        _errorMessage = error.toString().replaceAll('Exception: ', '');
      });

      print('Error en el registre: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkControllers(String u, String e, String p) {
    if (u == '' || e == '' || p == '') {
      throw Exception('Has d\'emplenar tots els camps!');
    }
    _checkEmail(e);
  }

  void _checkEmail(String email) {
    // email: xx@xx.xx
    //var l = email.split('@');
    //var domain = l[1].split('.');
    //if(l.length != 2 || domain.length < 2) throw Exception('Email amb format invàlid');
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) throw Exception('Email amb format invàlid');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      //resizeToAvoidBottomInset: false,

      //appBar: AppBar(title: Text('Login')),
      body: Stack(children: [
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
                        0.11), // Space between title and container
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
                    mainAxisSize: MainAxisSize.min, // Fit content in Container
                    children: <Widget>[
                      CustomTextField(
                        hintText: 'Nom d\'usuari',
                        controller: _usernameController,
                        icon:
                            const Icon(Icons.person, color: Color(0xFFFAF3E0)),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      CustomTextField(
                        hintText: 'Correu',
                        controller: _emailController,
                        icon: const Icon(Icons.email, color: Color(0xFFFAF3E0)),
                      ),
                      SizedBox(
                          height:
                              screenHeight * 0.04), // Space between text fields
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
                SizedBox(height: screenHeight * 0.075), // Space before button
                CustomButton(
                  onPressed:
                      _isLoading ? null : _handleRegister, //_handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Registra\'t'),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
