import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_background.dart';
import '../components/custom_title.dart';
import '../components/custom_button.dart';
import '../components/custom_logout_button.dart';
import '../providers/user_provider.dart';
import '../services/email_verification_service.dart'; // el teu servei

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isVerifying = false;
  bool _isSending = false;
  String _errorMessage = '';

  // Compte enrere per tornar a enviar
  int _secondsLeft = 60;
  Timer? _timer;
  bool get _canResend => _secondsLeft == 0;

  @override
  void initState() {
    super.initState();
    _sendCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _sendCode() async {
    setState(() {
      _isSending = true;
      _errorMessage = '';
    });
    try {
      final email = context.read<UserProvider>().getEmail();
      await EmailVerificationService().sendVerificationCode(email!);
      _startTimer();
    } catch (e) {
      setState(
          () => _errorMessage = 'Error enviant el codi. Torna-ho a provar.');
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length < 6) {
      setState(() => _errorMessage = 'Introdueix els 6 dígits.');
      return;
    }
    setState(() {
      _isVerifying = true;
      _errorMessage = '';
    });
    try {
      final email = context.read<UserProvider>().getEmail();
      await EmailVerificationService().verifyCode(email!, code);
      await context.read<UserProvider>().setEmailVerified();
      Navigator.of(context).pushReplacementNamed('/chooseDay');
    } catch (e) {
      setState(() => _errorMessage = 'Codi incorrecte o caducat.');
      // Neteja els camps si el codi és erroni
      for (final c in _controllers) c.clear();
      _focusNodes.first.requestFocus();
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  // Quan l'usuari escriu un dígit, salta al següent camp automàticament
  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<UserProvider>().getEmail() ?? '';
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomTitle(),
                    SizedBox(height: screenHeight * 0.06),

                    // Icona i textos
                    const Icon(Icons.mark_email_unread_outlined,
                        size: 52, color: Color(0xFFFAF3E0)),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      'Verifica el teu correu',
                      style: TextStyle(
                        color: Color(0xFFFAF3E0),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Hem enviat un codi de 6 dígits a\n$email',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0x99FAF3E0),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context)
                            .pushNamed('/editEmail', arguments: email);
                        // Quan torna, reenvia el codi amb el nou correu
                        await _sendCode();
                      },
                      child: const Text(
                        'Clica aquí per a canviar el correu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0x99FAF3E0),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0x99FAF3E0)),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Camps del codi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) => _buildCodeBox(i)),
                    ),

                    // Error
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: screenHeight * 0.04),

                    // Botó verificar
                    CustomButton(
                      onPressed: _isVerifying ? null : _verifyCode,
                      child: _isVerifying
                          ? const CircularProgressIndicator()
                          : const Text('VERIFICA'),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Tornar a enviar
                    const Text(
                      'No has rebut el codi?',
                      style: TextStyle(color: Color(0x66FAF3E0), fontSize: 13),
                    ),
                    SizedBox(height: 6),
                    _canResend
                        ? GestureDetector(
                            onTap: _isSending ? null : _sendCode,
                            child: const Text(
                              'Torna a enviar el codi',
                              style: TextStyle(
                                color: Color(0xFFFAF3E0),
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        : Text(
                            'Torna a enviar en $_timerText',
                            style: const TextStyle(
                              color: Color(0x88FAF3E0),
                              fontSize: 13,
                            ),
                          ),

                    SizedBox(height: screenHeight * 0.08),

                    LogoutButton(onPressed: () {
                      // context.read<UserProvider>().logout();
                      // Navigator.of(context).pushReplacementNamed('/login');
                      print("aaaaaaaaaaaaaaaah");
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    return Container(
      width: 44,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0x1FFAF3E0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focusNodes[index].hasFocus
              ? const Color(0xCCFAF3E0)
              : const Color(0x44FAF3E0),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          color: Color(0xFFFAF3E0),
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (v) => _onChanged(v, index),
      ),
    );
  }
}
