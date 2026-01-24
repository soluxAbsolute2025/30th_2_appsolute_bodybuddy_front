import 'package:bodybuddy_frontend/common/widgets/sub_appbar.dart';
import 'package:flutter/material.dart';

class MypageBedgePage extends StatefulWidget {
  const MypageBedgePage({super.key});

  @override
  State<MypageBedgePage> createState() => _MypageBedgePageState();
}

class _MypageBedgePageState extends State<MypageBedgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: SubAppbar(titleText: '뱃지 컬렉션'));
  }
}
