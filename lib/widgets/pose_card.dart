import 'package:flutter/material.dart';
import 'package:yoga/models/pose.dart';

class PoseCard extends StatelessWidget {
  final Pose pose;

  const PoseCard({super.key, required this.pose});

  String getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 0:
        return '初级';
      case 1:
        return '中级';
      case 2:
        return '高级';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0), // Equivalent to 24rpx
      padding: const EdgeInsets.all(16.0), // Equivalent to 1rem
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(12.0), // Equivalent to 0.75rem
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getDifficultyText(pose.difficulty),
                  style: const TextStyle(
                    color: Color(0xFF52946B),
                    fontSize: 14.0, // Equivalent to 0.875rem
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4.0), // Equivalent to 0.25rem
                Text(
                  pose.name,
                  style: const TextStyle(
                    color: Color(0xFF0E1B16),
                    fontSize: 16.0, // Equivalent to 1rem
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4.0), // Equivalent to 0.25rem
                Text(
                  pose.type, // This maps to name_sa in the reference
                  style: const TextStyle(
                    color: Color(0xFF52946B),
                    fontSize: 14.0, // Equivalent to 0.875rem
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0), // Equivalent to 1rem gap
          Container(
            width: 100.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF9C28D), // background-color from reference
              borderRadius: BorderRadius.circular(12.0), // Equivalent to 0.75rem
              image: DecorationImage(
                image: NetworkImage(pose.url),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: (pose.url.isEmpty)
                ? const Center(child: Icon(Icons.broken_image, color: Colors.grey)) // Placeholder for broken image
                : null,
          ),
        ],
      ),
    );
  }
}