import '../models/ongoing_group_challenge.dart';
import '../models/group_member_model.dart';

extension TopParticipantMapper on TopParticipant {
  GroupMember toGroupMember() {
    return GroupMember(
      id: 'rank_$rank', // userId 없어서 임시
      profileImageUrl: profileImageUrl ?? '',
      isMe: isMe,
      rank: rank,
    );
  }
}
