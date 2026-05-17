import 'package:birrawrapped/components/custom_button.dart';
import 'package:birrawrapped/components/custom_date_chooser.dart'; // <-- afegit
import 'package:birrawrapped/components/custom_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/register_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_text_field.dart';
import '../components/custom_background.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime _selectedDate = DateTime(2000, 01, 01);

  final _registerService = RegisterService();
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _checkControllers(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      final response = await _registerService.registerUser(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        DateFormat('yyyy-MM-dd').format(_selectedDate!),
      );
      print(
          'Registre exitós! Token: ${response.refreshToken}, User ID: ${response.userId}');

      context.read<UserProvider>().setSessionFromRegisterResponse(response);
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
    if (_selectedDate == null) {
      throw Exception('Has de seleccionar la data de naixement!');
    }
    _checkEmail(e);
  }

  void _checkEmail(String email) {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) throw Exception('Email amb format invàlid');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        const CustomBackground(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CustomTitle(),
                SizedBox(height: screenHeight * 0.11),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.025, horizontal: 40.0),
                  decoration: BoxDecoration(
                    color: const Color(0x7FFAF3E0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      SizedBox(height: screenHeight * 0.04),
                      CustomTextField(
                        hintText: 'Contrasenya',
                        controller: _passwordController,
                        icon: const Icon(Icons.password,
                            color: Color(0xFFFAF3E0)),
                        obscureText: true,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      CustomDateChooser(
                        // <-- substitueix el GestureDetector+AbsorbPointer+CustomTextField
                        initialDate: DateTime(2000),
                        hintText: 'Data de naixement',
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        onDateSelected: (date) {
                          setState(() => _selectedDate = date);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.075),
                CustomButton(
                  onPressed: _isLoading ? null : _handleRegister,
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
