// screens/groups/join_group_screen.dart
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/groups/group_cancel_button.dart';
import 'package:birrawrapped/components/groups/group_primary_button.dart';
import 'package:birrawrapped/components/groups/group_text_field.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/groups_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({Key? key}) : super(key: key);

  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirmJoin() async {
    final code = _codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() => _errorMessage = 'Cal introduir un codi');
      return;
    }

    // Diàleg de confirmació humorístic
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text(
          'Ei, espera! 🍺',
          style: TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Estàs a punt d\'unir-te a un grup on:\n\n'
          '🔍 Tota la teva activitat birrística serà exposada públicament\n\n'
          '📊 Els teus amics sabran exactament quantes canyes t\'has pres\n\n'
          '🫵 Ningú et podrà dir que no en beus cap\n\n'
          'Segueixes endavant?',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Millor no...',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Endavant! 🍻',
              style: TextStyle(
                color: Color(0xFFB5884C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) _joinGroup(code);
  }

  Future<void> _joinGroup(String code) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId = context.read<UserProvider>().getUserId();
      await GroupsService().joinGroup(userId.toString(), code);

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFFEDE4D3),
          title: const Text(
            'Benvingut al grup! 🍺',
            style:
                TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Ara formes part del grup. La teva vida privada ja no existeix. Salut!',
            style: TextStyle(fontFamily: 'Kameron'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Ho assumeixo! 🍻'),
            ),
          ],
        ),
      );
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('404')) {
        setState(() => _errorMessage =
            'Codi incorrecte, comprova-ho i torna-ho a intentar');
      } else if (msg.contains('409')) {
        setState(() => _errorMessage = 'Ja ets membre d\'aquest grup');
      } else {
        setState(() =>
            _errorMessage = 'Error al unir-se al grup. Torna-ho a intentar.');
      }
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
                  CustomSmallTitle(text: "Unir-se a un grup"),
                  const SizedBox(height: 24),
                  GroupTextField(
                    controller: _codeController,
                    hint: 'XXXX-XXXX',
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      fontFamily: 'Kameron',
                      fontSize: 24,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
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
                    label: 'Unir-se',
                    isLoading: _isLoading,
                    onPressed: _confirmJoin,
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
