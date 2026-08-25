import 'package:flutter/material.dart';
import '../screens/notifications_page.dart';
import '../services/ward_service.dart';
import '../theme/app_colors.dart';

/// 메인 탭 공통 상단 헤더. 와이어프레임의 "보호자 모드 + 벨(배지) + 아바타".
/// 탭마다 동일하게 얹어 고정된 것처럼 보이게 한다.
/// 미읽음 개수는 헤더가 스스로 조회해 어느 탭에서든 배지가 뜬다.
class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  const AppHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  int _unread = 0;

  @override
  void initState() {
    super.initState();
    _loadUnread();
  }

  Future<void> _loadUnread() async {
    try {
      final n = await WardService.getNotifications(size: 1);
      if (mounted) setState(() => _unread = n.unreadCount);
    } catch (_) {
      // 배지는 부가 정보라 실패 시 조용히 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('보호자 모드'),
      // 본문(회색)과 헤더를 구분하는 옅은 하단 경계선
      shape: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      actions: [
        IconButton(
          tooltip: '알림함',
          icon: Badge(
            isLabelVisible: _unread > 0,
            label: Text('$_unread'),
            child: const Icon(Icons.notifications_none),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsPage()),
          ).then((_) => _loadUnread()),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
