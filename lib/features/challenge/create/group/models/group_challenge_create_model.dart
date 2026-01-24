import 'package:image_picker/image_picker.dart';

class GroupChallengeCreateModel {
  String title;
  String description;
  int? period;
  int maxParticipants;
  String visibility; // "PUBLIC" | "SECRET"

  XFile? imageFile; 

  GroupChallengeCreateModel({
    this.title = '',
    this.description = '',
    this.period,
    this.maxParticipants = 2,
    this.visibility = 'PUBLIC',
    this.imageFile,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "period": period,
        "maxParticipants": maxParticipants,
        "visibility": visibility,
      };
}
