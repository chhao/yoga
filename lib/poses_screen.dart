import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga/models/pose.dart';
import 'package:yoga/widgets/pose_card.dart';
import 'package:yoga/pose_detail_screen.dart';
import 'package:yoga/generated/app_localizations.dart';

class PosesScreen extends StatefulWidget {
  const PosesScreen({super.key});

  @override
  State<PosesScreen> createState() => _PosesScreenState();
}

class _PosesScreenState extends State<PosesScreen> {
  List<Pose> _allPoses = [];
  List<Pose> _filteredPoses = [];
  String _searchQuery = '';
  int _difficultyLevel = -1;
  int _poseType = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPoses();
  }

  Future<void> _loadPoses() async {
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    final String response = await rootBundle.loadString(
      'assets/data/poses_$languageCode.json',
    );
    final data = await json.decode(response) as List;
    setState(() {
      _allPoses = data.map((json) => Pose.fromJson(json)).toList();
      _filterPoses(); // Apply filters after loading all poses
    });
  }

  void _filterPoses() {
    List<Pose> filtered = _allPoses;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (pose) =>
                pose.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                pose.nameEn.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                pose.nameSa.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_difficultyLevel != -1) {
      filtered = filtered
          .where((pose) => pose.difficulty == _difficultyLevel)
          .toList();
    }

    if (_poseType != -1) {
      filtered = filtered.where((pose) => pose.position == _poseType).toList();
    }

    setState(() {
      _filteredPoses = filtered;
    });
  }

  Future<void> _onRefresh() async {
    // Simulate network call or data refresh
    await Future.delayed(const Duration(seconds: 1));
    _loadPoses(); // Reload poses and re-apply filters
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            onChanged: (value) {
              _searchQuery = value;
              _filterPoses();
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchPoses,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(
                0xFFF7FAFA,
              ), // Set TextField background color
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<int>(
              value: _difficultyLevel,
              dropdownColor: const Color(
                0xFFF7FAFA,
              ), // Set Dropdown background color
              items: [
                DropdownMenuItem(
                  value: -1,
                  child: Text(AppLocalizations.of(context)!.allDifficulties),
                ),
                DropdownMenuItem(value: 0, child: Text(AppLocalizations.of(context)!.beginner)),
                DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context)!.intermediate)),
                DropdownMenuItem(value: 2, child: Text(AppLocalizations.of(context)!.advanced)),
              ],
              onChanged: (value) {
                setState(() {
                  _difficultyLevel = value!;
                  _filterPoses();
                });
              },
            ),
            DropdownButton<int>(
              value: _poseType,
              dropdownColor: const Color(
                0xFFF7FAFA,
              ), // Set Dropdown background color
              items: [
                DropdownMenuItem(value: -1, child: Text(AppLocalizations.of(context)!.allTypes)),
                DropdownMenuItem(value: 1, child: Text(AppLocalizations.of(context)!.standing)),
                DropdownMenuItem(value: 2, child: Text(AppLocalizations.of(context)!.seated)),
                DropdownMenuItem(value: 3, child: Text(AppLocalizations.of(context)!.supine)),
                DropdownMenuItem(value: 4, child: Text(AppLocalizations.of(context)!.prone)),
                DropdownMenuItem(value: 5, child: Text(AppLocalizations.of(context)!.kneeling)),
                DropdownMenuItem(value: 6, child: Text(AppLocalizations.of(context)!.balancing)),
              ],
              onChanged: (value) {
                setState(() {
                  _poseType = value!;
                  _filterPoses();
                });
              },
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              primary: true,
              itemCount: _filteredPoses.length,
              itemBuilder: (context, index) {
                final pose = _filteredPoses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PoseDetailScreen(pose: pose),
                      ),
                    );
                  },
                  child: PoseCard(pose: pose),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
