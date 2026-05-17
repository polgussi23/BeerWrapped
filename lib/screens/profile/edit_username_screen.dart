// screens/profile/edit_username_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/components/groups/group_primary_button.dart';
import 'package:birrawrapped/components/groups/group_text_field.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({Key? key}) : super(key: key);

  @override
  _EditUsernameScreenState createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentUsername =
        ModalRoute.of(context)!.settings.arguments as String;
    _controller = TextEditingController(text: currentUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_controller.text.trim().length < 3) {
      setState(
          () => _errorMessage = 'El username ha de tenir mínim 3 caràcters');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = context.read<UserProvider>().getUserId();
      await UserService()
          .updateUsername(userId.toString(), _controller.text.trim());

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      final msg = e.toString();
      setState(() => _errorMessage = msg.contains('409')
          ? 'Aquest username ja està en ús'
          : 'Error al actualitzar el username');
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
                  CustomSmallTitle(text: 'Canviar username'),
                  const SizedBox(height: 24),
                  GroupTextField(
                    controller: _controller,
                    hint: 'Nou username',
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
