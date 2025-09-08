
// lib/practice_mode_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/generated/app_localizations.dart';
import 'package:yoga/models/pose.dart';
import 'package:yoga/models/sequence.dart';

class PracticePose {
  final Pose pose;
  final int duration;

  PracticePose({required this.pose, required this.duration});
}

// Helper function to format time (minutes:seconds)
String formatTime(int seconds) {
  print('formatTime received seconds: $seconds');
  final m = (seconds ~/ 60).toString().padLeft(2, '0');
  final s = (seconds % 60).toString().padLeft(2, '0');
  return m + ':' + s;
}

class PracticeModeScreen extends StatefulWidget {
  static const routeName = '/practice_mode'; // Define a route name for easy navigation

  const PracticeModeScreen({super.key});

  @override
  State<PracticeModeScreen> createState() => _PracticeModeScreenState();
}

class _PracticeModeScreenState extends State<PracticeModeScreen> {
  bool _isLoading = true;
  List<PracticePose> _poses = [];
  int _currentPoseIndex = 0;
  Timer? _timer;
  int _remainingTime = 0; // Total remaining time for the entire practice
  int _totalTime = 0; // Total duration of the entire practice
  bool _isPlaying = true;
  bool _showModal = false;
  int _currentPoseRemainingTime = 0; // Remaining time for the current pose
  String _formattedCurrentPoseRemainingTime = '00:00';
  int _restTime = 0; // Time spent in pause state
  String _formattedRestTime = '00:00';

  String _modalTitle = '';
  String _modalContent = '';
  String _modalConfirm = '';
  String _modalCancel = '';
  VoidCallback? _onConfirm;
  VoidCallback? _onCancel;

  bool _isMusicOn = false;
  bool _isSoundEffectsOn = true;

