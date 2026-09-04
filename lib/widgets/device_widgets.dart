import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 온라인 상태 카드 (점 + 온라인/오프라인 + 마지막 신호).
class DeviceOnlineCard extends StatelessWidget {
  final bool online;
  final String lastSeen;
  const DeviceOnlineCard({super.key, required this.online, required this.lastSeen});

  @override
  Widget build(BuildContext context) {
    final color = online ? AppColors.safe : AppColors.textSecondary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: color),
                const SizedBox(width: 8),
                Text(
                  online ? '온라인' : '오프라인',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('마지막 신호: $lastSeen', style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// 통계 박스 (배터리·신호 등). 큰 값 + 라벨.
class DeviceStatBox extends StatelessWidget {
  final String value;
  final String label;
  const DeviceStatBox({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

/// 센서 3종 상태 카드. null=미확인 / true=정상 / false=이상.
class DeviceSensorCard extends StatelessWidget {
  final bool? vibrator;
  final bool? radar;
  final bool? thermal;
  const DeviceSensorCard({super.key, this.vibrator, this.radar, this.thermal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '센서 상태',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            _row('진동 센서', vibrator),
            const SizedBox(height: 8),
            _row('레이더 센서', radar),
            const SizedBox(height: 8),
            _row('열화상 센서', thermal),
          ],
        ),
      ),
    );
  }

  Widget _row(String name, bool? ok) {
    final Color color;
    final String label;
    if (ok == null) {
      color = AppColors.textSecondary;
      label = '미확인';
    } else if (ok) {
      color = AppColors.safe;
      label = '정상';
    } else {
      color = AppColors.danger;
      label = '이상';
    }
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name, style: const TextStyle(color: AppColors.textPrimary)),
        ),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
