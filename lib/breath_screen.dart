import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga/models/breath_method.dart';
import 'package:yoga/widgets/breath_card.dart';
import 'package:yoga/breath_detail_screen.dart';

class BreathScreen extends StatefulWidget {
  const BreathScreen({super.key});

  @override
  State<BreathScreen> createState() => _BreathScreenState();
}

class _BreathScreenState extends State<BreathScreen> {
  List<BreathMethod> _breathMethods = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBreathMethods();
  }

  Future<void> _loadBreathMethods() async {
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    final String response = await rootBundle.loadString(
      'assets/data/breath_$languageCode.json',
    );
    final data = await json.decode(response) as List;
    setState(() {
      _breathMethods = data.map((json) => BreathMethod.fromJson(json)).toList();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: true,
      itemCount: _breathMethods.length,
      itemBuilder: (context, index) {
        final method = _breathMethods[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BreathDetailScreen(method: method),
              ),
            );
          },
          child: BreathCard(method: method),
        );
      },
    );
  }
}
