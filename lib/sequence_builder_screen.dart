import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/models/pose.dart';
import 'package:yoga/models/sequence.dart' as yoga_sequence;

class SequenceBuilderScreen extends StatefulWidget {
  static const routeName = '/sequence_builder';

  const SequenceBuilderScreen({super.key});

  @override
  State<SequenceBuilderScreen> createState() => _SequenceBuilderScreenState();
}

class _SequenceBuilderScreenState extends State<SequenceBuilderScreen> {
  List<Pose> _allPoses = [];
  List<Pose> _filteredPoses = [];
  List<Map<String, dynamic>> _selectedPoses = []; // Using Map to store pose + duration
  TextEditingController _searchQueryController = TextEditingController();
  TextEditingController _sequenceNameController = TextEditingController();

  bool _isEditing = false;
  String _originalSequenceName = '';

  List<String> _difficultyOptions = ['全部', '初级', '中级', '高级'];
  int _difficultyFilterIndex = 0;
  List<String> _poseTypeOptions = ['不限', '站立', '坐姿', '仰卧', '俯卧', '跪姿', '平衡'];
  int _poseTypeFilterIndex = 0;

  bool _isDialogVisible = false;
  int? _currentPoseIndexInSelectedList;
  int _currentPoseDuration = 60;
  String _formattedTotalDuration = '0 分钟';

  @override
  void initState() {
    super.initState();
    _loadPoses();
    _searchQueryController.addListener(_onSearchChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is yoga_sequence.Sequence && !_isEditing) { // Only load if not already editing
      _loadSequenceForEditing(args);
    }
  }

  @override
  void dispose() {
    _searchQueryController.removeListener(_onSearchChange);
    _searchQueryController.dispose();
    _sequenceNameController.dispose();
    super.dispose();
  }

  Future<void> _loadPoses() async {
    final String response = await rootBundle.loadString('assets/data/poses.json');
    final data = json.decode(response) as List;
    setState(() {
      _allPoses = data.map((json) => Pose.fromJson(json)).toList();
      _applyFilters();
    });
  }

  void _loadSequenceForEditing(yoga_sequence.Sequence sequence) async {
    // Ensure all poses are loaded before processing the sequence
    if (_allPoses.isEmpty) {
      await _loadPoses();
    }

    final List<Map<String, dynamic>> posesWithDuration = [];
    for (var seqPose in sequence.poses) {
      try {
        final fullPose = _allPoses.firstWhere((pose) => pose.id == seqPose.id, orElse: () => throw Exception('Pose with ID ${seqPose.id} not found in poses.json'));
        posesWithDuration.add({
          'id': fullPose.id,
          'name': fullPose.name,
          'name_en': fullPose.nameEn,
          'name_sa': fullPose.nameSa,
          'benefits': fullPose.benefits,
          'description': fullPose.description,
          'difficulty': fullPose.difficulty,
          'aka_chinese': fullPose.akaChinese,
          'position': fullPose.position,
          'type': fullPose.type,
          'bg': fullPose.bg,
          'url': fullPose.url,
          'duration': seqPose.time, // Use time from SequencePose as duration
        });
      } catch (e) {
        print('Error loading pose ${seqPose.id} for editing: $e');
        // Optionally, you can add a placeholder or skip this pose
      }
    }

    setState(() {
      _selectedPoses = posesWithDuration;
      _sequenceNameController.text = sequence.name;
      _isEditing = true;
      _originalSequenceName = sequence.name;
    });
    _calculateAndSetTotalDuration();
  }

  void _calculateAndSetTotalDuration() {
    if (_selectedPoses.isEmpty) {
      setState(() {
        _formattedTotalDuration = '0 分钟';
      });
      return;
    }
    final totalSeconds = _selectedPoses.fold<int>(0, (acc, pose) => acc + (pose['duration'] as int));
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    String formatted = '';
    if (seconds == 0) {
      formatted = '$minutes 分钟';
    } else {
      formatted = '$minutes分$seconds秒';
    }
    setState(() {
      _formattedTotalDuration = formatted;
    });
  }

  void _onSearchChange() {
    _applyFilters();
  }

