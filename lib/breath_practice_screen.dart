import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breath_method.dart';
import 'dart:convert';

class BreathPracticeScreen extends StatefulWidget {
  final BreathMethod breathMethod;

  const BreathPracticeScreen({super.key, required this.breathMethod});

  @override
  State<BreathPracticeScreen> createState() => _BreathPracticeScreenState();
}

class _BreathPracticeScreenState extends State<BreathPracticeScreen> {
  late BreathMethod _currentMode;
  bool _isPlaying = false;
  int _currentStep = 0;
  int _totalDuration = 180; // seconds
  int _elapsedTime = 0;
  int _durationMinutes = 3; // minutes
  bool _isSettingsVisible = false;
  bool _isSoundOn = true;

  String _instructionText = '准备';
  double _instructionOpacity = 1.0;
  double _circleSize = 96.0;
  int _transitionDuration = 1;
  Color _circleColor = const Color.fromRGBO(52, 211, 153, 0.9);
  Color _glowStyleColor = const Color.fromRGBO(22, 163, 74, 0.2);

  String _sessionTimerDisplay = '剩余 0:00';

  Timer? _intervalTimer;
  Timer? _sessionTimer;

  late AudioPlayer _inhalePlayer;
  late AudioPlayer _holdPlayer;
  late AudioPlayer _exhalePlayer;

  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _currentMode = widget.breathMethod;
    _initializePlayers();
    _loadUserSettings();
    _initialize();
  }

  Future<void> _initializePlayers() async {
    _inhalePlayer = AudioPlayer();
    _holdPlayer = AudioPlayer();
    _exhalePlayer = AudioPlayer();
  }

  Future<void> _loadUserSettings() async {
    _prefs = await SharedPreferences.getInstance();
    final String? userConfigsJson = _prefs!.getString('user_breath_configs');
    if (userConfigsJson != null) {
      // This part needs careful handling as BreathMethod.fromJson expects a map,
      // and we are storing a map of maps.
      // For now, let's assume we only store duration and rhythm overrides.
      // A more robust solution would involve a dedicated settings model.
      final Map<String, dynamic> userConfigs = Map<String, dynamic>.from(
        json.decode(userConfigsJson),
      );
      final Map<String, dynamic>? userConfig = userConfigs[_currentMode.id];

      if (userConfig != null) {
        if (userConfig.containsKey('duration')) {
          _durationMinutes = userConfig['duration'];
        }
        if (userConfig.containsKey('rhythm')) {
          final List<dynamic> savedRhythm = userConfig['rhythm'];
          for (
            int i = 0;
            i < _currentMode.rhythm.length && i < savedRhythm.length;
            i++
          ) {
            _currentMode.rhythm[i].duration = savedRhythm[i]['duration'];
          }
        }
      }
    }
    setState(() {}); // Update UI after loading settings
  }

  Future<void> _saveUserSettings() async {
    if (_prefs == null) return;

    final String? userConfigsJson = _prefs!.getString('user_breath_configs');
    final Map<String, dynamic> userConfigs = userConfigsJson != null
        ? Map<String, dynamic>.from(json.decode(userConfigsJson))
        : {};

    userConfigs[_currentMode.id] = {
      'duration': _durationMinutes,
      'rhythm': _currentMode.rhythm
          .map((r) => {'instruction': r.instruction, 'duration': r.duration})
          .toList(),
    };

    await _prefs!.setString('user_breath_configs', json.encode(userConfigs));
  }

  void _initialize() {
    _totalDuration = _durationMinutes * 60;
    _updateTimerDisplay();
    _resetToInitial();
  }

  void _updateUIForStep() {
    final step = _currentMode.rhythm[_currentStep];

    setState(() {
      _transitionDuration = step.duration;
      _instructionText = step.instruction;
      _instructionOpacity = 1.0;
      _circleSize = step.size.toDouble();
      _circleColor = _parseColor(step.color);
      _glowStyleColor = _parseColor(step.glow);
    });

    if (_isSoundOn) {
      if (step.instruction.contains('吸')) {
        _inhalePlayer.play(AssetSource('audio/chime.mp3'));
      } else if (step.instruction.contains('屏息')) {
        _holdPlayer.play(AssetSource('audio/tick.mp3'));
      } else if (step.instruction.contains('呼')) {
        _exhalePlayer.play(AssetSource('audio/bowl.mp3'));
      }
    }

    Future.delayed(Duration(seconds: step.duration - 1), () {
      if (_isPlaying) {
        setState(() {
          _instructionOpacity = 0.0;
        });
      }
    });
  }

  Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      final buffer = StringBuffer();
      if (colorString.length == 6 || colorString.length == 7) buffer.write('ff');
      buffer.write(colorString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else if (colorString.startsWith('rgba')) {
      final parts = colorString
          .substring(5, colorString.length - 1)
          .split(',')
          .map((s) => double.parse(s.trim()))
          .toList();
      return Color.fromRGBO(
        parts[0].toInt(),
        parts[1].toInt(),
        parts[2].toInt(),
        parts[3],
      );
    }
    return Colors.transparent; // Default or error color
  }

  void _breathCycle() {
    if (!_isPlaying) return;

    _updateUIForStep();

    final duration = _currentMode.rhythm[_currentStep].duration;

    _intervalTimer = Timer(Duration(seconds: duration), () {
      setState(() {
        _currentStep = (_currentStep + 1) % _currentMode.rhythm.length;
      });
      _breathCycle();
    });
  }

  void _updateTimer() {
    setState(() {
      _elapsedTime++;
    });

    final remainingTime = _totalDuration - _elapsedTime;
    if (remainingTime <= 0) {
      _stopSession();
      setState(() {
        _sessionTimerDisplay = "完成";
        _instructionText = "做得好！";
        _instructionOpacity = 1.0;
      });
      return;
    }
    _updateTimerDisplay(remainingTime);
  }

  void _updateTimerDisplay([int? time]) {
    final displayTime = time ?? _totalDuration;
    final minutes = (displayTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (displayTime % 60).toString().padLeft(2, '0');
    setState(() {
      _sessionTimerDisplay = '剩余 $minutes:$seconds';
    });
  }

  void _startSession() {
    setState(() {
      _isPlaying = true;
      _elapsedTime = 0;
      _currentStep = 0;
    });
    _updateTimerDisplay();
    _breathCycle();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
    // Vibration is not directly supported in Flutter for web/desktop,
    // and requires platform-specific implementation for mobile.
    // For now, we'll omit it or add a placeholder.
  }

  void _stopSession() {
    setState(() {
      _isPlaying = false;
    });
    _intervalTimer?.cancel();
    _sessionTimer?.cancel();
    _intervalTimer = null;
    _sessionTimer = null;
  }

  void _resetToInitial() {
    _stopSession();
    final lastStep = _currentMode.rhythm[_currentMode.rhythm.length - 1];

    setState(() {
      _currentStep = 0;
      _elapsedTime = 0;
      _transitionDuration = 1;
      _circleSize = lastStep.size.toDouble();
      _circleColor = _parseColor(lastStep.color);
      _glowStyleColor = _parseColor(lastStep.glow);
      _instructionText = '准备';
      _instructionOpacity = 1.0;
    });
    _updateTimerDisplay();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _stopSession();
    } else {
      _startSession();
    }
  }

  void _openSettings() {
    setState(() {
      _isSettingsVisible = true;
    });
  }

  void _closeSettings() {
    setState(() {
      _isSettingsVisible = false;
    });
    _saveUserSettings();
    if (!_isPlaying) {
      _initialize();
    }
  }

  void _onDurationChange(double value) {
    setState(() {
      _durationMinutes = value.toInt();
    });
    if (!_isPlaying) {
      setState(() {
        _totalDuration = _durationMinutes * 60;
      });
      _updateTimerDisplay();
    }
  }

  void _onRhythmDurationChange(double value, int index) {
    setState(() {
      _currentMode.rhythm[index].duration = value.toInt();
    });
  }

  void _toggleSound() {
    setState(() {
      _isSoundOn = !_isSoundOn;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSoundOn ? '音乐开启' : '音乐关闭'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _exitPractice() {
    _stopSession();
    Navigator.of(context).pop(); // Go back to the previous screen
  }

  @override
  void dispose() {
    _stopSession();
    _inhalePlayer.dispose();
    _holdPlayer.dispose();
    _exhalePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFA), // @bg-color
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF9CA3AF),
                      ), // @text-color-light
                      onPressed: _exitPractice,
                    ),
                  ),
                  Text(
                    _currentMode.name.zh,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF6B7280), // @text-color-medium
                    ),
                  ),
                ],
              ),
            ),
            // Main Visual Area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow Circle
                      Container(
                        width: 256,
                        height: 256,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              _glowStyleColor.withOpacity(0.5), // Start with a more transparent color
                              _glowStyleColor.withOpacity(0), // Fade to fully transparent
                            ],
                            stops: const [0.2, 1.0],
                          ),
                        ),
                      ),
                      // Breathing Circle
                      AnimatedContainer(
                        duration: Duration(seconds: _transitionDuration),
                        width: _circleSize,
                        height: _circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _circleColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 25,
                              spreadRadius: -5,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 10,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), // Adjust spacing
                  AnimatedOpacity(
                    opacity: _instructionOpacity,
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      _instructionText,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: Color(0xFF1F2937), // @text-color-dark
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    _sessionTimerDisplay,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF6B7280), // @text-color-medium
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          _isSoundOn
                              ? 'assets/icon_music.svg'
                              : 'assets/icon_music_forbid.svg',
                          width: 36,
                          height: 36,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF9CA3AF),
                            BlendMode.srcIn,
                          ), // @text-color-light
                        ),
                        onPressed: _toggleSound,
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF52946B), // @brand-green
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 10),
                              blurRadius: 15,
                              spreadRadius: -3,
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 4),
                              blurRadius: 6,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            _isPlaying ? 'assets/pause.svg' : 'assets/play.svg',
                            width: 26,
                            height: 26,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/icon_settings.svg',
                          width: 36,
                          height: 36,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF9CA3AF),
                            BlendMode.srcIn,
                          ), // @text-color-light
                        ),
                        onPressed: _openSettings,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _isSettingsVisible
          ? Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -10),
                    blurRadius: 25,
                    spreadRadius: -5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        '设置',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937), // @text-color-dark
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFF9CA3AF),
                          ),
                          onPressed: _closeSettings,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Total Duration Setting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '总练习时长: $_durationMinutes 分钟',
                        style: const TextStyle(
                          color: Color(0xFF6B7280), // @text-color-medium
                        ),
                      ),
                      Slider(
                        value: _durationMinutes.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        onChanged: _onDurationChange,
                        activeColor: const Color(0xFF52946B),
                        inactiveColor: const Color(0xFFF1F5F9),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Dynamic Rhythm Settings
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _currentMode.rhythm.length,
                    itemBuilder: (context, index) {
                      final step = _currentMode.rhythm[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${step.instruction}: ${step.duration} 秒',
                              style: const TextStyle(
                                color: Color(0xFF6B7280), // @text-color-medium
                              ),
                            ),
                            Slider(
                              value: step.duration.toDouble(),
                              min: 1,
                              max: 15,
                              divisions: 14,
                              onChanged: (value) =>
                                  _onRhythmDurationChange(value, index),
                              activeColor: const Color(0xFF52946B),
                              inactiveColor: const Color(0xFFF1F5F9),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
