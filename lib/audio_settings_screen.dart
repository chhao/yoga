import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoga/generated/app_localizations.dart';

class AudioSettingsScreen extends StatefulWidget {
  static const routeName = '/audio-settings';

  const AudioSettingsScreen({super.key});

  @override
  State<AudioSettingsScreen> createState() => _AudioSettingsScreenState();
}

class _AudioSettingsScreenState extends State<AudioSettingsScreen> {
  bool _practiceMusicOn = true;
  bool _practiceSoundOn = true;
  bool _breathSoundOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _practiceMusicOn = prefs.getBool('audio_settings_practice_music_on') ?? true;
      _practiceSoundOn = prefs.getBool('audio_settings_practice_sound_on') ?? true;
      _breathSoundOn = prefs.getBool('audio_settings_breath_sound_on') ?? true;
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.audioSetting),
        backgroundColor: const Color(0xFFF7FAFA),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            title: Text(localizations.practice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: Text(localizations.practiceMusicTitle),
            subtitle: Text(localizations.practiceMusicSubtitle),
            value: _practiceMusicOn,
            activeColor: const Color(0xFF52946B),
            inactiveTrackColor: const Color(0xFFE8F2ED),
            onChanged: (bool value) {
              setState(() {
                _practiceMusicOn = value;
              });
              _updateSetting('audio_settings_practice_music_on', value);
            },
          ),
          SwitchListTile(
            title: Text(localizations.practiceSoundEffectsTitle),
            subtitle: Text(localizations.practiceSoundEffectsSubtitle),
            value: _practiceSoundOn,
            activeColor: const Color(0xFF52946B),
            inactiveTrackColor: const Color(0xFFE8F2ED),
            onChanged: (bool value) {
              setState(() {
                _practiceSoundOn = value;
              });
              _updateSetting('audio_settings_practice_sound_on', value);
            },
          ),
          const Divider(height: 32),
          ListTile(
            title: Text(localizations.breathPracticeTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            title: Text(localizations.breathSoundEffectsTitle),
            subtitle: Text(localizations.breathSoundEffectsSubtitle),
            value: _breathSoundOn,
            activeColor: const Color(0xFF52946B),
            inactiveTrackColor: const Color(0xFFE8F2ED),
            onChanged: (bool value) {
              setState(() {
                _breathSoundOn = value;
              });
              _updateSetting('audio_settings_breath_sound_on', value);
            },
          ),
        ],
      ),
    );
  }
}
