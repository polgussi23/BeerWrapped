// screens/profile/edit_email_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/components/groups/group_primary_button.dart';
import 'package:birrawrapped/components/groups/group_text_field.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({Key? key}) : super(key: key);

  @override
  _EditEmailScreenState createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentEmail = ModalRoute.of(context)!.settings.arguments as String;
    _controller = TextEditingController(text: currentEmail);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_controller.text.contains('@')) {
      setState(() => _errorMessage = 'Introdueix un email vàlid');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = context.read<UserProvider>().getUserId();
      await UserService()
          .updateEmail(userId.toString(), _controller.text.trim());

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      final msg = e.toString();
      setState(() => _errorMessage = msg.contains('409')
          ? 'Aquest email ja està en ús'
          : 'Error al actualitzar el email');
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
                  CustomSmallTitle(text: 'Canviar email'),
                  const SizedBox(height: 24),
                  GroupTextField(
                    controller: _controller,
                    hint: 'Nou email',
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
