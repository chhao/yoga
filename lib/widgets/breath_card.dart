import 'package:flutter/material.dart';
import 'package:yoga/models/breath_method.dart';

class BreathCard extends StatelessWidget {
  final BreathMethod method;

  const BreathCard({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0), // gap: 20px
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(12, 0, 0, 0),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias, // Ensures image respects border radius
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Image
          Container(
            width: double.infinity,
            height: 160.0,
            color: const Color(0xFFF9EAE1), // @brand-peach
            child: (method.imageUrl != null && method.imageUrl!.isNotEmpty)
                ? Image.network(
                    method.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  )
                : const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Name
                Text(
                  method.name.zh,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3934), // @brand-text-dark
                  ),
                ),
                const SizedBox(height: 8.0),
                // Card Keywords
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: method.keywords
                      .map(
                        (keyword) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE8F3EF,
                            ), // @td-tag-light-background-color
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // border-radius
                          ),
                          child: Text(
                            keyword,
                            style: const TextStyle(
                              color: Color(0xFF5B8C7A), // @brand-green
                              fontSize: 12.0, // small size
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
