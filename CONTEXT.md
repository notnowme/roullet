# 또르르 — Roll it Roulette! (Flutter + Flame + Forge2D)

## 전체적인 지시사항
현재 폴더 구조를 최대한 유지하면서 진행하길 바람.
미해결 과제를 해결하길 바람.
개선 사항을 이해하면서 진행하고 싶음.
그러므로 파일을 작성하여 주는 게 아닌 실시간으로 대화하면서 한 단계 혹은 두 단계씩 진행하길 원함.
하지만 따로 파일을 작성해 달라고 요청할 경우에는 이 요청을 우선하길 바람.
_buildWidget() 등 쓰는 걸 최대한 자제하고 class 위젯으로 생성하기.
part, part of 등을 써도 됨.

## 프로젝트 개요
Flutter + Flame(1.36.0) + Forge2D(0.19.2+5) 로 만든 마블 룰렛 게임.
상태 관리는 Riverpod(3.x)임. StateProvider는 legacy이므로 사용하지 않음.
공이 핀과 장애물을 통과해 골에 도착하는 형태.

## 구현 완료된 기능

### Riverpod 상태 관리
- ProviderScope 단일 사용
- autoDispose 기본 사용
- GameOptionModel은 순수 데이터만 보유 (names, condition)
  - cameraMode는 별도 cameraModeProvider로 관리
  - mapType 제거 — selectedMapProvider로 MapData 직접 관리
- 이름 입력: NamesInputNotifier + namesInputProvider (String)
  - parsedNamesProvider: 파생 provider로 파싱된 이름 리스트 제공
- 리셋 로직: resetAll(WidgetRef ref) 함수로 통합 관리
- 맵 선택: selectedMapProvider로 선택된 MapData 관리
- 리더보드: ValueNotifier 유지 (게임 루프 60fps 데이터, Riverpod 부적합)

### 물리
- Forge2DGame 기반, zoom은 화면 너비 및 기기 타입 기준 동적 계산 (calcZoom)
- worldWidth = size.x / zoom
- worldHeight = rawHeight.clamp(worldWidth * 20, worldWidth * 40) — 폴드/태블릿 최소 높이 보장
- 중력: Vector2(0, 25)
- 공: restitution 0.6, density 0.3, friction 0.05
- 최대 속력: 25.0, 멈춤 방지: stuckTimer 2.5초
- bullet: true (CCD) 활성화
- 교착 상태 대책: 30초마다 impulse, 120초 강제 종료

### 맵 시스템 (데이터 기반)
- MapData + MapObject 모델, 좌표 0~1 비율, JSON 직렬화
- MapBuilder: MapData → Forge2D 컴포넌트 변환
- 기본 4종 맵: 지옥의 깔때기, 핀볼 카오스, 용암 동굴, 롤러코스터
- 커스텀 맵: SharedPreferences(AppStorage 싱글톤) 기반 저장/불러오기
- 맵 미리보기: _MiniMapPainter로 카드형 미리보기 (상위 40% 표시)

### 오브젝트 종류 (MapObjectType)
기본: peg, pegZone, plank, wall, mapLine
장애물: circleBumper, triangle, rotatingObject, movingObject, breakableWall, flipper
특수: bouncePad, accelField, decelField, wormhole, elasticRope

### 골 & 당첨
- 골 Y좌표: worldHeight - 3.0 (_goalY 상수)
- 가로 전체 너비
- WinCondition.first / WinCondition.last
- y좌표 직접 체크 (Slot sensor 대신)
- 골 직전 슬로모션 (3% 구간)

### 카메라
- 4종 모드: followLast, followFirst, followBattle, editor
- 거리 기반 속도 조절
- 모드 전환 시 공 위치로 즉시 점프
- onGameResize 시에도 공 위치로 즉시 이동 (리더보드 토글 카메라 고정 방지)
- 추적 중인 공 이름/색상 노출 → _TrackingOverlay로 표시
- 공통 카메라 이벤트 감지 (_updateCameraEvents): 모든 카메라 모드에서 동작
  - 골 인접 감지: 골까지 전체 높이 5% 이내 공 → 4초간 포커스 (🏁 표시), 이미 추적 중인 공이 골 인접이면 가로채지 않음
  - 텔레포트 감지: 프레임 간 5.0 이상 이동한 공 → 3.5초간 포커스 (⚡ 표시)
  - 우선순위: 골 인접 > 텔레포트 > 일반 추적
- followBattle 격전지 모드 개선: 밀집 구간이 없으면 (maxCount ≤ 1) 승리 조건에 따라 추적 (first→가장 아래, last→가장 위)

### 맵 에디터
- EditorScreen: 툴바(_EditorToolbar), 가이드(_EditorGuide), 캔버스, 속성패널, 팔레트
- EditorCanvas: InteractiveViewer 기반, 스크롤/이동 모드 토글(_CanvasToolRow), 줌 리셋
- 캔버스 높이 비율: 게임과 동일한 공식 (aspectRatio * 25).clamp(20, 40) 적용
- 오브젝트 크기: 게임과 동일 비율 (clamp 제거), ElasticRope 두께/앵커도 월드 단위 비례
- ObjectPalette: 탭 기반 (기본/장애물/특수)
- PropertyPanel: 타입별 슬라이더, 복제/삭제/닫기, 최대 높이 260
  - Flipper: isLeft 토글 (왼쪽/오른쪽 방향 전환) — _ToggleRow 위젯
  - MapLine: 점 개별 X/Y 편집 슬라이더 + 점 추가/삭제 버튼 — _MapLinePointActions 위젯
