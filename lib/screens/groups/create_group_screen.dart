// screens/groups/create_group_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/components/groups/group_primary_button.dart';
import 'package:birrawrapped/components/groups/group_text_field.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Cal posar un nom al grup');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await GroupsService().createGroup(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFFEDE4D3),
          title: const Text(
            'Grup creat!',
            style:
                TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Comparteix aquest codi perquè altres es puguin unir:'),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5884C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result['code'],
                  style: const TextStyle(
                    fontFamily: 'Kameron',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Entesos!'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(
          () => _errorMessage = 'Error al crear el grup. Torna-ho a intentar.');
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSmallTitle(text: "Crear grup"),
                  const SizedBox(height: 24),
                  GroupTextField(
                    controller: _nameController,
                    hint: 'Nom del grup',
                  ),
                  const SizedBox(height: 12),
                  GroupTextField(
                    controller: _descriptionController,
                    hint: 'Descripció (opcional)',
                    maxLines: 3,
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 24),
                  GroupPrimaryButton(
                    label: 'Crear grup',
                    isLoading: _isLoading,
                    onPressed: _createGroup,
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
