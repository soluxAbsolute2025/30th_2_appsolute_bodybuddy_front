import '../models/completed_group_challenge_model.dart';

const List<CompletedGroupChallenge> dummyCompletedGroupChallenges = [
  CompletedGroupChallenge(
    title: '함께 만보 걷기',
    description: '30일간 매일 10,000보',
    imageUrl: '',
    totalMembers: 8,
    currentMembers: 7,
    isSuccess: true,
  ),
  CompletedGroupChallenge(
    title: '주 5회 운동 챌린지',
    description: '4주 동안 주 5회 30분 운동',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    totalMembers: 6,
    currentMembers: 6,
    isSuccess: true,
  ),
  CompletedGroupChallenge(
    title: '물 2L 마시기',
    description: '21일간 하루 2L 마시기',
    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
    totalMembers: 10,
    currentMembers: 9,
    isSuccess: false,
  ),
];
