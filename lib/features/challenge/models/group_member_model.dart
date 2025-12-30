class GroupMember {
  final String id;
  final String profileImageUrl;
  final bool isMe;

  const GroupMember({
    required this.id,
    required this.profileImageUrl,
    this.isMe = false,
  });
}