  void _onDifficultyFilterChange(int? newValue) {
    if (newValue != null) {
      setState(() {
        _difficultyFilterIndex = newValue;
      });
      _applyFilters();
    }
  }

  void _onPoseTypeFilterChange(int? newValue) {
    if (newValue != null) {
      setState(() {
        _poseTypeFilterIndex = newValue;
      });
      _applyFilters();
    }
  }

  void _applyFilters() {
    final String searchQuery = _searchQueryController.text.toLowerCase();
    final int difficultyFilterIndex = _difficultyFilterIndex;
    final int poseTypeFilterIndex = _poseTypeFilterIndex;

    List<Pose> filtered = _allPoses.where((pose) {
      final matchSearch = searchQuery.isEmpty ||
          (pose.name.toLowerCase().contains(searchQuery) ||
              pose.nameSa.toLowerCase().contains(searchQuery));

      final matchDifficulty = (difficultyFilterIndex == 0) || (pose.difficulty == (difficultyFilterIndex - 1));

      final poseTypeMap = {
        0: -1, // 不限
        1: 1,  // 站立
        2: 2,  // 坐姿
        3: 3,  // 仰卧
        4: 4,  // 俯卧
        5: 5,  // 跪姿
        6: 6   // 平衡
      };
      final selectedPoseType = poseTypeMap[poseTypeFilterIndex];
      final matchPoseType = (selectedPoseType == -1) || (pose.position == selectedPoseType);

      return matchSearch && matchDifficulty && matchPoseType;
    }).toList();

    setState(() {
      _filteredPoses = filtered;
    });
  }

  void _addPoseToSequence(Pose pose) {
    setState(() {
      _selectedPoses.add({
        'id': pose.id,
        'name': pose.name,
        'name_en': pose.nameEn,
        'name_sa': pose.nameSa,
        'benefits': pose.benefits,
        'description': pose.description,
        'difficulty': pose.difficulty,
        'aka_chinese': pose.akaChinese,
        'position': pose.position,
        'type': pose.type,
        'bg': pose.bg,
        'url': pose.url,
        'duration': 60, // Default duration
      });
    });
    _calculateAndSetTotalDuration();
  }

  void _removePoseFromSequence(int index) {
    setState(() {
      _selectedPoses.removeAt(index);
    });
    _calculateAndSetTotalDuration();
  }

  void _openDurationDialog(int index) {
    setState(() {
      _isDialogVisible = true;
      _currentPoseIndexInSelectedList = index;
      _currentPoseDuration = _selectedPoses[index]['duration'] as int;
    });
  }

  void _onDialogStepperChange(int value) {
    setState(() {
      _currentPoseDuration = value;
    });
  }

  void _onDialogConfirm() {
    if (_currentPoseIndexInSelectedList != null) {
      setState(() {
        _selectedPoses[_currentPoseIndexInSelectedList!]['duration'] = _currentPoseDuration;
        _isDialogVisible = false;
      });
      _calculateAndSetTotalDuration();
    }
  }

  void _onDialogCancel() {
    setState(() {
      _isDialogVisible = false;
    });
  }

  Future<void> _saveSequence() async {
    final String sequenceName = _sequenceNameController.text.trim();

    if (sequenceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入序列名称')),
      );
      return;
    }

