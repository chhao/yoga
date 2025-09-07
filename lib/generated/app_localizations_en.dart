// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get poses => 'Poses';

  @override
  String get practice => 'Practice';

  @override
  String get breath => 'Breath';

  @override
  String get sanskritName => 'Sanskrit';

  @override
  String get benefits => 'Benefits';

  @override
  String get steps => 'Steps';

  @override
  String get searchPoses => 'Search Poses...';

  @override
  String get allDifficulties => 'All Difficulties';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get allTypes => 'All Types';

  @override
  String get unknown => 'Unknown';

  @override
  String get standing => 'Standing';

  @override
  String get seated => 'Seated';

  @override
  String get supine => 'Supine';

  @override
  String get prone => 'Prone';

  @override
  String get kneeling => 'Kneeling';

  @override
  String get balancing => 'Balancing';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get settings => 'Settings';

  @override
  String get audioSetting => 'Audio';

  @override
  String get language => 'Language';

  @override
  String get rateMe => 'Rate Me';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get practiceCenter => 'Practice Center';

  @override
  String get practiceCenterSubtitle =>
      'Create your own sequence or start a quick practice';

  @override
  String get mySavedSequences => 'My Sequences';

  @override
  String get noSavedSequences => 'You haven\'t saved any sequences yet.';

  @override
  String get createNewSequence => 'Create Sequence';

  @override
  String get featuredSequences => 'Featured Sequences';

  @override
  String get quickPractice => 'Quick Practice';

  @override
  String get quickPracticeSubtitle =>
      'Intelligently generate a practice sequence based on your preferences.';

  @override
  String get practiceDifficulty => 'Difficulty';

  @override
  String get practiceDuration => 'Duration';

  @override
  String get locationPreference => 'Location Preference';

  @override
  String get startQuickPractice => 'Start Quick Practice';

  @override
  String sequenceDeleted(String sequenceName) {
    return 'Sequence \"$sequenceName\" has been deleted';
  }

  @override
  String posesCount(int count) {
    return '$count Poses';
  }

  @override
  String totalDuration(String duration) {
    return '· $duration';
  }

  @override
  String minutes(int minutes) {
    return '$minutes min';
  }

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get duration15 => '15 minutes';

  @override
  String get duration30 => '30 minutes';

  @override
  String get duration45 => '45 minutes';

  @override
  String get duration60 => '60 minutes';

  @override
  String get locationAny => 'Any';

  @override
  String get locationStanding => 'Standing';

  @override
  String get locationSeated => 'Seated/Supine';

  @override
  String get ready => 'Ready';

  @override
  String remainingTime(String time) {
    return 'Remaining $time';
  }

  @override
  String get completed => 'Completed';

  @override
  String get wellDone => 'Well done!';

  @override
  String get musicOn => 'Music On';

  @override
  String get musicOff => 'Music Off';

  @override
  String totalPracticeDuration(int duration) {
    return 'Total Practice Duration: $duration minutes';
  }

  @override
  String stepDuration(String instruction, int duration) {
    return '$instruction: $duration seconds';
  }

  @override
  String get seconds => 'seconds';

  @override
  String get noPosesAvailable => 'No Poses Available';

  @override
  String get noPosesAvailableMessage =>
      'No suitable poses were found based on your selection. Please try adjusting the filter criteria.';

  @override
  String get goBack => 'Go Back';

  @override
  String get exitPractice => 'Exit Practice';

  @override
  String get exitPracticeConfirmation => 'Are you sure want to exit?';

  @override
  String get practiceComplete => 'Practice Complete';

  @override
  String get practiceCompleteMessage =>
      'Congratulations, you have completed this session!';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get remainingTimeTitle => 'Remaining Time';

  @override
  String get all => 'All';

  @override
  String get unlimited => 'Unlimited';

  @override
  String get zeroMinutes => '0 minutes';

  @override
  String get enterSequenceName => 'Please enter a sequence name';

  @override
  String get selectAtLeastOnePose => 'Please select at least one pose';

  @override
  String get sequenceNameExists => 'Sequence name already exists';

  @override
  String get sequenceSaved => 'Sequence saved';

  @override
  String get editSequence => 'Edit Sequence';

  @override
  String get createNewSequenceTitle => 'Create New Sequence';

  @override
  String get createYourOwnSequence => 'Create your own yoga sequence';

  @override
  String get allPoses => 'All Poses';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get poseType => 'Type';

  @override
  String get currentSequence => 'Sequence';

  @override
  String get nameYourSequence => 'Name your sequence';

  @override
  String durationInSeconds(int duration) {
    return '$duration seconds';
  }

  @override
  String get updateSequence => 'Update';

  @override
  String get saveSequence => 'Save';

  @override
  String get setDurationInSeconds => 'Set Duration (seconds)';

  @override
  String currentDuration(int duration) {
    return 'Current duration: $duration seconds';
  }

  @override
  String get startPractice => 'Start Practice';

  @override
  String get originAndBackground => '📚 Origins';

  @override
  String get none => 'None';

  @override
  String get mainBenefits => '🌟 Benefits';

  @override
  String get practiceSteps => '🪷 Steps';

  @override
  String get tips => '💡 Tips';

  @override
  String get cautions => '⚠️ Cautions';

  @override
  String get suitableFor => '🎯 Suitable For';

  @override
  String get recommendedWith => '👍 Recommended';
}
