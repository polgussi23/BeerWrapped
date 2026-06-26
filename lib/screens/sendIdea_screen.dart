import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_button.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/custom_text_area.dart';
import 'package:birrawrapped/components/custom_text_field.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:birrawrapped/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class sendIdeaScreen extends StatefulWidget {
  const sendIdeaScreen({Key? key}) : super(key: key);

  @override
  _sendIdeaScreenState createState() => _sendIdeaScreenState();
}

class _sendIdeaScreenState extends State<sendIdeaScreen> {
  final _assumpteController = TextEditingController();
  final _bodyController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void sendIdea() async {
    try {
      final userId = context.read<UserProvider>().getUserId();
      await UserService().sendNewIdea(
          userId.toString(), _assumpteController.text, _bodyController.text);
      await showOkDialog();
      print("tot ok!");
      Navigator.pop(context);
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  Future<void> showOkDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFEDE4D3),
        title: const Text(
          'Gràcies!',
          style: TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'La teva idea ha sigut enviada correctament!\n\n'
          'Això vol dir que és possible que en els pròxims dies, setmanes, mesos, anys, dècades o segles la vegis implementada aquí!!!\n\n',
          style: TextStyle(fontFamily: 'Kameron', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'D\'acord!',
              style: TextStyle(
                color: Color(0xFFB5884C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(String error) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 233, 113, 92),
        title: const Text(
          'EP!',
          style: TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Sembla que alguna cosa ha anat malament.\n\n'
          'Torna a provar d\'enviar la teva idea més endavant.\n\n'
          'Error: $error',
          style: const TextStyle(fontFamily: 'Kameron', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'D\'acord!',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomSmallTitle(text: "Envia la teva idea!"),
                    CustomTextField(
                        hintText: "Assumpte",
                        controller: _assumpteController,
                        icon: const Icon(
                          Icons.tungsten,
                          color: Color(0xFFEDE4D3),
                        )),
                    CustomTextArea(
                        hintText: "Idea",
                        controller: _bodyController,
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color(0xFFEDE4D3),
                        )),
                    SizedBox(height: 32),
                    CustomButton(
                        onPressed: () {
                          sendIdea();
                        },
                        child: Text("Envia")),
                    // Banner del wrapped
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
