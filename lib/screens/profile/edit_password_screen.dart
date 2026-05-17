// screens/profile/edit_password_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/components/groups/group_primary_button.dart';
import 'package:birrawrapped/components/groups/group_text_field.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({Key? key}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_currentController.text.isEmpty) {
      setState(() => _errorMessage = 'Introdueix la contrasenya actual');
      return;
    }
    if (_newController.text.length < 6) {
      setState(() =>
          _errorMessage = 'La nova contrasenya ha de tenir mínim 6 caràcters');
      return;
    }
    if (_newController.text != _confirmController.text) {
      setState(() => _errorMessage = 'Les contrasenyes no coincideixen');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = context.read<UserProvider>().getUserId();
      await UserService().updatePassword(
        userId.toString(),
        _currentController.text,
        _newController.text,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      final msg = e.toString();
      setState(() => _errorMessage = msg.contains('401')
          ? 'La contrasenya actual no és correcta'
          : 'Error al actualitzar la contrasenya');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSmallTitle(text: 'Canviar contrasenya'),
                  const SizedBox(height: 24),
                  // Contrasenya actual
                  _PasswordField(
                    controller: _currentController,
                    hint: 'Contrasenya actual',
                    show: _showCurrent,
                    onToggle: () =>
                        setState(() => _showCurrent = !_showCurrent),
                  ),
                  const SizedBox(height: 12),
                  // Nova contrasenya
                  _PasswordField(
                    controller: _newController,
                    hint: 'Nova contrasenya',
                    show: _showNew,
                    onToggle: () => setState(() => _showNew = !_showNew),
                  ),
                  const SizedBox(height: 12),
                  // Confirmar nova contrasenya
                  _PasswordField(
                    controller: _confirmController,
                    hint: 'Confirmar nova contrasenya',
                    show: _showConfirm,
                    onToggle: () =>
                        setState(() => _showConfirm = !_showConfirm),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  GroupPrimaryButton(
                    label: 'Guardar',
                    isLoading: _isLoading,
                    onPressed: _save,
                  ),
                  const SizedBox(height: 12),
                  const GroupCancelButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.show,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: !show,
      cursorColor: const Color(0xFFB5884C),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: const Color(0xFFEDE4D3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB5884C), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_off : Icons.visibility,
            color: Colors.black45,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
