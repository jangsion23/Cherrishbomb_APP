import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 상태(SAFE/WARNING/DANGER) → 색·배경·라벨·아이콘 매핑.
class StatusStyle {
  final Color color;
  final Color bg;
  final String label;
  final IconData icon;
  const StatusStyle(this.color, this.bg, this.label, this.icon);

  static StatusStyle of(String status) {
    switch (status) {
      case 'DANGER':
        return const StatusStyle(AppColors.danger, AppColors.dangerBg, '위험', Icons.warning_rounded);
      case 'WARNING':
        return const StatusStyle(AppColors.warning, AppColors.warningBg, '주의', Icons.error_outline);
      default:
        return const StatusStyle(AppColors.safe, AppColors.safeBg, '안전', Icons.check_circle);
    }
  }
}

/// 119 긴급 연결 카드 (빨강).
class EmergencyCallCard extends StatelessWidget {
  final VoidCallback onCall;
  const EmergencyCallCard({super.key, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '119 긴급 연결',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.danger),
                ),
                SizedBox(height: 4),
                Text('버튼 클릭 이력이 기록됩니다', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onCall,
            icon: const Icon(Icons.call, size: 18),
            label: const Text('전화 걸기'),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// 활동 시간 / 마지막 활동 두 박스.
class ActivityStatsRow extends StatelessWidget {
  final int totalMinutes;
  final int lastMinutes;
  const ActivityStatsRow({super.key, required this.totalMinutes, required this.lastMinutes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _box(Icons.schedule, _hours(totalMinutes), '활동 시간')),
        const SizedBox(width: 12),
        Expanded(child: _box(Icons.directions_walk, _ago(lastMinutes), '마지막 활동')),
      ],
    );
  }

  Widget _box(IconData icon, String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  String _hours(int m) => m <= 0 ? '0분' : (m >= 60 ? '${(m / 60).toStringAsFixed(1)}시간' : '$m분');
  String _ago(int m) => m <= 0 ? '방금' : (m >= 60 ? '${m ~/ 60}시간 전' : '$m분 전');
}

/// 오늘의 활동 타임라인. (백엔드 미제공 → 샘플 막대)
class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    const heights = [0.3, 0.5, 0.4, 0.7, 0.6, 0.9, 0.5, 0.8, 0.6, 0.7];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '오늘의 활동 타임라인',
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final h in heights)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          height: 80 * h,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('09:00', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                Text('12:00', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                Text('현재', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
