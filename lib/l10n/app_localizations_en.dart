// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Toruru';

  @override
  String get appSubtitle => 'Roll it roullet!';

  @override
  String get homeDesc01 => 'Enter names below!';

  @override
  String get homeDesc02 => 'Use commas to separate. (Min. 2 players)';

  @override
  String get start => 'start';

  @override
  String get condition => 'Win Condition';

  @override
  String get winCondition01 => '1st Place Wins';

  @override
  String get winCondition02 => 'Last Place Wins';

  @override
  String get winCondition03 => 'First';

  @override
  String get winCondition04 => 'Last';

  @override
  String winCondition03Desc(int n) {
    return '$n players to win';
  }

  @override
  String winCondition04Desc(int n) {
    return '$n players to win';
  }

  @override
  String get confirm => 'OK';

  @override
  String get cancel => 'cancel';

  @override
  String get defaultPlayers => 'dog,cat,lion,tiger';

  @override
  String get error2minPlayers => 'Min. 2 players required.';

  @override
  String get firstWarning => 'How about Last Place wins?';

  @override
  String get lastWarning => 'How about First Place wins?';

  @override
  String get settings => 'Settings';

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get physicsSettings => 'Physics Settings';

  @override
  String get policy => 'Policy & Terms';

  @override
  String get servicePolicy => 'Terms of Service';

  @override
  String get physics => 'Physics';

  @override
  String get gravity => 'Gravity';

  @override
  String get ballSize => 'Ball Size';

  @override
  String get maxSpeed => 'Max Speed';

  @override
  String get effects => 'Effects';

  @override
  String get trail => 'Ball Trail';

  @override
  String get slowMotion => 'Goal Slow-mo';

  @override
  String get countdown => 'Countdown';

  @override
  String get ballSkins => 'Ball Skins - Each has unique physics!';

  @override
  String get marble => 'Marble';

  @override
  String get marbleDesc => 'Classic glass marble style';

  @override
  String get solar => 'Solar System';

  @override
  String get solarDesc => 'Planets of our solar system';

  @override
  String get sports => 'Sports';

  @override
  String get sportsDesc => 'Various sports balls';

  @override
  String get pixel => '8-Bit Pixel';

  @override
  String get pixelDesc => 'Retro pixel-art balls';

  @override
  String get slime => 'Slime';

  @override
  String get slimeDesc => 'Jelly-like lightweight balls';

  @override
  String get fruits => 'Fruits';

  @override
  String get fruitsDesc => 'Colorful assorted fruits';

  @override
  String get optionsBack => 'Reset Options';

  @override
  String get adReward => 'Unlock with Ad';

  @override
  String get policyAlert => 'View our Terms and Policy?';

  @override
  String get warning => 'Oops...!';

  @override
  String get error => 'Error!';

  @override
  String get winnerCountError => 'Winners must be fewer than players';

  @override
  String get mercury => 'Mercury';

  @override
  String get venus => 'Venus';

  @override
  String get earth => 'Earth';

  @override
  String get mars => 'Mars';

  @override
  String get jupiter => 'Jupiter';

  @override
  String get saturn => 'Saturn';

  @override
  String get uranus => 'Uranus';

  @override
  String get neptune => 'Neptune';

  @override
  String get apple => 'Apple';

  @override
  String get pear => 'Pear';

  @override
  String get pineapple => 'Pineapple';

  @override
  String get orange => 'Orange';

  @override
  String get lemon => 'Lemon';

  @override
  String get kiwi => 'Kiwi';

  @override
  String get strawberry => 'Strawberry';

  @override
  String get coconut => 'Coconut';

  @override
  String get durian => 'Durian';

  @override
  String get banana => 'Banana';

  @override
  String get baseball => 'Baseball';

  @override
  String get soccerBall => 'Soccer Ball';

  @override
  String get basketball => 'Basketball';

  @override
  String get tennisBall => 'Tennis Ball';

  @override
  String get volleyball => 'Volleyball';

  @override
  String get golfBall => 'Golf Ball';

  @override
  String get billiardBall => 'Billiard Ball';

  @override
  String get bowlingBall => 'Bowling Ball';

  @override
  String get cameraFirst => 'first';

  @override
  String get cameraLast => 'last';

  @override
  String get cameraAll => 'top';

  @override
  String get gameRest => 'reset';

  @override
  String get victory => 'Winner, Dinner!';

  @override
  String get customMap => 'Custom Map';

  @override
  String get newMap => 'New Map';

  @override
  String get mapObject => 'Object';

  @override
  String mapCount(int n) {
    return '$n Count';
  }

  @override
  String get scroll => 'Scroll';

  @override
  String get move => 'Move';

  @override
  String get zoomRest => 'Reset Zoom';

  @override
  String get objectDefault => 'Basic';

  @override
  String get objectSecond => 'Obstacle';

  @override
  String get objectSpecial => 'Special';

  @override
  String get peg => 'Peg';

  @override
  String get pegZone => 'Peg Zone';

  @override
  String get plank => 'Plank';

  @override
  String get wall => 'Wall';

  @override
  String get wallLine => 'Wall Line';

  @override
  String get bumper => 'Bumper';

  @override
  String get triangle => 'Triangle';

  @override
  String get rotating => 'Rotating';

  @override
  String get movableObject => 'Moving';

  @override
  String get breakableObject => 'Fragile Wall';

  @override
  String get flipper => 'Flipper';

  @override
  String get bounce => 'Bounce';

  @override
  String get accelObject => 'Accel';

  @override
  String get decelObject => 'Decel';

  @override
  String get wormhole => 'Wormhole';

  @override
  String get rope => 'Rope';

  @override
  String get jsonExport => 'Export JSON';

  @override
  String get jsonExportDesc => 'JSON copied to clipboard.';

  @override
  String get jsonImport => 'Import JSON';

  @override
  String get jsonImportDesc => 'Paste JSON here';

  @override
  String get import => 'Import';

  @override
  String get allDelete => 'Delete All';

  @override
  String get testPlay => 'Test Play';

  @override
  String mapSave(String text) {
    return '$text Saved';
  }

  @override
  String get guideTapDefault => 'Tap a location to place';

  @override
  String get guidePegZone01 => 'Tap start position (1/2)';

  @override
  String get guidePegZone02 => 'Tap end position (2/2)';

  @override
  String get guideWallLine01 => 'Tap points (2 or more)';

  @override
  String guideWallLineIng(int n) {
    return 'Tap points ($n pts) [Done Button]';
  }

  @override
  String get mapDone => 'Done';

  @override
  String get guideWormHole01 => 'Tap entrance (1/2)';

  @override
  String get guideWormHole02 => 'Tap exit (2/2)';

  @override
  String get guideRope01 => 'Tap start point (1/2)';

  @override
  String get guideRope02 => 'Tap end point (2/2)';

  @override
  String get noMap => 'No maps created yet';

  @override
  String get noMapDesc => 'Tap the \'New Map\' button above to start!';

  @override
  String get mapName => 'New map';

  @override
  String get zone => 'Range';

  @override
  String get exit => 'Exit';

  @override
  String get restitution => 'Bounciness';

  @override
  String get endPoint => 'End Point';

  @override
  String get ratio => 'Ratio';

  @override
  String get width => 'Width';

  @override
  String get strength => 'Power';

  @override
  String get pi => 'Radius';

  @override
  String get size => 'Size';

  @override
  String get meter => 'Length';

  @override
  String get speed => 'Speed';

  @override
  String get hp => 'HP';

  @override
  String get interval => 'Interval (s)';

  @override
  String get where => 'Direction';

  @override
  String get isLeft => 'Left';

  @override
  String get isRight => 'Right';

  @override
  String get addPoint => '+ Add Point';

  @override
  String get delPoint => '- Delete Last';

  @override
  String get angle => 'Angle';

  @override
  String get nums => 'Density';

  @override
  String get editor => 'editor';

  @override
  String get chanllenger => 'Players';

  @override
  String get following => 'following now!';

  @override
  String get delete => 'delete';

  @override
  String get defaultMap => 'Default Maps';

  @override
  String get mapDelete => 'Map delete';

  @override
  String mapDeleteName(String name) {
    return 'Do you want Map [$name] delete?';
  }

  @override
  String mapAdTitle(int n) {
    return 'You can create up to $n custom maps!';
  }

  @override
  String get mapAdDesc => 'Watch an ad to create 2 maps!';

  @override
  String get player => 'Max Players';

  @override
  String playerAdTitle(int n) {
    return 'Max Players: $n';
  }

  @override
  String get playerAdDesc => 'Watch an ad to increase the max player limit!';

  @override
  String get mapSelect => 'Map select';

  @override
  String playerAlert(int n) {
    return 'You can have up to $n players!';
  }

  @override
  String get playerAlertDesc =>
      'Watch an ad to increase the limit to 10 players!';

  @override
  String get ranking => 'Current Ranking';

  @override
  String get rank => 'th';

  @override
  String get mapRange => 'Map Area';

  @override
  String get appExit => 'Quit the app?';
}
