import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoga/models/pose.dart';
import 'package:yoga/widgets/pose_card.dart';
import 'package:yoga/pose_detail_screen.dart';

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
  void initState() {
    super.initState();
    _loadPoses();
  }

  Future<void> _loadPoses() async {
    final String response = await rootBundle.loadString('assets/data/poses.json');
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
          .where((pose) =>
              pose.nameEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              pose.nameSa.toLowerCase().contains(_searchQuery.toLowerCase()))
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poses'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterPoses();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search Poses...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<int>(
                    value: _difficultyLevel,
                    items: const [
                      DropdownMenuItem(value: -1, child: Text('All Difficulties')),
                      DropdownMenuItem(value: 0, child: Text('Beginner')),
                      DropdownMenuItem(value: 1, child: Text('Intermediate')),
                      DropdownMenuItem(value: 2, child: Text('Advanced')),
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
                    items: const [
                      DropdownMenuItem(value: -1, child: Text('All Types')),
                      DropdownMenuItem(value: 1, child: Text('Standing')),
                      DropdownMenuItem(value: 2, child: Text('Seated')),
                      DropdownMenuItem(value: 3, child: Text('Supine')),
                      DropdownMenuItem(value: 4, child: Text('Prone')),
                      DropdownMenuItem(value: 5, child: Text('Kneeling')),
                      DropdownMenuItem(value: 6, child: Text('Balancing')),
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
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
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
    );
  }
}