  // Audio Players
  late AudioPlayer _tickAudioPlayer;
  late AudioPlayer _chimeAudioPlayer;
  late AudioPlayer _backgroundAudioPlayer;
  bool _isBackgroundAudioReady = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayers();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only load practice data if it hasn't been loaded yet and we are not already loading
    if (_poses.isEmpty && _isLoading) {
      _loadPracticeData();
    }
  }

  Future<void> _initializeAudioPlayers() async {
    _tickAudioPlayer = AudioPlayer();
    _chimeAudioPlayer = AudioPlayer();
    _backgroundAudioPlayer = AudioPlayer();

    await _tickAudioPlayer.setSourceAsset('audio/tick.mp3');
    await _chimeAudioPlayer.setSourceAsset('audio/chime.mp3');
    await _backgroundAudioPlayer.setSourceUrl('https://fullheartyoga.oss-cn-beijing.aliyuncs.com/music/bg1.mp3');
    _backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);

    _backgroundAudioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed || state == PlayerState.playing) {
        _isBackgroundAudioReady = true;
        if (_isPlaying && _isMusicOn) {
          _backgroundAudioPlayer.resume(); // Ensure it plays if ready and supposed to
        }
      }
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMusicOn = prefs.getBool('isMusicOn') ?? false;
      _isSoundEffectsOn = prefs.getBool('isSoundEffectsOn') ?? true;
    });
  }

  Future<void> _loadPracticeData() async {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;

    setState(() {
      _isLoading = true;
    });

    final args = ModalRoute.of(context)!.settings.arguments;

    List<PracticePose> selectedPracticePoses = [];
    int calculatedTotalTime = 0;

    final String posesJson = await rootBundle.loadString('assets/data/poses_$languageCode.json');
    final List<dynamic> posesData = json.decode(posesJson);
    final List<Pose> allPoses = posesData.map<Pose>((dynamic item) => Pose.fromJson(item as Map<String, dynamic>)).toList();

    if (args is Sequence) {
      selectedPracticePoses = args.poses.map((sequencePose) {
        final fullPose = allPoses.firstWhere((pose) => pose.id == sequencePose.id);
        return PracticePose(
          pose: Pose(
            id: fullPose.id,
            name: fullPose.name,
            nameEn: fullPose.nameEn,
            nameSa: fullPose.nameSa,
            benefits: fullPose.benefits,
            description: fullPose.description,
            difficulty: fullPose.difficulty,
            akaChinese: fullPose.akaChinese,
            position: fullPose.position,
            type: fullPose.type,
          ),
          duration: sequencePose.time,
        );
      }).toList();
      calculatedTotalTime = selectedPracticePoses.fold(0, (sum, practicePose) => sum + practicePose.duration);
    } else if (args is Map<String, dynamic>) {
      // If quick practice parameters are passed
      final int difficulty = args['difficulty'] as int;
      final int durationIndex = args['duration'] as int;
      final int location = args['location'] as int;

      final List<int> durationMap = [15, 30, 45, 60]; // Minutes
      calculatedTotalTime = durationMap[durationIndex] * 60; // Convert to seconds

      final filteredPoses = _filterPoses(allPoses, difficulty, location);
      selectedPracticePoses = _selectPoses(filteredPoses, calculatedTotalTime);
    } else {
      // Handle error or default case if no valid arguments
      print('Invalid arguments for PracticeModeScreen: $args');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final initialPoseTime = selectedPracticePoses.isNotEmpty ? selectedPracticePoses[0].duration : 0;

    setState(() {
      _poses = selectedPracticePoses;
      _totalTime = calculatedTotalTime;
      _remainingTime = calculatedTotalTime;
      _currentPoseRemainingTime = initialPoseTime;
      _formattedCurrentPoseRemainingTime = formatTime(initialPoseTime);
      _isLoading = false;
    });

    if (_poses.isNotEmpty) {
      _startPractice();
    } else {
      // Handle case where no poses are selected/found
      _showModalDialog(
        title: localizations.noPosesAvailable,
        content: localizations.noPosesAvailableMessage,
        confirmText: localizations.goBack,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }

  List<Pose> _filterPoses(List<Pose> allPoses, int difficulty, int location) {
    // difficulty: 0=初级, 1=中级, 2=高级
    // location: 0=不限, 1=站立体式, 2=坐卧体式
    final List<int> difficultyMap = [0, 1, 2]; // Corresponds to Pose.difficulty
    final List<int> locationMap = [-1, 1, 2]; // -1 for '不限', 1 for '站立体式', 2 for '坐卧体式'

    return allPoses.where((pose) {
      final matchDifficulty = pose.difficulty == difficultyMap[difficulty];
      final matchLocation = locationMap[location] == -1 ||
          (locationMap[location] == 1 && pose.position == 1) || // Standing
          (locationMap[location] == 2 && [2, 3, 4, 5].contains(pose.position)); // Sitting/Lying

      return matchDifficulty && matchLocation;
    }).toList();
  }

  List<PracticePose> _selectPoses(List<Pose> filteredPoses, int totalTime) {
    const int maxPoses = 20;
    const int averagePoseTime = 60; // seconds
    int numPoses = min((totalTime / averagePoseTime).ceil(), maxPoses);

    final List<Pose> groundingPoses = filteredPoses.where((pose) => [2, 3, 4, 5].contains(pose.position)).toList();
    final List<Pose> activePoses = filteredPoses.where((pose) => [1, 6].contains(pose.position)).toList();

    List<Pose> sequence = [];
    Random random = Random();

    // Initial grounding poses (15% of total, max 3)
    int initialGroundingCount = min(min((numPoses * 0.15).floor(), 3), groundingPoses.length);
    for (int i = 0; i < initialGroundingCount; i++) {
      if (groundingPoses.isNotEmpty) {
        sequence.add(groundingPoses.removeAt(random.nextInt(groundingPoses.length)));
      }
    }

    // Active poses
    int activeCount = min(numPoses - sequence.length - min((numPoses * 0.15).floor(), 3), activePoses.length);
    for (int i = 0; i < activeCount; i++) {
      if (activePoses.isNotEmpty) {
        sequence.add(activePoses.removeAt(random.nextInt(activePoses.length)));
      }
    }

    // Final grounding poses
    int finalGroundingCount = min(min(numPoses - sequence.length, 3), groundingPoses.length);
    for (int i = 0; i < finalGroundingCount; i++) {
      if (groundingPoses.isNotEmpty) {
        sequence.add(groundingPoses.removeAt(random.nextInt(groundingPoses.length)));
      }
    }

    // Fill remaining spots with any available poses
    if (sequence.length < numPoses) {
      List<Pose> remainingPoses = [...groundingPoses, ...activePoses];
      remainingPoses.shuffle(random);
      while (sequence.length < numPoses && remainingPoses.isNotEmpty) {
        sequence.add(remainingPoses.removeLast());
      }
    }

    // Distribute time among selected poses
    final int totalPoses = sequence.length;
    if (totalPoses == 0) return [];

    int durationPerPose = (totalTime / totalPoses).floor();
    int remainingTimeForDistribution = totalTime;

    List<PracticePose> finalSequence = [];
    for (int i = 0; i < totalPoses; i++) {
      final bool isLastPose = i == totalPoses - 1;
      final int poseDuration = isLastPose ? remainingTimeForDistribution : durationPerPose;
      remainingTimeForDistribution -= poseDuration;
      finalSequence.add(PracticePose(
        pose: sequence[i],
        duration: poseDuration,
      ));
    }
    return finalSequence;
  }

  void _startPractice() {
    setState(() {
      _isPlaying = true;
    });
    if (_isMusicOn && _isBackgroundAudioReady) {
      _backgroundAudioPlayer.resume();
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying) {
        setState(() {
          _remainingTime--;
          _currentPoseRemainingTime--;
          _formattedCurrentPoseRemainingTime = formatTime(_currentPoseRemainingTime);
        });

        if (_isSoundEffectsOn && _currentPoseRemainingTime > 0 && _currentPoseRemainingTime <= 3) {
          _tickAudioPlayer.seek(Duration.zero); // Rewind to start
          _tickAudioPlayer.play(AssetSource('audio/tick.mp3'));
        }

        if (_remainingTime <= 0) {
          _finishPractice();
        }
        _updatePose();
      } else {
        setState(() {
          _restTime++;
          _formattedRestTime = formatTime(_restTime);
        });
      }
    });
  }

  void _updatePose() {
    if (_currentPoseRemainingTime <= 0) {
      final newIndex = _currentPoseIndex + 1;
      if (newIndex < _poses.length) {
        if (_isSoundEffectsOn) {
          _chimeAudioPlayer.seek(Duration.zero); // Rewind to start
          _chimeAudioPlayer.play(AssetSource('audio/chime.mp3'));
        }
        setState(() {
          _currentPoseIndex = newIndex;
          _currentPoseRemainingTime = _poses[newIndex].duration;
          _formattedCurrentPoseRemainingTime = formatTime(_currentPoseRemainingTime);
        });
      }
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      setState(() {
        _restTime = 0;
        _formattedRestTime = '00:00';
      });
      if (_isMusicOn) {
        _backgroundAudioPlayer.resume();
      }
    } else {
      if (_isMusicOn) {
        _backgroundAudioPlayer.pause();
      }
    }
  }

  void _goToPreviousPose() {
    if (_currentPoseIndex == 0) return;
    if (_isSoundEffectsOn) {
      _chimeAudioPlayer.seek(Duration.zero);
      _chimeAudioPlayer.play(AssetSource('audio/chime.mp3'));
    }
    final newIndex = _currentPoseIndex - 1;
    int newRemainingTotalTime = 0;
    for (int i = newIndex; i < _poses.length; i++) {
      newRemainingTotalTime += _poses[i].duration;
    }
    setState(() {
      _currentPoseIndex = newIndex;
      _currentPoseRemainingTime = _poses[newIndex].duration;
      _formattedCurrentPoseRemainingTime = formatTime(_currentPoseRemainingTime);
      _remainingTime = newRemainingTotalTime;
    });
  }

  void _goToNextPose() {
    if (_currentPoseIndex >= _poses.length - 1) return;
    if (_isSoundEffectsOn) {
      _chimeAudioPlayer.seek(Duration.zero);
      _chimeAudioPlayer.play(AssetSource('audio/chime.mp3'));
    }
    final newIndex = _currentPoseIndex + 1;
    int newRemainingTotalTime = 0;
    for (int i = newIndex; i < _poses.length; i++) {
      newRemainingTotalTime += _poses[i].duration;
    }
    setState(() {
      _currentPoseIndex = newIndex;
      _currentPoseRemainingTime = _poses[newIndex].duration;
      _formattedCurrentPoseRemainingTime = formatTime(_currentPoseRemainingTime);
      _remainingTime = newRemainingTotalTime;
    });
  }

  void _showExitModal() {
    final localizations = AppLocalizations.of(context)!;
    _showModalDialog(
      title: localizations.exitPractice,
      content: localizations.exitPracticeConfirmation,
      confirmText: localizations.confirm,
      cancelText: localizations.cancel,
      onConfirm: _exitPractice,
      onCancel: _hideModal,
    );
  }

  void _exitPractice() {
    _timer?.cancel();
    _backgroundAudioPlayer.stop();
    _hideModal();
    Navigator.pop(context); // Go back to the previous screen
  }

  void _finishPractice() {
    final localizations = AppLocalizations.of(context)!;
    _timer?.cancel();
    _backgroundAudioPlayer.stop();
    _showModalDialog(
      title: localizations.practiceComplete,
      content: localizations.practiceCompleteMessage,
      confirmText: localizations.backToHome,
      cancelText: localizations.exitPractice,
      onConfirm: _goHome,
      onCancel: _exitPractice,
    );
  }

  void _hideModal() {
    setState(() {
      _showModal = false;
    });
  }

  void _showModalDialog({
    required String title,
    required String content,
    required String confirmText,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
  }) {
    setState(() {
      _modalTitle = title;
      _modalContent = content;
      _modalConfirm = confirmText;
      _onConfirm = onConfirm;
      _modalCancel = cancelText ?? '';
      _onCancel = onCancel;
      _showModal = true;
    });
  }

  void _handleConfirm() {
    if (_onConfirm != null) {
      _onConfirm!();
    }
  }

  void _handleCancel() {
    if (_onCancel != null) {
      _onCancel!();
    }
  }

  void _goHome() {
    // Assuming the home screen is the root of the navigation stack
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _toggleMusic() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isMusicOn = !_isMusicOn;
    });
    await prefs.setBool('isMusicOn', _isMusicOn);
    if (_isMusicOn) {
      if (_isPlaying) {
        _backgroundAudioPlayer.resume();
      }
    } else {
      _backgroundAudioPlayer.pause();
    }
  }

  void _toggleSoundEffects() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundEffectsOn = !_isSoundEffectsOn;
    });
    await prefs.setBool('audio_settings_practice_sound_on', _isSoundEffectsOn);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tickAudioPlayer.dispose();
    _chimeAudioPlayer.dispose();
    _backgroundAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Helper for pose properties
    String getDifficultyText(int difficulty) {
      final difficultyMap = [
        localizations.beginner,
        localizations.intermediate,
        localizations.advanced
      ];
      return difficultyMap[difficulty];
    }

    List<String> getPoseTypes(String types) {
      return types.split(',').map((t) => t.trim()).toList();
    }

    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // Main content
                Column(
                  children: [
                    // Hero Section (Image and Toggle Buttons)
                    Expanded(
                      flex: 4, // Adjust flex to control image height
                      child: Container(
                        color: const Color(0xFFF7FAFA), // Background color from index.less
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                _poses[_currentPoseIndex].pose.detailimgurl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset('assets/placeholder.png', fit: BoxFit.contain); // Placeholder image
                                },
                              ),
                            ),
                            Positioned(
                              top: 40, // Adjust for status bar
                              left: 12,
                              child: GestureDetector(
                                onTap: _showExitModal,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.arrow_back, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40, // Adjust for status bar
                              right: 12,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _toggleMusic,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          _isMusicOn ? 'assets/icon_music.svg' : 'assets/icon_music_forbid.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _toggleSoundEffects,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          _isSoundEffectsOn ? 'assets/icon_soundeffects_on.svg' : 'assets/icon_soundeffects_off.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Title Block
                    Expanded(
                      flex: 2, // Adjust flex to control height
                      child: Container(
                        color: const Color(0xFFF7FAFA),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _poses[_currentPoseIndex].pose.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDE7CB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    getDifficultyText(_poses[_currentPoseIndex].pose.difficulty),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFA75522),
                                    ),
                                  ),
                                ),
                                ...getPoseTypes(_poses[_currentPoseIndex].pose.type).map((type) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFAF1D9),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        type,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFA75522),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Timer Wrap
                    Expanded(
                      flex: 2, // Adjust flex to control height
                      child: Container(
                        color: const Color(0xFFF7FAFA),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.remainingTimeTitle,
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formattedCurrentPoseRemainingTime,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Controls
                    Expanded(
                      flex: 2, // Adjust flex to control height
                      child: Container(
                        color: const Color(0xFFF7FAFA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildControlButton(
                              iconPath: 'assets/prev.svg',
                              onPressed: _goToPreviousPose,
                              isPrimary: false,
                              isRotated: false,
                            ),
                            const SizedBox(width: 24),
                            _buildControlButton(
                              iconPath: _isPlaying ? 'assets/pause.svg' : 'assets/play.svg',
                              onPressed: _togglePlayPause,
                              isPrimary: true,
                              isRotated: false,
                            ),
                            const SizedBox(width: 24),
                            _buildControlButton(
                              iconPath: 'assets/prev.svg',
                              onPressed: _goToNextPose,
                              isPrimary: false,
                              isRotated: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Exit Button (Optional, can be part of AppBar or a separate row)
                    
                  ],
                ),
                // Modal Dialog
                if (_showModal)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: _buildStyledDialog(),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildControlButton({
    required String iconPath,
    required VoidCallback onPressed,
    required bool isPrimary,
    required bool isRotated,
  }) {
    return SizedBox(
      width: isPrimary ? 64 : 52,
      height: isPrimary ? 64 : 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF52946B) : const Color(0xFFE8F2ED),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          elevation: isPrimary ? 4 : 0,
          shadowColor: isPrimary ? const Color(0x404F9B83) : Colors.transparent,
        ),
        child: Transform.rotate(
          angle: isRotated ? pi : 0, // Rotate 180 degrees for next button
          child: SvgPicture.asset(
            iconPath,
            width: isPrimary ? 26 : 21,
            height: isPrimary ? 26 : 21,
            colorFilter: ColorFilter.mode(isPrimary ? Colors.white : const Color(0xFF52946B), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _modalTitle,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _modalContent,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (_modalCancel.isNotEmpty)
                  Expanded(
                    child: TextButton(
                      onPressed: _handleCancel,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text(_modalCancel),
                    ),
                  ),
                if (_modalCancel.isNotEmpty)
                  const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF52946B), // primary color
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(_modalConfirm),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
