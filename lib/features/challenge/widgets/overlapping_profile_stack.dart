import 'package:flutter/material.dart';
import '../models/group_member_model.dart';

const double _size = 30;
const double _overlap = 20;

class OverlappingProfileStack extends StatelessWidget {
  final List<GroupMember> members;
  final int maxVisible;

  const OverlappingProfileStack({
    super.key,
    required this.members,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleMembers = members.take(maxVisible).toList();
    final visibleCount = visibleMembers.length;
    final extraCount = members.length - visibleMembers.length;

    return SizedBox(
      height: _size,
      width: (visibleCount - 1) * _overlap +
          _size +
          (extraCount > 0 ? _overlap : 0),
      child: Stack(
        children: [
          for (int i = 0; i < visibleCount; i++)
            Positioned(
              left: i * _overlap,
              child: _ProfileCircle(
                imageUrl: visibleMembers[i].profileImageUrl,
              ),
            ),

          if (extraCount > 0)
            Positioned(
              left: visibleCount * _overlap,
              top: (_size - 24) / 2, 
              child: _PlusCircle(count: extraCount),
            ),
        ],
      ),
    );
  }
}

class _ProfileCircle extends StatelessWidget {
  final String imageUrl;

  const _ProfileCircle({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFD8D8D8),
        border: Border.all(color: Colors.white, width: 1),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PlusCircle extends StatelessWidget {
  final int count;

  const _PlusCircle({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE9FFF9),
      ),
      child: Text(
        '+$count',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF18D9A2),
          height: 1.0,
        ),
      ),
    );
  }
}
