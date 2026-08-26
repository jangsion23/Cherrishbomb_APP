import 'package:flutter/material.dart';

import '../models/log_entry.dart';
import '../theme/app_colors.dart';
import '../utils/date_format.dart';
import 'status_badge.dart';

/// 활동 로그 한 건을 와이어프레임 행으로 표시.
/// 좌: 시각(HH:mm)·날짜(MM-DD) / 중: 제목·상세 / 우: 상태 배지.
/// 라벨·색은 백엔드 logType + status 기준.
class LogTile extends StatelessWidget {
  final LogEntry log;
  const LogTile(this.log, {super.key});

  @override
  Widget build(BuildContext context) {
    final d = log.detectedAt;
    final detail = _detail(log);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d == null ? '--:--' : hm(d),
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  Text(d == null ? '' : md(d), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 34,
              color: AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title(log),
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  if (detail != null) ...[
                    const SizedBox(height: 2),
                    Text(detail, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ],
              ),
            ),
            StatusBadge(label: _statusLabel(log.status), color: _statusColor(log.status)),
          ],
        ),
      ),
    );
  }

  String _title(LogEntry log) {
    switch (log.logType) {
      case LogTypes.fallEvent:
        return '낙상 감지';
      case LogTypes.sensorFailure:
        return '센서 고장';
      case LogTypes.emergencyCall:
        return '119 연결';
      default:
        return '이벤트';
    }
  }

  String? _detail(LogEntry log) {
    if (log.logType == LogTypes.sensorFailure && log.sensorDetail != null && log.sensorDetail!.isNotEmpty) {
      return '${log.sensorDetail} 센서';
    }
    return null;
  }

  Color _statusColor(String status) {
    switch (status) {
      case MemberStatuses.danger:
        return AppColors.danger;
      case MemberStatuses.warning:
        return AppColors.warning;
      default:
        return AppColors.safe;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case MemberStatuses.danger:
        return 'DANGER';
      case MemberStatuses.warning:
        return 'WARNING';
      case MemberStatuses.safe:
        return 'SAFE';
      default:
        return status;
    }
  }
}
