import 'package:flutter/foundation.dart';

import 'ward_service.dart';

/// 안읽음 알림 개수를 앱 전역에서 공유하는 저장소.
/// - 모든 탭의 헤더가 이 값을 구독하므로, 어느 탭에서 읽든 배지가 동시에 갱신된다.
/// - 조회는 최초 1회만(ensureLoaded) 하고, 이후 탭 이동에서는 서버를 다시 안 부른다.
class NotificationStore {
  NotificationStore._();

  /// 현재 안읽음 개수. 헤더는 ValueListenableBuilder로 이 값을 구독한다.
  static final ValueNotifier<int> unread = ValueNotifier<int>(0);

  // 최초 1회 로드 여부. 탭마다 헤더가 새로 생겨도 중복 조회를 막는다.
  static bool _loaded = false;

  /// 서버가 준 최신 안읽음 개수로 덮어쓴다. (음수는 0으로)
  static void set(int count) {
    unread.value = count < 0 ? 0 : count;
    _loaded = true;
  }

  /// 아직 한 번도 안 불렀으면 그때만 서버에서 개수를 받아온다.
  /// 헤더가 화면마다 호출해도 실제 네트워크는 최초 1회뿐이다.
  static Future<void> ensureLoaded() async {
    if (_loaded) return;
    await refresh();
  }

  /// 강제로 최신 개수를 다시 받아온다. (알림함 다녀온 뒤 등)
  static Future<void> refresh() async {
    try {
      final n = await WardService.getNotifications(size: 1);
      set(n.unreadCount);
    } catch (_) {
      // 배지는 부가 정보라 실패 시 조용히 무시
    }
  }

  /// 로그아웃 등 사용자 전환 시 초기화.
  static void reset() {
    _loaded = false;
    unread.value = 0;
  }
}
