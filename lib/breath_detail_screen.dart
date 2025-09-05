import 'package:flutter/material.dart';
import 'package:yoga/models/breath_method.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'breath_practice_screen.dart';
import 'package:yoga/generated/app_localizations.dart';

class BreathDetailScreen extends StatelessWidget {
  final BreathMethod method;

  const BreathDetailScreen({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(method.name.zh),
        backgroundColor: const Color(0xFFF7FAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image and Titles
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(method.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: method.imageUrl == null || method.imageUrl!.isEmpty
                      ? Image.asset('assets/placeholder.png', fit: BoxFit.cover)
                      : null,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name.zh,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${method.name.sanskrit}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        method.summary,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Start Practice Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BreathPracticeScreen(breathMethod: method),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_fill),
                label: Text(AppLocalizations.of(context)!.startPractice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF52946B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
            ),

            // Main Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildCard(
                    title: AppLocalizations.of(context)!.originAndBackground,
                    body: Text(method.origin ?? AppLocalizations.of(context)!.none, style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                  ),
                  _buildCard(
                    title: AppLocalizations.of(context)!.mainBenefits,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.benefits.map((item) => _buildListItem(Icons.star, item, const Color(0xFF5B8C7A))).toList(),
                    ),
                  ),
                  _buildCard(
                    title: AppLocalizations.of(context)!.practiceSteps,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.steps.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('${entry.key + 1}. ${entry.value}', style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                      )).toList(),
                    ),
                  ),
                  if (method.steptip != null && method.steptip!.isNotEmpty)
                    _buildCard(
                      title:  AppLocalizations.of(context)!.tips,
                      body: Text(method.steptip!, style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                    ),
                  _buildCard(
                    title:  AppLocalizations.of(context)!.cautions,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.cautions.map((item) => _buildListItem(Icons.info, item, const Color(0xFFD97706))).toList(),
                    ),
                  ),
                  _buildCard(
                    title: AppLocalizations.of(context)!.suitableFor,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.audience.map((item) => _buildListItem(Icons.check_circle, item, const Color(0xFF5B8C7A))).toList(),
                    ),
                  ),
                  _buildCard(
                    title: AppLocalizations.of(context)!.recommendedWith,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: method.recommendations.map((item) => _buildListItem(Icons.link, item, const Color(0xFF5B8C7A))).toList(),
                    ),
                  ),
                  if (method.tips != null && method.tips!.isNotEmpty)
                    _buildTipsCard(method.tips!),
                ],
              ),
            ),
            const SizedBox(height: 16.0), // Padding at the bottom
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget body}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: const Color(0xE6FFFFFF), // rgba(255, 255, 255, 0.9)
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            const SizedBox(height: 8.0),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(String tipsText) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: const Color(0xFFFAF1D9), // Light yellow background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                tipsText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA75522),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}