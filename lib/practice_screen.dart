import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga/models/sequence.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<Sequence> _sequences = [];

  @override
  void initState() {
    super.initState();
    _loadSequences();
  }

  Future<void> _loadSequences() async {
    final String response = await rootBundle.loadString('assets/data/sequences.json');
    final data = await json.decode(response) as List;
    setState(() {
      _sequences = data.map((json) => Sequence.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: ListView.builder(
        itemCount: _sequences.length,
        itemBuilder: (context, index) {
          final sequence = _sequences[index];
          return ListTile(
            title: Text(sequence.englishName),
            subtitle: Text(sequence.scenario),
          );
        },
      ),
    );
  }
}