    if (_selectedPoses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一个体式')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedSequencesJson = prefs.getStringList('savedSequences') ?? [];
    List<yoga_sequence.Sequence> savedSequences = savedSequencesJson.map((jsonString) =>
        yoga_sequence.Sequence.fromJson(json.decode(jsonString))).
        toList();

    final List<yoga_sequence.SequencePose> sequencePoses = _selectedPoses.map((poseMap) =>
        yoga_sequence.SequencePose(
          id: poseMap['id'] as String,
          time: poseMap['duration'] as int,
          goal: '', // WeChat Mini Program doesn't have a goal field for poses in sequence
        )).toList();

    final newSequence = yoga_sequence.Sequence(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
      name: sequenceName,
      englishName: '', // Not available in this context
      scenario: '', // Not available in this context
      poses: sequencePoses,
    );

    if (_isEditing) {
      final index = savedSequences.indexWhere((seq) => seq.name == _originalSequenceName);
      if (index != -1) {
        savedSequences[index] = newSequence;
      }
    } else {
      final existingIndex = savedSequences.indexWhere((seq) => seq.name == sequenceName);
      if (existingIndex != -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('序列名称已存在')),
        );
        return;
      }
      savedSequences.add(newSequence);
    }

    final updatedSavedSequencesJson = savedSequences.map((seq) => json.encode(seq.toJson())).toList();
    await prefs.setStringList('savedSequences', updatedSavedSequencesJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('序列已保存')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑序列' : '创建新序列'),
        backgroundColor: const Color(0xFFF7FAFA),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF7FAFA),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '创建你的专属瑜伽序列',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Left Column: All Poses
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 0,
                      color: const Color(0xFFF7FAFA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('所有体式', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: TextField(
                              controller: _searchQueryController,
                              decoration: InputDecoration(
                                hintText: '搜索体式...', 
                                filled: true,
                                fillColor: Color(0xFFE8F2ED),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              children: [
                                _buildFilterDropdown(
                                  label: '难度',
                                  options: _difficultyOptions,
                                  currentIndex: _difficultyFilterIndex,
                                  onChanged: _onDifficultyFilterChange,
                                ),
                                SizedBox(height: 8.0),
                                _buildFilterDropdown(
                                  label: '体式',
                                  options: _poseTypeOptions,
                                  currentIndex: _poseTypeFilterIndex,
                                  onChanged: _onPoseTypeFilterChange,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredPoses.length,
                              itemBuilder: (context, index) {
                                final pose = _filteredPoses[index];
                                return GestureDetector(
                                  onTap: () => _addPoseToSequence(pose),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            color: Color(0xFFF9C28D),
                                            image: DecorationImage(
                                              image: AssetImage(pose.tbimageurl),
                                              fit: BoxFit.cover,
                                              onError: (exception, stackTrace) {
                                                // Fallback to placeholder if image fails to load
                                                print('Error loading asset: assets/yoga-tb/tb_${pose.id}.png - $exception');
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12.0), // Equivalent to 24rpx gap
                                        Expanded(
                                          child: Text(pose.name, style: TextStyle(fontSize: 14, color: Color(0xFF1F2937))),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Right Column: Selected Poses
                  Expanded(
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 0,
                      color: const Color(0xFFF7FAFA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('当前序列', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text(_formattedTotalDuration, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: TextField(
                              controller: _sequenceNameController,
                              decoration: InputDecoration(
                                hintText: '为你的序列取个名字',
                                filled: true,
                                fillColor: Color(0xFFE8F2ED),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _selectedPoses.length,
                              itemBuilder: (context, index) {
                                final poseMap = _selectedPoses[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  elevation: 0,
                                  color: Color(0xFFE8F2ED),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(poseMap['name'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                              SizedBox(height: 4.0), // Add some vertical spacing
                                              GestureDetector(
                                                onTap: () => _openDurationDialog(index),
                                                child: Row(
                                                  children: [
                                                    Text('${poseMap['duration']} 秒', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
                                                    SizedBox(width: 8.0),
                                                    Icon(Icons.edit, size: 16, color: Color(0xFF666666)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: IconButton(
                                            icon: Icon(Icons.delete, color: Color(0xFF666666)),
                                            onPressed: () => _removePoseFromSequence(index),
                                            padding: EdgeInsets.zero, // Remove default padding
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: _saveSequence,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF52946B),
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              ),
                              child: Text(_isEditing ? '更新序列' : '保存序列'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Duration Editor Dialog
      bottomSheet: _isDialogVisible
          ? AlertDialog(
              title: Text('设置时长 (秒)'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('当前时长: $_currentPoseDuration 秒'),
                  Slider(
                    value: _currentPoseDuration.toDouble(),
                    min: 10,
                    max: 300,
                    divisions: (300 - 10) ~/ 10, // 10-second steps
                    onChanged: (value) => _onDialogStepperChange(value.toInt()),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _onDialogCancel,
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: _onDialogConfirm,
                  child: Text('确认'),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> options,
    required int currentIndex,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFE8F2ED),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          DropdownButton<int>(
            value: currentIndex,
            items: options.asMap().entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: onChanged,
            underline: Container(), // Remove underline
            icon: Icon(Icons.arrow_drop_down, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}
