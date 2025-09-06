import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/generated/app_localizations.dart';
import 'package:yoga/models/sequence.dart' as yoga_sequence;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoga/practice_mode_screen.dart';
import 'package:yoga/sequence_builder_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<yoga_sequence.Sequence> _savedSequences = [];
  List<yoga_sequence.Sequence> _selectedSequences = [];

  int _difficultyIndex = 0;
  int _durationIndex = 1;
  int _locationIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSequences();
  }

  Future<void> _loadSequences() async {
    await _loadSavedSequences();
    await _loadSelectedSequences();
  }

  Future<void> _loadSavedSequences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSequencesJson = prefs.getStringList('savedSequences') ?? [];
    setState(() {
      _savedSequences = savedSequencesJson.map((jsonString) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        final sequence = yoga_sequence.Sequence.fromJson(jsonMap);
        // Calculate formatted duration for saved sequences
        
        return sequence;
      }).toList();
    });
  }

  Future<void> _loadSelectedSequences() async {
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    final String response = await rootBundle.loadString(
      'assets/data/sequences_$languageCode.json',
    );
    final data = await json.decode(response) as List;
    setState(() {
      _selectedSequences = data.map((json) {
        final sequence = yoga_sequence.Sequence.fromJson(json);
        // Calculate formatted duration for selected sequences
        
        return sequence;
      }).toList();
    });
  }

  void _onDifficultyChange(int? newValue) {
    if (newValue != null) {
      setState(() {
        _difficultyIndex = newValue;
      });
    }
  }

  void _onDurationChange(int? newValue) {
    if (newValue != null) {
      setState(() {
        _durationIndex = newValue;
      });
    }
  }

  void _onLocationChange(int? newValue) {
    if (newValue != null) {
      setState(() {
        _locationIndex = newValue;
      });
    }
  }

  void _onStartPractice() {
    Navigator.pushNamed(
      context,
      PracticeModeScreen.routeName,
      arguments: {
        'difficulty': _difficultyIndex,
        'duration': _durationIndex,
        'location': _locationIndex,
      },
    );
  }

  void _goToSequenceBuilder() async {
    await Navigator.pushNamed(context, SequenceBuilderScreen.routeName);
    _loadSavedSequences(); // Refresh saved sequences after returning
  }

  void _startSavedSequence(yoga_sequence.Sequence sequence) {
    Navigator.pushNamed(
      context,
      PracticeModeScreen.routeName,
      arguments: sequence,
    );
  }

  void _editSequence(yoga_sequence.Sequence sequence) async {
    await Navigator.pushNamed(
      context,
      SequenceBuilderScreen.routeName,
      arguments: sequence,
    );
    _loadSavedSequences(); // Refresh saved sequences after returning
  }

  Future<void> _deleteSequence(String sequenceName) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedSavedSequences = _savedSequences.where((seq) => seq.name != sequenceName).toList();
    final updatedSavedSequencesJson = updatedSavedSequences.map((seq) => json.encode((seq as yoga_sequence.Sequence).toJson())).toList();
    await prefs.setStringList('savedSequences', updatedSavedSequencesJson);
    if (!mounted) return;
    setState(() {
      _savedSequences = updatedSavedSequences;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.sequenceDeleted(sequenceName))),
    );
  }

  void _startSelectedSequence(yoga_sequence.Sequence sequence) {
    Navigator.pushNamed(
      context,
      PracticeModeScreen.routeName,
      arguments: sequence,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<String> difficultyOptions = [
      localizations.beginner,
      localizations.intermediate,
      localizations.advanced
    ];
    final List<String> durationOptions = [
      localizations.duration15,
      localizations.duration30,
      localizations.duration45,
      localizations.duration60
    ];
    final List<String> locationOptions = [
      localizations.locationAny,
      localizations.locationStanding,
      localizations.locationSeated
    ];

    return Container(
      color: const Color(0xFFF7FAFA), // Background color from index.less
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 64, 32, 24),
            child: Column(
              children: [
                Text(
                  localizations.practiceCenter,
                  style: const TextStyle(
                    fontSize: 24, // 48rpx / 2
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 6), // 12rpx / 2
                Text(
                  localizations.practiceCenterSubtitle,
                  style: const TextStyle(
                    fontSize: 14, // 28rpx / 2
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              padding: const EdgeInsets.only(bottom: 80), // Adjust for tab bar
              child: Column(
                children: [
                  // Saved Sequences Section
                  _buildSectionCard(
                    title: localizations.mySavedSequences,
                    children: [
                      if (_savedSequences.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24), // 48rpx / 2
                          child: Text(
                            localizations.noSavedSequences,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFF888888)),
                          ),
                        ),
                      ..._savedSequences.map((sequence) => _buildSequenceItem(
                            sequence: sequence,
                            onPlay: () => _startSavedSequence(sequence),
                            onEdit: () => _editSequence(sequence),
                            onDelete: () => _deleteSequence(sequence.name),
                          )),
                      _buildPrimaryButton(
                        text: localizations.createNewSequence,
                        onPressed: _goToSequenceBuilder,
                      ),
                    ],
                  ),
                  // Selected Sequences Section
                  _buildSectionCard(
                    title: localizations.featuredSequences,
                    children: [
                      ..._selectedSequences.map((sequence) => _buildSequenceItem(
                            sequence: sequence,
                            onPlay: () => _startSelectedSequence(sequence),
                            showEditDelete: false, // No edit/delete for selected sequences
                          )),
                    ],
                  ),
                  // Quick Practice Section
                  _buildSectionCard(
                    title: localizations.quickPractice,
                    description: localizations.quickPracticeSubtitle,
                    children: [
                      _buildFormItem(
                        label: localizations.practiceDifficulty,
                        value: difficultyOptions[_difficultyIndex],
                        onTap: () => _showPicker(
                          context,
                          difficultyOptions,
                          _difficultyIndex,
                          _onDifficultyChange,
                        ),
                      ),
                      _buildFormItem(
                        label: localizations.practiceDuration,
                        value: durationOptions[_durationIndex],
                        onTap: () => _showPicker(
                          context,
                          durationOptions,
                          _durationIndex,
                          _onDurationChange,
                        ),
                      ),
                      _buildFormItem(
                        label: localizations.locationPreference,
                        value: locationOptions[_locationIndex],
                        onTap: () => _showPicker(
                          context,
                          locationOptions,
                          _locationIndex,
                          _onLocationChange,
                        ),
                      ),
                      _buildPrimaryButton(
                        text: localizations.startQuickPractice,
                        onPressed: _onStartPractice,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? description,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0), // 48rpx / 2, 32rpx / 2
      padding: const EdgeInsets.all(16), // 32rpx / 2
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFA),
        borderRadius: BorderRadius.circular(12), // 24rpx / 2
        boxShadow: [
          BoxShadow(
            color: const Color(0x14000000), // rgba(0, 0, 0, 0.08)
            blurRadius: 12, // 24rpx / 2
            offset: const Offset(0, 4), // 8rpx / 2
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16), // 32rpx / 2
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18, // 36rpx / 2
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4), // 8rpx / 2
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14, // 28rpx / 2
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSequenceItem({
    required yoga_sequence.Sequence sequence,
    required VoidCallback onPlay,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    bool showEditDelete = true,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // 24rpx / 2
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sequence.name,
                  style: const TextStyle(
                    fontSize: 15, // 30rpx / 2
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${localizations.posesCount(sequence.poses.length)} ${localizations.totalDuration(sequence.totalDurationFormatted(localizations))}',
                  style: const TextStyle(
                    fontSize: 12, // 24rpx / 2
                    color: Color(0xFF888888),
                  ),
                ),
                if (sequence.scenario.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4), // 8rpx / 2
                    child: Text(
                      sequence.scenario,
                      style: const TextStyle(
                        fontSize: 11, // 22rpx / 2
                        color: Color(0xFFA0A0A0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(
                iconData: Icons.play_arrow, // Using a Material Icon for play for now
                backgroundColor: const Color(0xFF52946B),
                iconColor: Colors.white,
                onPressed: onPlay,
              ),
              if (showEditDelete) ...[
                const SizedBox(width: 8), // 16rpx / 2
                _buildActionButton(
                  iconData: Icons.edit, // Edit icon
                  backgroundColor: const Color(0xFFE8F2ED),
                  iconColor: const Color(0xFF52946B),
                  onPressed: onEdit!,
                ),
                const SizedBox(width: 8), // 16rpx / 2
                _buildActionButton(
                  iconData: Icons.delete, // Delete icon
                  backgroundColor: const Color(0xFFE8F2ED),
                  iconColor: const Color(0xFF52946B),
                  onPressed: onDelete!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData iconData,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 32, // 64rpx / 2
      height: 32, // 64rpx / 2
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 18, // Adjust size as needed
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8), // 16rpx / 2
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF52946B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12), // 24rpx / 2
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // 16rpx / 2
            ),
            textStyle: const TextStyle(
              fontSize: 16, // 32rpx / 2
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
          ),
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildFormItem({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // 24rpx / 2
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14, // 28rpx / 2
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4), // 8rpx / 2
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12), // 24rpx / 2
              decoration: BoxDecoration(
                color: const Color(0xFFE8F2ED),
                borderRadius: BorderRadius.circular(6), // 12rpx / 2
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14, // 28rpx / 2
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(
    BuildContext context,
    List<String> options,
    int currentIndex,
    ValueChanged<int?> onChanged,
  ) {
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF7FAFA),
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF52946B),
                    ),
                    child: Text(localizations.cancel),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF52946B),
                    ),
                    child: Text(localizations.confirm),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(options[index]),
                      onTap: () {
                        onChanged(index);
                        Navigator.pop(context);
                      },
                      selected: index == currentIndex,
                      selectedColor: const Color(0xFF52946B),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Extend the Sequence class to include totalDurationFormatted
extension SequenceExtension on yoga_sequence.Sequence {
  String totalDurationFormatted(AppLocalizations localizations) {
    final totalSeconds = poses.fold<int>(
      0,
          (acc, pose) => acc + pose.time,
    );
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (seconds == 0) {
      return localizations.minutes(minutes);
    }
    return localizations.minutesSeconds(minutes, seconds);
  }
}