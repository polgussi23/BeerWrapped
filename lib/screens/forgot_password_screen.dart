import 'dart:async';
import 'package:flutter/material.dart';
import '../components/custom_background.dart';
import '../components/custom_title.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../services/forgot_password_service.dart'; // crea aquest servei

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ── Fase 1: introduir correu ──────────────────────────────────────────────
  final _emailController = TextEditingController();

  // ── Fase 2: introduir codi + nova contrasenya ─────────────────────────────
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ── Estat general ─────────────────────────────────────────────────────────
  bool _codeSent = false; // false = fase 1, true = fase 2
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  // Compte enrere per tornar a enviar
  int _secondsLeft = 0;
  Timer? _timer;
  bool get _canResend => _secondsLeft == 0;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in _codeControllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ── Temporitzador ─────────────────────────────────────────────────────────
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

  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Fase 1: enviar codi al correu ─────────────────────────────────────────
  Future<void> _sendResetCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Introdueix el teu correu.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      await ForgotPasswordService().sendResetCode(email);
      setState(() {
        _codeSent = true;
        _successMessage = 'Codi enviat a $email';
      });
      _startTimer();
    } catch (e) {
      setState(() =>
          _errorMessage = 'No s\'ha pogut enviar el codi. Comprova el correu.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Fase 2: verificar codi i canviar contrasenya ──────────────────────────
  Future<void> _resetPassword() async {
    final code = _codeControllers.map((c) => c.text).join();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (code.length < 6) {
      setState(() => _errorMessage = 'Introdueix els 6 dígits del codi.');
      return;
    }
    if (newPassword.isEmpty) {
      setState(() => _errorMessage = 'Introdueix la nova contrasenya.');
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => _errorMessage = 'Les contrasenyes no coincideixen.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await ForgotPasswordService().resetPassword(
        email: _emailController.text.trim(),
        code: code,
        newPassword: newPassword,
      );
      // Tornem al login amb un missatge d'èxit
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      setState(() => _errorMessage = 'Codi incorrecte o caducat.');
      for (final c in _codeControllers) c.clear();
      _focusNodes.first.requestFocus();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── Quan l'usuari escriu un dígit, salta al camp següent ─────────────────
  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  // ── Widgets ───────────────────────────────────────────────────────────────
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
        controller: _codeControllers[index],
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
        onChanged: (v) => _onCodeChanged(v, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                    // Icona i títol
                    const Icon(Icons.lock_reset_outlined,
                        size: 52, color: Color(0xFFFAF3E0)),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      'Has oblidat la contrasenya?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFAF3E0),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),

                    // Subtítol dinàmic segons la fase
                    Text(
                      _codeSent
                          ? 'Introdueix el codi que t\'hem enviat\ni la teva nova contrasenya.'
                          : 'T\'enviarem un codi de recuperació\nal teu correu electrònic.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0x99FAF3E0),
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // ── FASE 1: camp de correu ────────────────────────────
                    if (!_codeSent) ...[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.025, horizontal: 40.0),
                        decoration: BoxDecoration(
                          color: const Color(0x7FFAF3E0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: CustomTextField(
                          hintText: 'Correu electrònic',
                          controller: _emailController,
                          icon: const Icon(Icons.email_outlined,
                              color: Color(0xFFFAF3E0)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      CustomButton(
                        onPressed: _isLoading ? null : _sendResetCode,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('ENVIA EL CODI'),
                      ),
                    ],

                    // ── FASE 2: codi + nova contrasenya ──────────────────
                    if (_codeSent) ...[
                      // Camps del codi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) => _buildCodeBox(i)),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Camps de nova contrasenya
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
                          children: [
                            CustomTextField(
                              hintText: 'Nova contrasenya',
                              controller: _newPasswordController,
                              icon: const Icon(Icons.lock_outline,
                                  color: Color(0xFFFAF3E0)),
                              obscureText: true,
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            CustomTextField(
                              hintText: 'Confirma la contrasenya',
                              controller: _confirmPasswordController,
                              icon: const Icon(Icons.lock_outline,
                                  color: Color(0xFFFAF3E0)),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      CustomButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('CANVIA LA CONTRASENYA'),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Tornar a enviar el codi
                      const Text(
                        'No has rebut el codi?',
                        style:
                            TextStyle(color: Color(0x66FAF3E0), fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      _canResend
                          ? GestureDetector(
                              onTap: _isLoading ? null : _sendResetCode,
                              child: const Text(
                                'Torna a enviar el codi',
                                style: TextStyle(
                                  color: Color(0xFFFAF3E0),
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFFAF3E0),
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
                    ],

                    // ── Missatges d'error / èxit ──────────────────────────
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        _errorMessage,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (_successMessage.isNotEmpty) ...[
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        _successMessage,
                        style: const TextStyle(
                            color: Color(0xFF90EE90), fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    SizedBox(height: screenHeight * 0.06),

                    // Tornar al login
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Torna a l\'inici de sessió',
                        style: TextStyle(
                          color: const Color(0xFFFAF3E0),
                          fontFamily: 'Kameron',
                          fontSize: screenHeight * 0.020,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFFFAF3E0),
                          decorationThickness: 2.0,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
