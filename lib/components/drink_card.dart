import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrinkCard extends StatelessWidget {
  final String text;
  final String? imageUrl; // per imatges de la API
  final String? imageAsset; // per imatges locals
  final VoidCallback onTap;

  const DrinkCard({
    Key? key,
    required this.text,
    required this.onTap,
    this.imageUrl,
    this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE4D3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Kameron',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: imageAsset != null
                    ? Image.asset(imageAsset!, fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
