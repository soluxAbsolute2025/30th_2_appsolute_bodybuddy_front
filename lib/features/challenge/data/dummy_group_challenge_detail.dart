import '../models/group_challenge_detail_model.dart';

final dummyGroupChallengeDetail = GroupChallengeDetail(
  title: '친구들과 다이어트',
  imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
  startDate: DateTime(2025, 11, 27),
  endDate: DateTime(2025, 12, 15),
  isPublic: true,
  description: '연말 전까지 몸무게 -3kg',
  currentParticipants: 4,
  maxParticipants: 8, 
  groupCode: 'DIET2025',
  ranks: const [
    ChallengeRank(
      rank: 1,
      name: '김친구',
      progress: 100,
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    ),
    ChallengeRank(
      rank: 2,
      name: '홍길동',
      progress: 80,
      profileImageUrl: null,
    ),
    ChallengeRank(
      rank: 3,
      name: '박동기',
      progress: 75,
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    ),
    ChallengeRank(
      rank: 4,
      name: '눈송이',
      progress: 30,
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    ),
    ChallengeRank(
      rank: 16,
      name: '나',
      progress: 3,
      isMe: true,
      profileImageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    ),
  ],
);
