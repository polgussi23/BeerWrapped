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

    try{
      final response = await _loginService.loginUser(
        _usernameController.text,
        _passwordController.text,
      );
      print('Login exitós! Token: ${response.token}, User ID: ${response.userId}');
      // TODO: Navegar a la següent pantalla
      // Exemple de navegació (s'hauran de configurar les rutes a 'app.dart' o 'main.dart')
      // Navigator.of(context).pushReplacementNamed('/home');

    } catch (error){
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
    return Scaffold(
      //appBar: AppBar(title: Text('Login')),
      body: CustomBackground(
          child: CustomTitle(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTextField(
                    labelText: 'Nom d\'usuari',
                    controller: _usernameController,
                  ),
                  CustomTextField(
                    labelText: 'Contrasenya',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading ? CircularProgressIndicator(): Text('Login'),
                  ),
                  if(_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _errorMessage, style: TextStyle(color: Colors.red),
                      )
                    )
                ],
              )
            ),
          ),
        )
    );
  }
}