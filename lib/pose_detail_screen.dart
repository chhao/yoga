import 'package:flutter/material.dart';
import 'package:yoga/models/pose.dart';

class PoseDetailScreen extends StatelessWidget {
  final Pose pose;

  const PoseDetailScreen({super.key, required this.pose});

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 0:
        return 'Beginner';
      case 1:
        return 'Intermediate';
      case 2:
        return 'Advanced';
      default:
        return '';
    }
  }

  String _getPositionText(int position) {
    switch (position) {
      case 1:
        return 'Standing';
      case 2:
        return 'Seated';
      case 3:
        return 'Supine';
      case 4:
        return 'Prone';
      case 5:
        return 'Kneeling';
      case 6:
        return 'Balancing';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> benefitsArray = pose.benefits.split('\n').where((s) => s.isNotEmpty).toList();
    final List<String> stepsArray = pose.description.split('\n').where((s) => s.isNotEmpty).toList();
    final List<String> typeArray = pose.type.split(', ').where((s) => s.isNotEmpty).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(pose.nameEn),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFC9DAD1),
                    Color(0xFFF7FAFA),
                  ],
                ),
              ),
              child: Center(
                child: Image.network(
                  pose.url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pose Title
                  Text(
                    pose.nameEn,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Pills
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEEBDD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getDifficultyText(pose.difficulty),
                          style: const TextStyle(color: Color(0xFFA75522), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE7CB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getPositionText(pose.position),
                          style: const TextStyle(color: Color(0xFFA75522), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ...typeArray.map((type) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF1D9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(color: Color(0xFFA75522), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sanskrit Name Section
                  if (pose.nameSa.isNotEmpty) ...[
                    const Text(
                      'Sanskrit Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pose.nameSa,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF555555)),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Benefits Section
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: benefitsArray.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        benefit,
                        style: const TextStyle(fontSize: 15, color: Color(0xFF555555)),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Steps Section
                  const Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: stepsArray.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '${idx + 1}. $step',
                          style: const TextStyle(fontSize: 15, color: Color(0xFF555555)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}