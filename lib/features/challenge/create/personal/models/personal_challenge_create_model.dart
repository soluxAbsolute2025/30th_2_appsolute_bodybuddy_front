import 'package:image_picker/image_picker.dart';

class PersonalChallengeCreateModel {
  String title = '';
  String description = '';
  String goalType = 'PERIOD'; // PERIOD | COUNT
  int? targetDays;
  int? dailyGoal;
  String unit = '';
  String category = 'DAILY';  // DAILY | WEEKLY 등
  String? visibility;         // ✅ PUBLIC | PRIVATE
  int? estimatedReward;
  XFile? imageFile;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'goalType': goalType,
      'targetDays': targetDays,
      'dailyGoal': dailyGoal,
      'unit': unit,
      'category': category,
      'visibility': visibility,     // ✅ 변경
      'estimatedReward': estimatedReward,
    };
  }
}

