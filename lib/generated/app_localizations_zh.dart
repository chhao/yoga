// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get poses => '体式';

  @override
  String get practice => '练习';

  @override
  String get breath => '呼吸';

  @override
  String get sanskritName => '梵文名';

  @override
  String get benefits => '体式益处';

  @override
  String get steps => '练习步骤';

  @override
  String get searchPoses => '搜索体式...';

  @override
  String get allDifficulties => '所有难度';

  @override
  String get beginner => '初级';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get allTypes => '所有类型';

  @override
  String get standing => '站立';

  @override
  String get seated => '坐姿';

  @override
  String get supine => '仰卧';

  @override
  String get prone => '俯卧';

  @override
  String get kneeling => '跪姿';

  @override
  String get balancing => '平衡';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get settings => '设置';

  @override
  String get audioSetting => '音频设置';

  @override
  String get language => '语言';

  @override
  String get rateMe => '评价我们';

  @override
  String get suggestion => '提出建议';

  @override
  String get practiceCenter => '练习中心';

  @override
  String get practiceCenterSubtitle => '创建你的专属序列，或开始一个快速练习';

  @override
  String get mySavedSequences => '我保存的序列';

  @override
  String get noSavedSequences => '你还没有保存任何序列。';

  @override
  String get createNewSequence => '创建新序列';

  @override
  String get featuredSequences => '精选序列';

  @override
  String get quickPractice => '快速练习';

  @override
  String get quickPracticeSubtitle => '根据你的偏好，智能生成一个练习序列。';

  @override
  String get practiceDifficulty => '练习难度';

  @override
  String get practiceDuration => '练习时长';

  @override
  String get locationPreference => '场地偏好';

  @override
  String get startQuickPractice => '开始快速练习';

  @override
  String sequenceDeleted(String sequenceName) {
    return '序列 \"$sequenceName\" 已删除';
  }

  @override
  String posesCount(int count) {
    return '$count 个体式';
  }

  @override
  String totalDuration(String duration) {
    return '· $duration';
  }

  @override
  String minutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String minutesSeconds(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get duration15 => '15分钟';

  @override
  String get duration30 => '30分钟';

  @override
  String get duration45 => '45分钟';

  @override
  String get duration60 => '60分钟';

  @override
  String get locationAny => '不限';

  @override
  String get locationStanding => '站立体式';

  @override
  String get locationSeated => '坐卧体式';

  @override
  String get ready => '准备';

  @override
  String remainingTime(String time) {
    return '剩余 $time';
  }

  @override
  String get completed => '完成';

  @override
  String get wellDone => '做得好！';

  @override
  String get musicOn => '音乐开启';

  @override
  String get musicOff => '音乐关闭';

  @override
  String totalPracticeDuration(int duration) {
    return '总练习时长: $duration 分钟';
  }

  @override
  String stepDuration(String instruction, int duration) {
    return '$instruction: $duration 秒';
  }

  @override
  String get seconds => '秒';

  @override
  String get noPosesAvailable => '无可用体式';

  @override
  String get noPosesAvailableMessage => '根据您的选择，没有找到合适的体式。请尝试调整筛选条件。';

  @override
  String get goBack => '返回';

  @override
  String get exitPractice => '退出练习';

  @override
  String get exitPracticeConfirmation => '确定要退出练习吗？';

  @override
  String get practiceComplete => '练习完成';

  @override
  String get practiceCompleteMessage => '恭喜你，完成了本次练习！';

  @override
  String get backToHome => '返回首页';

  @override
  String get remainingTimeTitle => '剩余时间';

  @override
  String get all => '全部';

  @override
  String get unlimited => '不限';

  @override
  String get zeroMinutes => '0 分钟';

  @override
  String get enterSequenceName => '请输入序列名称';

  @override
  String get selectAtLeastOnePose => '请至少选择一个体式';

  @override
  String get sequenceNameExists => '序列名称已存在';

  @override
  String get sequenceSaved => '序列已保存';

  @override
  String get editSequence => '编辑序列';

  @override
  String get createNewSequenceTitle => '创建新序列';

  @override
  String get createYourOwnSequence => '创建你的专属瑜伽序列';

  @override
  String get allPoses => '所有体式';

  @override
  String get difficulty => '难度';

  @override
  String get poseType => '体式';

  @override
  String get currentSequence => '当前序列';

  @override
  String get nameYourSequence => '为你的序列取个名字';

  @override
  String durationInSeconds(int duration) {
    return '$duration 秒';
  }

  @override
  String get updateSequence => '更新序列';

  @override
  String get saveSequence => '保存序列';

  @override
  String get setDurationInSeconds => '设置时长 (秒)';

  @override
  String currentDuration(int duration) {
    return '当前时长: $duration 秒';
  }

  @override
  String get startPractice => '开始跟练';

  @override
  String get originAndBackground => '📚 起源与背景';

  @override
  String get none => '无';

  @override
  String get mainBenefits => '🌟 主要功效';

  @override
  String get practiceSteps => '🪷 练习步骤';

  @override
  String get tips => '💡 提示';

  @override
  String get cautions => '⚠️ 注意事项';

  @override
  String get suitableFor => '🎯 适合人群';

  @override
  String get recommendedWith => '👍 推荐搭配';
}
