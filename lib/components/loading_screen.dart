// lib/widgets/loading_screen.dart
import 'package:flutter/material.dart';
import 'custom_background.dart'; // ajusta l'import al teu projecte
import 'loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  final String text;
  final String? title;
  final bool showBackButton;

  const LoadingScreen({
    super.key,
    this.text = 'Carregant...',
    this.title,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Column(
              children: [
                if (showBackButton || title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Row(
                      children: [
                        if (showBackButton)
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              style: const TextStyle(
                                fontFamily: 'Kameron',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: LoadingIndicator(text: text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
