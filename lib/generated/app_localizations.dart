import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @poses.
  ///
  /// In en, this message translates to:
  /// **'Poses'**
  String get poses;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @breath.
  ///
  /// In en, this message translates to:
  /// **'Breath'**
  String get breath;

  /// No description provided for @sanskritName.
  ///
  /// In en, this message translates to:
  /// **'Sanskrit Name'**
  String get sanskritName;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @searchPoses.
  ///
  /// In en, this message translates to:
  /// **'Search Poses...'**
  String get searchPoses;

  /// No description provided for @allDifficulties.
  ///
  /// In en, this message translates to:
  /// **'All Difficulties'**
  String get allDifficulties;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @standing.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get standing;

  /// No description provided for @seated.
  ///
  /// In en, this message translates to:
  /// **'Seated'**
  String get seated;

  /// No description provided for @supine.
  ///
  /// In en, this message translates to:
  /// **'Supine'**
  String get supine;

  /// No description provided for @prone.
  ///
  /// In en, this message translates to:
  /// **'Prone'**
  String get prone;

  /// No description provided for @kneeling.
  ///
  /// In en, this message translates to:
  /// **'Kneeling'**
  String get kneeling;

  /// No description provided for @balancing.
  ///
  /// In en, this message translates to:
  /// **'Balancing'**
  String get balancing;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get chinese;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @audioSetting.
  ///
  /// In en, this message translates to:
  /// **'Audio Setting'**
  String get audioSetting;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @rateMe.
  ///
  /// In en, this message translates to:
  /// **'Rate Me'**
  String get rateMe;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

  /// No description provided for @practiceCenter.
  ///
  /// In en, this message translates to:
  /// **'Practice Center'**
  String get practiceCenter;

  /// No description provided for @practiceCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your own sequence or start a quick practice'**
  String get practiceCenterSubtitle;

  /// No description provided for @mySavedSequences.
  ///
  /// In en, this message translates to:
  /// **'My Sequences'**
  String get mySavedSequences;

  /// No description provided for @noSavedSequences.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any sequences yet.'**
  String get noSavedSequences;

  /// No description provided for @createNewSequence.
  ///
  /// In en, this message translates to:
  /// **'Create Sequence'**
  String get createNewSequence;

  /// No description provided for @featuredSequences.
  ///
  /// In en, this message translates to:
  /// **'Featured Sequences'**
  String get featuredSequences;

  /// No description provided for @quickPractice.
  ///
  /// In en, this message translates to:
  /// **'Quick Practice'**
  String get quickPractice;

  /// No description provided for @quickPracticeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Intelligently generate a practice sequence based on your preferences.'**
  String get quickPracticeSubtitle;

  /// No description provided for @practiceDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get practiceDifficulty;

  /// No description provided for @practiceDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get practiceDuration;

  /// No description provided for @locationPreference.
  ///
  /// In en, this message translates to:
  /// **'Location Preference'**
  String get locationPreference;

  /// No description provided for @startQuickPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Quick Practice'**
  String get startQuickPractice;

  /// No description provided for @sequenceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Sequence \"{sequenceName}\" has been deleted'**
  String sequenceDeleted(String sequenceName);

  /// No description provided for @posesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Poses'**
  String posesCount(int count);

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'· {duration}'**
  String totalDuration(String duration);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutes(int minutes);

  /// No description provided for @minutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String minutesSeconds(int minutes, int seconds);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @duration15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get duration15;

  /// No description provided for @duration30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get duration30;

  /// No description provided for @duration45.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get duration45;

  /// No description provided for @duration60.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get duration60;

  /// No description provided for @locationAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get locationAny;

  /// No description provided for @locationStanding.
  ///
  /// In en, this message translates to:
  /// **'Standing'**
  String get locationStanding;

  /// No description provided for @locationSeated.
  ///
  /// In en, this message translates to:
  /// **'Seated/Supine'**
  String get locationSeated;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @remainingTime.
  ///
  /// In en, this message translates to:
  /// **'Remaining {time}'**
  String remainingTime(String time);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @wellDone.
  ///
  /// In en, this message translates to:
  /// **'Well done!'**
  String get wellDone;

  /// No description provided for @musicOn.
  ///
  /// In en, this message translates to:
  /// **'Music On'**
  String get musicOn;

  /// No description provided for @musicOff.
  ///
  /// In en, this message translates to:
  /// **'Music Off'**
  String get musicOff;

  /// No description provided for @totalPracticeDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Practice Duration: {duration} minutes'**
  String totalPracticeDuration(int duration);

  /// No description provided for @stepDuration.
  ///
  /// In en, this message translates to:
  /// **'{instruction}: {duration} seconds'**
  String stepDuration(String instruction, int duration);

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @noPosesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Poses Available'**
  String get noPosesAvailable;

  /// No description provided for @noPosesAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'No suitable poses were found based on your selection. Please try adjusting the filter criteria.'**
  String get noPosesAvailableMessage;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @exitPractice.
  ///
  /// In en, this message translates to:
  /// **'Exit Practice'**
  String get exitPractice;

  /// No description provided for @exitPracticeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to exit?'**
  String get exitPracticeConfirmation;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice Complete'**
  String get practiceComplete;

  /// No description provided for @practiceCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you have completed this session!'**
  String get practiceCompleteMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @remainingTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get remainingTimeTitle;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimited;

  /// No description provided for @zeroMinutes.
  ///
  /// In en, this message translates to:
  /// **'0 minutes'**
  String get zeroMinutes;

  /// No description provided for @enterSequenceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a sequence name'**
  String get enterSequenceName;

  /// No description provided for @selectAtLeastOnePose.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one pose'**
  String get selectAtLeastOnePose;

  /// No description provided for @sequenceNameExists.
  ///
  /// In en, this message translates to:
  /// **'Sequence name already exists'**
  String get sequenceNameExists;

  /// No description provided for @sequenceSaved.
  ///
  /// In en, this message translates to:
  /// **'Sequence saved'**
  String get sequenceSaved;

  /// No description provided for @editSequence.
  ///
  /// In en, this message translates to:
  /// **'Edit Sequence'**
  String get editSequence;

  /// No description provided for @createNewSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Sequence'**
  String get createNewSequenceTitle;

  /// No description provided for @createYourOwnSequence.
  ///
  /// In en, this message translates to:
  /// **'Create your own yoga sequence'**
  String get createYourOwnSequence;

  /// No description provided for @allPoses.
  ///
  /// In en, this message translates to:
  /// **'All Poses'**
  String get allPoses;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @poseType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get poseType;

  /// No description provided for @currentSequence.
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get currentSequence;

  /// No description provided for @nameYourSequence.
  ///
  /// In en, this message translates to:
  /// **'Name your sequence'**
  String get nameYourSequence;

  /// No description provided for @durationInSeconds.
  ///
  /// In en, this message translates to:
  /// **'{duration} seconds'**
  String durationInSeconds(int duration);

  /// No description provided for @updateSequence.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateSequence;

  /// No description provided for @saveSequence.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveSequence;

  /// No description provided for @setDurationInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Set Duration (seconds)'**
  String get setDurationInSeconds;

  /// No description provided for @currentDuration.
  ///
  /// In en, this message translates to:
  /// **'Current duration: {duration} seconds'**
  String currentDuration(int duration);

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// No description provided for @originAndBackground.
  ///
  /// In en, this message translates to:
  /// **'📚 Origins'**
  String get originAndBackground;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @mainBenefits.
  ///
  /// In en, this message translates to:
  /// **'🌟 Benefits'**
  String get mainBenefits;

  /// No description provided for @practiceSteps.
  ///
  /// In en, this message translates to:
  /// **'🪷 Steps'**
  String get practiceSteps;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'💡 Tips'**
  String get tips;

  /// No description provided for @cautions.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Cautions'**
  String get cautions;

  /// No description provided for @suitableFor.
  ///
  /// In en, this message translates to:
  /// **'🎯 Suitable For'**
  String get suitableFor;

  /// No description provided for @recommendedWith.
  ///
  /// In en, this message translates to:
  /// **'👍 Recommended'**
  String get recommendedWith;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
