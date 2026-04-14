# Toruru

마블 룰렛 방식의 내기 게임 앱. 직접 맵을 제작하고, 플레이어를 설정한 뒤 공을 굴려 결과를 정하는 물리 기반 게임입니다.

## 플랫폼

- Android
- iOS

## 주요 기능

- **맵 에디터** — 오브젝트를 배치해 나만의 맵 제작
- **맵 선택** — 저장된 맵 목록에서 불러오기
- **게임 설정** — 플레이어 수, 공 스킨 선택
- **물리 게임** — Flame + Forge2D 기반 공 굴리기 시뮬레이션
- **다국어 지원** — flutter_localization

## 기술 스택

| 항목 | 내용 |
|------|------|
| Framework | Flutter 3 |
| 상태 관리 | Riverpod |
| 물리 엔진 | Flame + flame_forge2d |
| 라우팅 | go_router |
| 저장소 | shared_preferences |
| 광고 | Google Mobile Ads |
| 분석 | Firebase Analytics |
| 푸시 알림 | Firebase Cloud Messaging |

## 시작하기

### 사전 준비

- Flutter SDK `^3.11.1`
- Firebase 프로젝트 설정 (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`)

### 설치 및 실행

```bash
flutter pub get
flutter run
```

### 빌드

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 프로젝트 구조

```
lib/
├── main.dart
├── router/          # go_router 라우팅
├── screens/
│   ├── editor/      # 맵 에디터
│   ├── game_select/ # 맵 선택
│   ├── game_settings/ # 게임 설정
│   └── settings/    # 앱 설정
├── models/          # 데이터 모델
├── components/      # Flame 컴포넌트
├── widgets/         # Flutter 위젯
└── common/          # 공통 유틸리티
```

## 환경 설정 (미포함 파일)

아래 파일은 보안상 저장소에 포함되지 않습니다. Firebase 콘솔에서 직접 발급받아 추가해야 합니다.

- `lib/firebase_options.dart` — FlutterFire CLI로 생성
- `android/app/google-services.json` — Firebase Android 설정
- `ios/Runner/GoogleService-Info.plist` — Firebase iOS 설정
