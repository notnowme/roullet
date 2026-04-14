// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '또르르';

  @override
  String get appSubtitle => 'Roll it roullet!';

  @override
  String get homeDesc01 => '이름을 입력하세요!';

  @override
  String get homeDesc02 => '쉼표로 구분해서 2명 이상이면 시작할 수 있어요';

  @override
  String get start => '시작';

  @override
  String get condition => '승리 조건';

  @override
  String get winCondition01 => '1등만';

  @override
  String get winCondition02 => '꼴등만';

  @override
  String get winCondition03 => '1등부터';

  @override
  String get winCondition04 => '꼴등부터';

  @override
  String winCondition03Desc(int n) {
    return '$n명까지';
  }

  @override
  String winCondition04Desc(int n) {
    return '$n명까지';
  }

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get defaultPlayers => '고양이,강아지,햄스터,물고기';

  @override
  String get error2minPlayers => '이름은 2명 이상 입력해야 해요';

  @override
  String get firstWarning => '꼴등이 이기는 걸로 할까요?';

  @override
  String get lastWarning => '1등이 이기는 걸로 할까요?';

  @override
  String get settings => '설정';

  @override
  String get gameSettings => '게임 설정';

  @override
  String get physicsSettings => '물리 효과 설정';

  @override
  String get policy => '약관 및 정책';

  @override
  String get servicePolicy => '서비스 이용약관';

  @override
  String get physics => '물리';

  @override
  String get gravity => '중력';

  @override
  String get ballSize => '공 크기';

  @override
  String get maxSpeed => '최대 속도';

  @override
  String get effects => '연출';

  @override
  String get trail => '공 트레일';

  @override
  String get slowMotion => '골 직전 슬로모션';

  @override
  String get countdown => '카운트다운';

  @override
  String get ballSkins => '공 스킨 - 각 공마다 물리 특성이 달라요!';

  @override
  String get marble => '마블';

  @override
  String get marbleDesc => '기본 구슬 스타일';

  @override
  String get solar => '태양계';

  @override
  String get solarDesc => '태양계 행성들';

  @override
  String get sports => '스포츠';

  @override
  String get sportsDesc => '각종 구기종목';

  @override
  String get pixel => '8비트 픽셀';

  @override
  String get pixelDesc => '레트로 픽셀 공';

  @override
  String get slime => '슬라임';

  @override
  String get slimeDesc => '젤리처럼 가벼운 공';

  @override
  String get fruits => '과일';

  @override
  String get fruitsDesc => '알록달록 각종 과일들';

  @override
  String get optionsBack => '옵션 초기화';

  @override
  String get adReward => '광로로 해제';

  @override
  String get policyAlert => '약관 페이지로 이동할까요?';

  @override
  String get warning => '이런...!';

  @override
  String get error => '에러!';

  @override
  String get winnerCountError => '참가자 수보다 당첨자 수가 적어야 해요';

  @override
  String get mercury => '수성';

  @override
  String get venus => '금성';

  @override
  String get earth => '지구';

  @override
  String get mars => '화성';

  @override
  String get jupiter => '목성';

  @override
  String get saturn => '토성';

  @override
  String get uranus => '천왕성';

  @override
  String get neptune => '해왕성';

  @override
  String get apple => '사과';

  @override
  String get pear => '배';

  @override
  String get pineapple => '파인애플';

  @override
  String get orange => '오렌지';

  @override
  String get lemon => '레몬';

  @override
  String get kiwi => '키위';

  @override
  String get strawberry => '딸기';

  @override
  String get coconut => '코코넛';

  @override
  String get durian => '두리안';

  @override
  String get banana => '바나나';

  @override
  String get baseball => '야구공';

  @override
  String get soccerBall => '축구공';

  @override
  String get basketball => '농구공';

  @override
  String get tennisBall => '테니스공';

  @override
  String get volleyball => '배구공';

  @override
  String get golfBall => '골프공';

  @override
  String get billiardBall => '당구공';

  @override
  String get bowlingBall => '볼링공';

  @override
  String get cameraFirst => '선두';

  @override
  String get cameraLast => '꼴등';

  @override
  String get cameraAll => '전체';

  @override
  String get gameRest => '다시하기';

  @override
  String get victory => '내가 이겼다!';

  @override
  String get customMap => '커스텀 맵';

  @override
  String get newMap => '새 맵';

  @override
  String get mapObject => '오브젝트';

  @override
  String mapCount(int n) {
    return '$n개';
  }

  @override
  String get scroll => '스크롤';

  @override
  String get move => '이동';

  @override
  String get zoomRest => '줌 리셋';

  @override
  String get objectDefault => '기본';

  @override
  String get objectSecond => '장애물';

  @override
  String get objectSpecial => '특수';

  @override
  String get peg => '핀';

  @override
  String get pegZone => '핀 구역';

  @override
  String get plank => '판자';

  @override
  String get wall => '벽';

  @override
  String get wallLine => '벽 라인';

  @override
  String get bumper => '범퍼';

  @override
  String get triangle => '삼각형';

  @override
  String get rotating => '회전';

  @override
  String get movableObject => '이동';

  @override
  String get breakableObject => '파괴벽';

  @override
  String get flipper => '플리퍼';

  @override
  String get bounce => '바운스';

  @override
  String get accelObject => '가속';

  @override
  String get decelObject => '감속';

  @override
  String get wormhole => '웜홀';

  @override
  String get rope => '로프';

  @override
  String get jsonExport => 'JSON 내보내기';

  @override
  String get jsonExportDesc => 'JSON이 클립보드에 복사되었습니다.';

  @override
  String get jsonImport => 'JSON 가져오기';

  @override
  String get jsonImportDesc => 'JSON 붙여넣기';

  @override
  String get import => '가져오기';

  @override
  String get allDelete => '전체 삭제';

  @override
  String get testPlay => '테스트 플레이';

  @override
  String mapSave(String text) {
    return '$text 저장 완료';
  }

  @override
  String get guideTapDefault => '배치할 위치를 탭하세요';

  @override
  String get guidePegZone01 => '시작 위치를 탭하세요 (1/2)';

  @override
  String get guidePegZone02 => '끝 위치를 탭하세요 (2/2)';

  @override
  String get guideWallLine01 => '점을 탭하세요 (2개 이상)';

  @override
  String guideWallLineIng(int n) {
    return '접을 탭하세요 ($n개) [완료 버튼]';
  }

  @override
  String get mapDone => '완료';

  @override
  String get guideWormHole01 => '입구 위치를 탭하세요 (1/2)';

  @override
  String get guideWormHole02 => '출구 위치를 탭하세요 (2/2)';

  @override
  String get guideRope01 => '로프 시작점을 탭하세요 (1/2)';

  @override
  String get guideRope02 => '로프 끝점을 탭하세요 (2/2)';

  @override
  String get noMap => '아직 만든 맵이 없어요';

  @override
  String get noMapDesc => '상단의 새 맵 버튼을 눌러 보세요';

  @override
  String get mapName => '맵 이름';

  @override
  String get zone => '범위';

  @override
  String get exit => '출구';

  @override
  String get restitution => '탄성';

  @override
  String get endPoint => '끝';

  @override
  String get ratio => '배율';

  @override
  String get width => '너비';

  @override
  String get strength => '힘';

  @override
  String get pi => '반지름';

  @override
  String get size => '크기';

  @override
  String get meter => '길이';

  @override
  String get speed => '속도';

  @override
  String get hp => '체력';

  @override
  String get interval => '간격(초)';

  @override
  String get where => '방향';

  @override
  String get isLeft => '왼쪽';

  @override
  String get isRight => '오른쪽';

  @override
  String get addPoint => '+ 점 추가';

  @override
  String get delPoint => '- 마지막 삭제';

  @override
  String get angle => '각도';

  @override
  String get nums => '밀도';

  @override
  String get editor => '에디터';

  @override
  String get chanllenger => '참가자 소개';

  @override
  String get following => '추적 중!';

  @override
  String get delete => '삭제';

  @override
  String get defaultMap => '기본 맵';

  @override
  String get mapDelete => '맵 삭제';

  @override
  String mapDeleteName(String name) {
    return '맵 [$name] 삭제할까요?';
  }

  @override
  String mapAdTitle(int n) {
    return '$n개까지 커스텀 맵을 만들 수 있어요!';
  }

  @override
  String get mapAdDesc => '광고 시청 후 2개 더 만들어 봐요';

  @override
  String get player => '최대 플레이어';

  @override
  String playerAdTitle(int n) {
    return '최대 플레이어 $n명';
  }

  @override
  String get playerAdDesc => '광고 시청 후 최대 플레이어 증가';

  @override
  String get mapSelect => '맵 선택';

  @override
  String playerAlert(int n) {
    return '최대 $n명까지 가능해요!';
  }

  @override
  String get playerAlertDesc => '광고를 시청하면 10명까지 추가할 수 있어요!';

  @override
  String get ranking => '실시간 순위';

  @override
  String get rank => '위';

  @override
  String get mapRange => '맵 범위';

  @override
  String get appExit => '앱을 종료할까요?';
}
