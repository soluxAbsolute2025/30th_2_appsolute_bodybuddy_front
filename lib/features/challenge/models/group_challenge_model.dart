import 'group_member_model.dart';

class GroupChallenge {
  final String title;
  final int rank;
  final int remainDays;
  final bool isRecruiting;
  final List<GroupMember> members;
  final String? imageUrl;

  const GroupChallenge({
    required this.title,
    required this.rank,
    required this.remainDays,
    required this.isRecruiting,
    required this.members,
    this.imageUrl,
  });

  int get memberCount => members.length;
}
