import '../models/app_notification.dart';
import '../models/log_entry.dart';
import '../models/ward_contact.dart';
import '../models/ward_health.dart';
import '../models/ward_sensor.dart';
import '../models/ward_summary.dart';

/// 디자인 확인용 미리보기 목데이터. WardService.mock=true 일 때만 사용.
/// TODO: 커밋 전 WardService.mock=false 로 바꾸면 이 클래스는 안 쓰인다.
class MockData {
  MockData._();

  static DateTime _ago(Duration d) => DateTime.now().subtract(d);
  static String _iso(Duration d) => _ago(d).toIso8601String();

  static WardSummary summary() => WardSummary(
    wardName: '김영희',
    relationship: '어머니',
    phone: '01012345678',
    status: 'SAFE',
    totalActivityMinutes: 390, // 6.5시간
    lastActivityMinutes: 10,
    deviceOnline: true,
    deviceLastSeen: _iso(const Duration(minutes: 2)),
  );

  static WardSensor sensor() => WardSensor(
    status: 'SAFE',
    vibrator: true,
    radar: true,
    thermal: true,
    deviceOnline: true,
    deviceLastSeen: _iso(const Duration(minutes: 2)),
    batteryPct: 92,
    rssi: -52,
  );

  static List<WardContact> contacts() => [
    WardContact(contactId: 1, name: '홍길동', phone: '01012345678', relationship: '아들', priority: 1),
    WardContact(contactId: 2, name: '이영희', phone: '01023456789', relationship: '딸', priority: 2),
    WardContact(contactId: 3, name: '박철수', phone: '01034567890', relationship: '담당 복지사', priority: 3),
  ];

  static LogPage logs() => LogPage(
    page: 0,
    totalPages: 3,
    last: false,
    content: [
      LogEntry(
        id: 1,
        detectedAt: _ago(const Duration(hours: 2)),
        status: 'DANGER',
        logType: 'FALL_EVENT',
        sensorDetail: null,
      ),
      LogEntry(
        id: 2,
        detectedAt: _ago(const Duration(hours: 5)),
        status: 'DANGER',
        logType: 'EMERGENCY_CALL',
        sensorDetail: null,
      ),
      LogEntry(
        id: 3,
        detectedAt: _ago(const Duration(hours: 8)),
        status: 'WARNING',
        logType: 'SENSOR_FAILURE',
        sensorDetail: 'radar',
      ),
      LogEntry(
        id: 4,
        detectedAt: _ago(const Duration(days: 1)),
        status: 'WARNING',
        logType: 'FALL_EVENT',
        sensorDetail: null,
      ),
      LogEntry(
        id: 5,
        detectedAt: _ago(const Duration(days: 1, hours: 3)),
        status: 'SAFE',
        logType: 'FALL_EVENT',
        sensorDetail: null,
      ),
    ],
  );

  static WardHealth health() => WardHealth(
    disease: '고혈압, 당뇨',
    medication: '메트포르민, 암로디핀',
    memo: '2024년 낙상 이력 있음. 왼쪽 고관절 수술.',
    updatedByName: '홍길동',
    updatedAt: _iso(const Duration(days: 3)),
  );

  // 읽음 처리가 미리보기에서도 반영되도록 상태를 캐시로 들고 있는다.
  static List<AppNotification>? _notis;

  static List<AppNotification> _initNotis() => [
    AppNotification(
      id: 1,
      notificationType: NotiTypes.fall,
      memberId: 1,
      memberName: '김영희',
      logId: 1,
      isRead: false,
      createdAt: _ago(const Duration(minutes: 8)),
    ),
    AppNotification(
      id: 2,
      notificationType: NotiTypes.warning,
      memberId: 1,
      memberName: '김영희',
      logId: 2,
      isRead: false,
      createdAt: _ago(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 3,
      notificationType: NotiTypes.deviceOffline,
      memberId: 1,
      memberName: '김영희',
      logId: null,
      isRead: false,
      createdAt: _ago(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 4,
      notificationType: NotiTypes.emergency,
      memberId: 1,
      memberName: '김영희',
      logId: 3,
      isRead: true,
      createdAt: _ago(const Duration(days: 1)),
    ),
  ];

  static NotiPage notifications() {
    final list = _notis ??= _initNotis();
    final unread = list.where((n) => !n.isRead).length;
    return NotiPage(unreadCount: unread, page: 0, totalPages: 1, last: true, content: List.of(list));
  }

  static void markRead(int id) {
    final list = _notis ??= _initNotis();
    _notis = list.map((n) => n.id == id ? _asRead(n) : n).toList();
  }

  static void markAllRead() {
    final list = _notis ??= _initNotis();
    _notis = list.map(_asRead).toList();
  }

  static AppNotification _asRead(AppNotification n) => AppNotification(
    id: n.id,
    notificationType: n.notificationType,
    memberId: n.memberId,
    memberName: n.memberName,
    logId: n.logId,
    isRead: true,
    createdAt: n.createdAt,
  );
}
