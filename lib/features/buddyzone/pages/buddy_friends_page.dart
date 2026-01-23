import 'package:bodybuddy_frontend/features/buddyzone/api/buddyzone_friends_api.dart';
import 'package:flutter/material.dart';
import '../widgets/friends/friends_request_section.dart';
import '../widgets/friends/my_friends_section.dart';

class BuddyFriendPage extends StatefulWidget {
  const BuddyFriendPage({super.key});

  @override
  State<BuddyFriendPage> createState() => _BuddyFriendPageState();
}

class _BuddyFriendPageState extends State<BuddyFriendPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getBuddyList() async {
    await BuddysApi().getBuddyList();
  }

  void _getBuddyDetail() async {
    print('데이터 로딩 시작...');

    try {
      // 1. 0부터 50까지의 요청 리스트 생성
      final requests = List.generate(
        51,
        (i) => BuddysApi().getBuddyDetail(userId: i),
      );

      // 2. 모든 요청을 동시에 실행하고 전체가 끝날 때까지 대기
      final results = await Future.wait(requests);

      // 3. 결과 확인 (results는 각 API 응답의 리스트가 됩니다)
      print('${results.length}개의 데이터 수신 완료!');

      // 만약 화면에 반영하고 싶다면?
      // setState(() { _details = results; });
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextButton(
          onPressed: () {
            _getBuddyList();
          },
          child: Text('테스트 확인'),
        ),
        TextButton(
          onPressed: () {
            _getBuddyDetail();
          },
          child: Text('테스트 확인'),
        ),
        MyFriendsSection(),
        SizedBox(height: 10.0),
        FriendRequestSection(),
      ],
    );
  }
}