- 복제: ry 오프셋 0.001 (세로가 가로 대비 20~40배이므로 작은 비율)
- 다단계 배치: 웜홀(입구→출구), 맵라인(점→완료), 페그존(시작→끝), 로프(시작→끝)
- 배치 시 고스트 미리보기 + 좌표 표시
- 배치 후 자동 선택 안 함 (핀치줌 충돌 방지)
- 그리드 외곽선 강조 (L자 모서리 + "맵 범위" 라벨)
- JSON 내보내기/가져오기

### 비주얼 이펙트
- 파티클: collision, goalCelebration, destruction, bounce, warp
- 공 유리구슬 렌더링 (RadialGradient + MaskFilter.blur 글로우)
- 혜성 트레일 (위치 히스토리 + 점점 굵어지는 선)
- 카운트다운 3,2,1,GO! 연출
- 골 직전 슬로모션

### UI/디자인
- AppColor: 다크 네온 컬러 팔레트
- AppUI: glassCard, neonButton, neonToggle, neonOutline, inputDecoration
- GlassCard: BackdropFilter 글래스모피즘
- 맵 카드: 글래스모피즘 + 네온 테두리 글로우 + 미니맵 미리보기 + ShaderMask 페이드
- PopupAnimation mixin: bgFade, cardSlide, cardScale, contentFade, emojiPop
- 위너 오버레이: 팝업 애니메이션 (아래→위 바운스 + 이모지 팝)
- Pretendard 폰트 전역 적용

### 라우팅
- go_router: splash → home → mapList → editor
- NoTransitionPage 사용
- 다이얼로그는 Navigator.pop 유지 (go_router 밖)

### 스플래시
- 로고 페이드인 + 공 바운스(bounceOut+squash) + 텍스트 슬라이드업

### 저장소
- AppStorage 싱글톤 (SharedPreferences 래핑)
- MapStorage: AppStorage 기반 동기 접근

## 파일 구조
```
lib/
├── main.dart
├── common/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── enums.dart          # WinCondition, CameraMode, DeviceType
│   │   └── themes.dart         # AppUI
│   ├── router/
│   │   └── app_router.dart
│   ├── utils/
│   │   └── app_storage.dart    # AppStorage 싱글톤
│   └── widgets/
│       ├── glass_card.dart
│       └── responsive_widget.dart
├── components/
│   ├── balls.dart
│   ├── lines.dart
│   ├── objects.dart            # 장애물 전체 (Flipper, ElasticRope 포함)
│   ├── particles.dart
│   ├── pegs.dart
│   ├── slots.dart
│   └── walls.dart
├── data/
│   └── default_maps.dart       # 기본 4종 맵
├── mixins/
│   ├── animations.dart         # PopupAnimation mixin
│   └── rollit_game_mixin.dart
├── models/
│   ├── game_option_model.dart  # GameOptionModel (names, condition)
│   ├── map_builder.dart
│   ├── map_data.dart
│   └── map_storage.dart        # MapStorage (AppStorage 기반)
├── screens/
│   ├── home_screen.dart
│   ├── rollit_game.dart
│   ├── splash_screen.dart
│   ├── editor/
│   │   ├── editor_screen.dart  # + _EditorToolbar, _EditorGuide
│   │   ├── editor_canvas.dart  # + _CanvasToolRow, _DragHandle, _CanvasPainter
│   │   ├── object_palette.dart
│   │   ├── property_panel.dart
│   │   └── map_list_screen.dart # + _MapListHeader, _EmptyMapList, _MapListCard
│   ├── providers/
│   │   ├── editor_provider.dart
│   │   └── rollit_provider.dart
│   └── widgets/
│       ├── control_panel.dart
│       ├── empty_state.dart
│       ├── game_area.dart
│       ├── header.dart
│       ├── leaderboard.dart
│       ├── map_selector.dart
│       ├── track_overlay.dart
│       └── winner_overlay.dart
```

## Riverpod Provider 목록
| Provider | 타입 | 역할 |
|----------|------|------|
| namesInputProvider | Notifier<String> | 이름 입력 문자열 |
| parsedNamesProvider | Provider<List<String>> | 파싱된 이름 리스트 (파생) |
| gameOptionProvider | Notifier<GameOptionModel> | 게임 옵션 (이름, 조건) |
| rollitGameProvider | Notifier<RollitGame?> | 게임 인스턴스 |
| winnerProvider | Notifier<String?> | 당첨자 |
| cameraModeProvider | Notifier<CameraMode> | 카메라 모드 |
| showLeaderboardProvider | Notifier<bool> | 리더보드 표시 여부 |
| leaderboardAtTopProvider | Notifier<bool> | 리더보드 위치 |
| selectedMapProvider | Notifier<MapData> | 선택된 맵 데이터 |
| editorProvider | Notifier<EditorState> | 에디터 상태 |

## 설계 결정 기록
- 리더보드는 ValueNotifier 유지 (60fps 게임 루프 vs Riverpod 빌드 사이클 충돌)
- StateProvider 미사용 (Riverpod 3.x legacy)
- autoDispose 기본
- MapType enum 제거 — selectedMapProvider로 MapData 직접 관리
- 골 감지: Slot sensor 대신 y좌표 직접 체크 (_goalY 상수)
- _build 메서드 → 클래스 위젯으로 분리