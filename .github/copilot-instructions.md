# Cherrishbomb_APP — Copilot 지침

독거노인 낙상감지 시스템의 **보호자(가족) 앱**. 사용자는 노인 본인이 아니라 가족이며, **연령대가 높을 수 있다.**
반드시 한국어로 코드리뷰를 작성한다.

## 스택

Flutter · Dart SDK ^3.12.2 · go_router · flutter_lints

## 구조

```
lib/
├── config/    설정 상수
├── core/      app_router.dart 등 앱 전역
├── models/    API 응답 모델
├── screens/   화면
├── services/  API 호출 (api_client.dart + 도메인별 service)
├── utils/     입력 포매터 등 순수 함수
└── widgets/   재사용 위젯
```

- API 호출은 반드시 `services/`를 거친다. 화면에서 HTTP를 직접 부르지 않는다.
- 라우팅이 **이중 구조**다 — 최상위는 `go_router`(`/login`, `/home`), 탭 내부는 `MainShell`의 탭별 `Navigator`. 탭 안에서 상세를 열 때는 `Navigator.push`를 쓴다(하단 탭이 유지된다).

## 도메인 용어

`ward` = 피보호자(돌봄 대상 노인). 서버 엔티티명은 `Member`, 기관 웹에서는 `target`이다. **앱에서는 `ward`로 통일한다.**

`User`는 보호자(앱 사용자)를 뜻한다. 노인이 아니다.

## 반드시 지킬 규칙

### 1. 사용자가 입력한 값을 버리지 않는다

폼에 필드를 두면 **반드시 서버로 보내거나, 아예 묻지 않는다.** 입력받고 버리는 것보다 안 묻는 게 정직하다. 서버가 아직 못 받는 필드는 화면에서 뺀다.

### 2. 없는 데이터를 지어내지 않는다

서버가 안 주는 값을 그럴듯한 상수로 채우지 않는다(`배터리 92%` 같은 것). 값이 없으면 `'—'`로 둔다.

### 3. 타깃 사용자를 고려한 입력 처리

- **전화번호를 `010`으로만 제한하지 않는다.** 피보호자는 집전화(`02-`, `031-`)를 쓰는 경우가 흔하다.
- 하이픈·콜론은 `inputFormatters`로 **자동 입력**한다. 사용자가 직접 치게 하지 않는다.
- 필드 검증은 `RegTextField`(`required` / `pattern` / `extraCheck`)로 통일한다. 화면마다 `validator`를 복붙하지 않는다.

### 4. 낙상 알림은 놓치면 안 된다

- 홈에 머물러 있어도 새 알림이 반영돼야 한다. 진입 시 1회 조회만으로는 부족하다.
- 알림을 누르면 해당 대상 상세로 이동해야 한다. 읽기 전용 목록으로 끝내지 않는다.
- 배지 숫자 하나를 위해 목록 20건을 받지 않는다.

### 5. 실패 메시지는 원인을 알려준다

`'등록에 실패했습니다'`만으로는 MAC 중복인지 네트워크 오류인지 모른다. **서버 응답의 `message`를 노출**한다.

### 6. 목록을 새로고침하면 첫 페이지로 간다

`RefreshIndicator`가 현재 페이지를 다시 부르면, 최신 데이터가 1페이지 맨 위에 쌓여도 보이지 않는다.

### 7. 개인정보를 로컬에 남기지 않는다

`print` 대신 `debugPrint`를 쓴다(릴리즈 빌드 로그에 남지 않게). 토큰 외의 개인정보를 기기에 저장하지 않는다.

## 서버 계약

- 응답 모델은 `models/`에 두고 **서버 DTO와 필드명을 정확히 맞춘다.** 손으로 맞추는 구조라 웹에서 필드명 드리프트가 세 번 났다.
- 서버가 `@JsonProperty("isRead")`로 고정한 키는 앱도 `isRead`로 읽는다.
- 시각 필드는 `DateTime?` + `DateTime.tryParse`로 파싱한다. `String?`으로 들고 있지 않는다.
- 건강정보 수정은 `PUT`(전체 교체)이다. **폼 로딩에 실패한 상태로 저장하면 기존 값이 지워진다** — 저장 전에 로딩 성공 여부를 확인한다.

## 코드 스타일

- `dart format --line-length 120`. `analysis_options.yaml`의 `page_width`와 같은 값이다.
- `flutter analyze --fatal-infos`를 통과해야 한다.
- `const` 생성자를 적극적으로 쓴다.
- `StatefulWidget`에서 `TextEditingController`·`StreamSubscription`은 **반드시 `dispose()`에서 정리**한다.
- `await` 뒤에 `context`를 쓸 때는 `if (!mounted) return;`을 먼저 확인한다.
- **주석은 "왜"를 쓰고 한국어로 쓴다.**
  ```dart
  // 배터리·신호는 백엔드 미제공 → 임시 표시
  ```

## 커밋 · PR

- 커밋: `feat:` `fix:` `refactor:` `chore:` `style:` + 한국어 요약
- **PR은 파일 10개 / 300줄 이내.**

## 하지 말 것

- 자격증명을 커밋하지 않는다 — `.env`, `google-services.json`, `GoogleService-Info.plist`, `*.jks/keystore`, `key.properties`.
- 서버가 필수로 요구할 수 있는 필드에 빈 문자열(`''`)을 보내지 않는다. 값이 없으면 `null`을 보내고, 서버와 처리 방식을 먼저 합의한다.
- 라우팅을 바꿀 때 `test/widget_test.dart`(첫 화면 스모크 테스트)를 방치하지 않는다.
