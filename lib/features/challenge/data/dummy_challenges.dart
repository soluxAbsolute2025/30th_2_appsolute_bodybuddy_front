import '../models/challenge_model.dart';

const List<Challenge> dummyPersonalChallenges = [
  Challenge(
    title: '30일 걷기 챌린지',
    description: '매일 10,000보 걷기',
    current: 15,
    total: 30,
    rewardXp: 500,
    dDay: 15,
  ),
  Challenge(
    title: '주간 운동 목표',
    description: '주 5회 30분 운동',
    current: 4,
    total: 5,
    rewardXp: 200,
    dDay: 15,
  ),
];

const List<Challenge> dummyGroupChallenges = [
  Challenge(
    title: '주간 운동 목표',
    description: '주 5회 30분 운동',
    current: 4,
    total: 5,
    rewardXp: 200,
    dDay: 15,
  ),
];
