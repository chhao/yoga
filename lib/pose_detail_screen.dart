import 'package:flutter/material.dart';
import 'package:yoga/models/pose.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga/generated/app_localizations.dart';

class PoseDetailScreen extends StatelessWidget {
  final Pose pose;

  const PoseDetailScreen({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(pose.name),
        backgroundColor: const Color(0xFFF7FAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xFFF7FAFA), // Background color from index.less
              child: Image.asset(
                pose.detailimgurl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/placeholder.png', fit: BoxFit.contain); // Placeholder image
                },
              ),
            ),

            // Content Body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pose Title
                  Text(
                    pose.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category Pills
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildPill(pose.difficulty_text(localizations), const Color(0xFFFDE7CB), const Color(0xFFA75522)),
                      _buildPill(pose.position_text(localizations), const Color(0xFFE8F2ED), const Color(0xFF52946B)),
                      ...pose.type_array.map((type) => _buildPill(type, const Color(0xFFFAF1D9), const Color(0xFFA75522))),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sanskrit Name Section
                  _buildSection(
                    title: AppLocalizations.of(context)!.sanskritName,
                    content: Text(pose.nameSa, style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                  ),
                  const SizedBox(height: 24),

                  // Benefits Section
                  _buildSection(
                    title: AppLocalizations.of(context)!.benefits,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pose.benefits_array.map((item) {
                        int colonIndex = item.indexOf(':');
                        if (colonIndex == -1) {
                          colonIndex = item.indexOf('：');
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: colonIndex != -1
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                                    children: [
                                      TextSpan(
                                        text: item.substring(0, colonIndex + 1),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: item.substring(colonIndex + 1)),
                                    ],
                                  ),
                                )
                              : Text(item, style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Steps Section
                  _buildSection(
                    title: AppLocalizations.of(context)!.steps,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pose.steps_array.asMap().entries.map((entry) {
                        final item = entry.value;
                        int colonIndex = item.indexOf(':');
                        if (colonIndex == -1) {
                          colonIndex = item.indexOf('：');
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: colonIndex != -1
                              ? RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                                    children: [
                                      TextSpan(text: '${entry.key + 1}. '),
                                      TextSpan(
                                        text: item.substring(0, colonIndex + 1),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: item.substring(colonIndex + 1)),
                                    ],
                                  ),
                                )
                              : Text('${entry.key + 1}. $item', style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}
