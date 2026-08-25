import 'package:flutter/material.dart';

/// 와이어프레임 기준 공통 색상 팔레트.
/// 화면에서 색을 하드코딩하지 말고 여기 값을 참조한다.
class AppColors {
  AppColors._();

  // 브랜드 (파란 버튼·활성 탭·선택 토글)
  static const Color primary = Color(0xFF3B5BF6);
  static const Color primaryPressed = Color(0xFF2E49C9);

  // 배경·표면
  static const Color background = Color(0xFFF4F5F7); // 스캐폴드 배경(밝은 회색)
  static const Color surface = Colors.white; // 카드
  static const Color border = Color(0xFFE6E8EC); // 카드·필드 테두리
  static const Color fieldFill = Color(0xFFF7F8FA); // 입력창 배경

  // 텍스트
  static const Color textPrimary = Color(0xFF1F2430); // 제목·본문(진한 남색)
  static const Color textSecondary = Color(0xFF8A93A6); // 보조 설명(회색)

  // 상태색 — 배경(Bg)은 카드/배지 옅은 톤
  static const Color safe = Color(0xFF2FB344);
  static const Color safeBg = Color(0xFFE9F9EE);
  static const Color warning = Color(0xFFF5A623);
  static const Color warningBg = Color(0xFFFFF7E6);
  static const Color danger = Color(0xFFE5484D);
  static const Color dangerBg = Color(0xFFFDECEC);
  static const Color device = Color(0xFF5B6472);
  static const Color deviceBg = Color(0xFFEEF0F3);
}
