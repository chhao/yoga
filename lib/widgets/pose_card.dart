import 'package:flutter/material.dart';
import 'package:yoga/models/pose.dart';
import 'package:yoga/generated/app_localizations.dart';

class PoseCard extends StatelessWidget {
  final Pose pose;

  const PoseCard({super.key, required this.pose});

  String getDifficultyText(int difficulty, AppLocalizations localizations) {
    switch (difficulty) {
      case 0:
        return localizations.beginner;
      case 1:
        return localizations.intermediate;
      case 2:
        return localizations.advanced;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      height: 105.0, // Fixed height to prevent overflow
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
            child: SizedBox(
              height: 70.0, // Constrain height to align with image
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Distribute space
                children: [
                  Text(
                    getDifficultyText(pose.difficulty, localizations),
                    style: const TextStyle(
                      color: Color(0xFF52946B),
                      fontSize: 14.0, // Equivalent to 0.875rem
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pose.name,
                    style: const TextStyle(
                      color: Color(0xFF0E1B16),
                      fontSize: 16.0, // Equivalent to 1rem
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pose.type, // This maps to name_sa in the reference
                    style: const TextStyle(
                      color: Color(0xFF52946B),
                      fontSize: 14.0, // Equivalent to 0.875rem
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Equivalent to 1rem gap
          Container(
            width: 100.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: const Color(0xFFF9C28D), // background-color from reference
              borderRadius: BorderRadius.circular(
                12.0,
              ), // Equivalent to 0.75rem
              image: DecorationImage(
                image: AssetImage(pose.tbimageurl),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: (pose.tbimageurl.isEmpty)
                ? const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ) // Placeholder for broken image
                : null,
          ),
        ],
      ),
    );
  }
}