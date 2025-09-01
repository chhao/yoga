import 'package:flutter/material.dart';
import 'package:yoga/models/breath_method.dart';

class BreathDetailScreen extends StatelessWidget {
  final BreathMethod method;

  const BreathDetailScreen({super.key, required this.method});

  // Brand Colors
  static const Color _brandGreen = Color(0xFF5B8C7A);
  static const Color _brandPeach = Color(0xFFF9EAE1);
  static const Color _brandBg = Color(0xFFF8FBFB);
  static const Color _brandTextDark = Color(0xFF2D3934);
  static const Color _brandTextLight = Color(0xFF707D78);
  static const Color _brandYellowLight = Color(0xFFFEFBEB);
  static const Color _brandYellowDark = Color(0xFFD97706);

  Widget _buildCard({required String title, required Widget body, Color? backgroundColor, Color? titleColor, Color? bodyColor}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: titleColor ?? _brandTextDark,
            ),
          ),
          const SizedBox(height: 16.0),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 15.0,
              color: bodyColor ?? _brandTextLight,
              height: 1.7,
            ),
            child: body,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({required IconData icon, required String text, Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // margin-bottom: 12px
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? _brandGreen, size: 20.0), // list-item-icon
          const SizedBox(width: 12.0), // margin-right: 12px
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15.0, color: _brandTextLight, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({required int stepNumber, required String stepText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // margin-bottom: 16px
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            decoration: BoxDecoration(
              color: _brandGreen,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 12.0), // margin-right: 12px
            child: Text(
              '$stepNumber',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
            ),
          ),
          Expanded(
            child: Text(
              stepText,
              style: const TextStyle(fontSize: 15.0, color: _brandTextLight, height: 1.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brandBg,
      appBar: AppBar(
        title: Text(method.name.en),
        backgroundColor: _brandBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header Image
                  if (method.imageUrl != null && method.imageUrl!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 180.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: _brandPeach, // background-color from reference
                        image: DecorationImage(
                          image: NetworkImage(method.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  // Header Title
                  Text(
                    method.name.zh,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: _brandTextDark,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Header Subtitle
                  Text(
                    '${method.name.en} / ${method.name.sanskrit}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: _brandTextLight,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Header Summary
                  Text(
                    method.summary,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                      color: _brandTextDark,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Practice Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement startPractice functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _brandGreen, // practice-button
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.play_circle_fill, size: 24.0),
                      label: const Text(
                        '开始跟练',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0), // margin-bottom: 24px for header

            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // padding: 0 16px
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Origin
                  if (method.origin != null && method.origin!.isNotEmpty)
                    _buildCard(
                      title: '📚 起源与背景',
                      body: Text(method.origin!),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Benefits
                  if (method.benefits.isNotEmpty)
                    _buildCard(
                      title: '🌟 主要功效',
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: method.benefits.map((benefit) => _buildListItem(icon: Icons.star, text: benefit)).toList(),
                      ),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Steps
                  if (method.steps.isNotEmpty)
                    _buildCard(
                      title: '🪷 练习步骤',
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...method.steps.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String step = entry.value;
                            return _buildStepItem(stepNumber: idx + 1, stepText: step);
                          }).toList(),
                          if (method.steptip != null && method.steptip!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0), // margin-top: 20px
                              child: Text(
                                'Tip: ${method.steptip!}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: _brandTextLight,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Cautions
                  if (method.cautions.isNotEmpty)
                    _buildCard(
                      title: '⚠️ 注意事项',
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: method.cautions.map((caution) => _buildListItem(icon: Icons.info_outline, text: caution, iconColor: _brandYellowDark)).toList(),
                      ),
                      backgroundColor: _brandYellowLight,
                      titleColor: _brandYellowDark,
                      bodyColor: _brandYellowDark, // darken(@brand-yellow-dark, 10%) - approximation
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Audience
                  if (method.audience.isNotEmpty)
                    _buildCard(
                      title: '🎯 适合人群',
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: method.audience.map((audience) => _buildListItem(icon: Icons.check_circle_outline, text: audience)).toList(),
                      ),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px
                  
                  // Recommendations
                  if (method.recommendations.isNotEmpty)
                    _buildCard(
                      title: '👍 推荐搭配',
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: method.recommendations.map((rec) => _buildListItem(icon: Icons.link, text: rec)).toList(),
                      ),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Tips
                  if (method.tips != null && method.tips!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '💡',
                            style: TextStyle(fontSize: 28.0),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            method.tips!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: _brandTextLight,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20.0), // gap: 20px

                  // Keywords
                  if (method.keywords.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0), // padding-top: 16px
                      child: Column(
                        children: [
                          const Text(
                            'Keywords:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: _brandTextLight,
                            ),
                          ),
                          const SizedBox(height: 16.0), // margin-bottom: 16px
                          Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            alignment: WrapAlignment.center,
                            children: method.keywords.map((keyword) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _brandGreen.withOpacity(0.1), // Approximation of t-tag light background
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                keyword,
                                style: const TextStyle(
                                  color: _brandGreen,
                                  fontSize: 12.0,
                                ),
                              ),
                            )).toList(),
                          ),
                        ],
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
}
