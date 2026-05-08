import 'package:birrawrapped/components/action_card.dart';
import 'package:birrawrapped/components/custom_background.dart';
import 'package:birrawrapped/components/custom_small_title.dart';
import 'package:birrawrapped/components/custom_logout_button.dart';
import 'package:birrawrapped/components/custom_title.dart';
import 'package:birrawrapped/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseActionScreen extends StatefulWidget {
  const ChooseActionScreen({Key? key}) : super(key: key);

  @override
  _ChooseActionScreenState createState() => _ChooseActionScreenState();
}

class _ChooseActionScreenState extends State<ChooseActionScreen> {
  int _daysLeft = 0;
  String _daysLeftText = "";

  void getDaysLeft() {
    DateTime? date = context.read<UserProvider>().getStartDay();
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime finalDate = DateTime(date!.year + 1, date.month, date.day);

    _daysLeft = finalDate.difference(today).inDays;

    if (_daysLeft > 1)
      _daysLeftText = "Falten $_daysLeft dies";
    else
      _daysLeftText = "Acaba avui!";
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    getDaysLeft();

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
                    //CustomTitle(),
                    CustomSmallTitle(text: _daysLeftText),
                    ActionCard(
                        text: "He begut",
                        imagePath: "assets/images/minimalist_beer.png",
                        onTap: () {
                          Navigator.pushNamed(context, '/chooseDrink');
                        }),
                    ActionCard(
                        text: "A jugar!",
                        imagePath: "assets/images/accio_jocs.png",
                        onTap: () {
                          print("Click a A JUGAR");
                        }),
                    LogoutButton(onPressed: () {
                      print("Tanca la sessió");
                    })
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
