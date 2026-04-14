import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Toruru'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Roll it roullet!'**
  String get appSubtitle;

  /// No description provided for @homeDesc01.
  ///
  /// In en, this message translates to:
  /// **'Enter names below!'**
  String get homeDesc01;

  /// No description provided for @homeDesc02.
  ///
  /// In en, this message translates to:
  /// **'Use commas to separate. (Min. 2 players)'**
  String get homeDesc02;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Win Condition'**
  String get condition;

  /// No description provided for @winCondition01.
  ///
  /// In en, this message translates to:
  /// **'1st Place Wins'**
  String get winCondition01;

  /// No description provided for @winCondition02.
  ///
  /// In en, this message translates to:
  /// **'Last Place Wins'**
  String get winCondition02;

  /// No description provided for @winCondition03.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get winCondition03;

  /// No description provided for @winCondition04.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get winCondition04;

  /// No description provided for @winCondition03Desc.
  ///
  /// In en, this message translates to:
  /// **'{n} players to win'**
  String winCondition03Desc(int n);

  /// No description provided for @winCondition04Desc.
  ///
  /// In en, this message translates to:
  /// **'{n} players to win'**
  String winCondition04Desc(int n);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @defaultPlayers.
  ///
  /// In en, this message translates to:
  /// **'dog,cat,lion,tiger'**
  String get defaultPlayers;

  /// No description provided for @error2minPlayers.
  ///
  /// In en, this message translates to:
  /// **'Min. 2 players required.'**
  String get error2minPlayers;

  /// No description provided for @firstWarning.
  ///
  /// In en, this message translates to:
  /// **'How about Last Place wins?'**
  String get firstWarning;

  /// No description provided for @lastWarning.
  ///
  /// In en, this message translates to:
  /// **'How about First Place wins?'**
  String get lastWarning;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @gameSettings.
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get gameSettings;

  /// No description provided for @physicsSettings.
  ///
  /// In en, this message translates to:
  /// **'Physics Settings'**
  String get physicsSettings;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Policy & Terms'**
  String get policy;

  /// No description provided for @servicePolicy.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get servicePolicy;

  /// No description provided for @physics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get physics;

  /// No description provided for @gravity.
  ///
  /// In en, this message translates to:
  /// **'Gravity'**
  String get gravity;

  /// No description provided for @ballSize.
  ///
  /// In en, this message translates to:
  /// **'Ball Size'**
  String get ballSize;

  /// No description provided for @maxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Max Speed'**
  String get maxSpeed;

  /// No description provided for @effects.
  ///
  /// In en, this message translates to:
  /// **'Effects'**
  String get effects;

  /// No description provided for @trail.
  ///
  /// In en, this message translates to:
  /// **'Ball Trail'**
  String get trail;

  /// No description provided for @slowMotion.
  ///
  /// In en, this message translates to:
  /// **'Goal Slow-mo'**
  String get slowMotion;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get countdown;

  /// No description provided for @ballSkins.
  ///
  /// In en, this message translates to:
  /// **'Ball Skins - Each has unique physics!'**
  String get ballSkins;

  /// No description provided for @marble.
  ///
  /// In en, this message translates to:
  /// **'Marble'**
  String get marble;

  /// No description provided for @marbleDesc.
  ///
  /// In en, this message translates to:
  /// **'Classic glass marble style'**
  String get marbleDesc;

  /// No description provided for @solar.
  ///
  /// In en, this message translates to:
  /// **'Solar System'**
  String get solar;

  /// No description provided for @solarDesc.
  ///
  /// In en, this message translates to:
  /// **'Planets of our solar system'**
  String get solarDesc;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @sportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Various sports balls'**
  String get sportsDesc;

  /// No description provided for @pixel.
  ///
  /// In en, this message translates to:
  /// **'8-Bit Pixel'**
  String get pixel;

  /// No description provided for @pixelDesc.
  ///
  /// In en, this message translates to:
  /// **'Retro pixel-art balls'**
  String get pixelDesc;

  /// No description provided for @slime.
  ///
  /// In en, this message translates to:
  /// **'Slime'**
  String get slime;

  /// No description provided for @slimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Jelly-like lightweight balls'**
  String get slimeDesc;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @fruitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Colorful assorted fruits'**
  String get fruitsDesc;

  /// No description provided for @optionsBack.
  ///
  /// In en, this message translates to:
  /// **'Reset Options'**
  String get optionsBack;

  /// No description provided for @adReward.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Ad'**
  String get adReward;

  /// No description provided for @policyAlert.
  ///
  /// In en, this message translates to:
  /// **'View our Terms and Policy?'**
  String get policyAlert;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Oops...!'**
  String get warning;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error!'**
  String get error;

  /// No description provided for @winnerCountError.
  ///
  /// In en, this message translates to:
  /// **'Winners must be fewer than players'**
  String get winnerCountError;

  /// No description provided for @mercury.
  ///
  /// In en, this message translates to:
  /// **'Mercury'**
  String get mercury;

  /// No description provided for @venus.
  ///
  /// In en, this message translates to:
  /// **'Venus'**
  String get venus;

  /// No description provided for @earth.
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get earth;

  /// No description provided for @mars.
  ///
  /// In en, this message translates to:
  /// **'Mars'**
  String get mars;

  /// No description provided for @jupiter.
  ///
  /// In en, this message translates to:
  /// **'Jupiter'**
  String get jupiter;

  /// No description provided for @saturn.
  ///
  /// In en, this message translates to:
  /// **'Saturn'**
  String get saturn;

  /// No description provided for @uranus.
  ///
  /// In en, this message translates to:
  /// **'Uranus'**
  String get uranus;

  /// No description provided for @neptune.
  ///
  /// In en, this message translates to:
  /// **'Neptune'**
  String get neptune;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @pear.
  ///
  /// In en, this message translates to:
  /// **'Pear'**
  String get pear;

  /// No description provided for @pineapple.
  ///
  /// In en, this message translates to:
  /// **'Pineapple'**
  String get pineapple;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @lemon.
  ///
  /// In en, this message translates to:
  /// **'Lemon'**
  String get lemon;

  /// No description provided for @kiwi.
  ///
  /// In en, this message translates to:
  /// **'Kiwi'**
  String get kiwi;

  /// No description provided for @strawberry.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get strawberry;

  /// No description provided for @coconut.
  ///
  /// In en, this message translates to:
  /// **'Coconut'**
  String get coconut;

  /// No description provided for @durian.
  ///
  /// In en, this message translates to:
  /// **'Durian'**
  String get durian;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @baseball.
  ///
  /// In en, this message translates to:
  /// **'Baseball'**
  String get baseball;

  /// No description provided for @soccerBall.
  ///
  /// In en, this message translates to:
  /// **'Soccer Ball'**
  String get soccerBall;

  /// No description provided for @basketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get basketball;

  /// No description provided for @tennisBall.
  ///
  /// In en, this message translates to:
  /// **'Tennis Ball'**
  String get tennisBall;

  /// No description provided for @volleyball.
  ///
  /// In en, this message translates to:
  /// **'Volleyball'**
  String get volleyball;

  /// No description provided for @golfBall.
  ///
  /// In en, this message translates to:
  /// **'Golf Ball'**
  String get golfBall;

  /// No description provided for @billiardBall.
  ///
  /// In en, this message translates to:
  /// **'Billiard Ball'**
  String get billiardBall;

  /// No description provided for @bowlingBall.
  ///
  /// In en, this message translates to:
  /// **'Bowling Ball'**
  String get bowlingBall;

  /// No description provided for @cameraFirst.
  ///
  /// In en, this message translates to:
  /// **'first'**
  String get cameraFirst;

  /// No description provided for @cameraLast.
  ///
  /// In en, this message translates to:
  /// **'last'**
  String get cameraLast;

  /// No description provided for @cameraAll.
  ///
  /// In en, this message translates to:
  /// **'top'**
  String get cameraAll;

  /// No description provided for @gameRest.
  ///
  /// In en, this message translates to:
  /// **'reset'**
  String get gameRest;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'Winner, Dinner!'**
  String get victory;

  /// No description provided for @customMap.
  ///
  /// In en, this message translates to:
  /// **'Custom Map'**
  String get customMap;

  /// No description provided for @newMap.
  ///
  /// In en, this message translates to:
  /// **'New Map'**
  String get newMap;

  /// No description provided for @mapObject.
  ///
  /// In en, this message translates to:
  /// **'Object'**
  String get mapObject;

  /// No description provided for @mapCount.
  ///
  /// In en, this message translates to:
  /// **'{n} Count'**
  String mapCount(int n);

  /// No description provided for @scroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll'**
  String get scroll;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @zoomRest.
  ///
  /// In en, this message translates to:
  /// **'Reset Zoom'**
  String get zoomRest;

  /// No description provided for @objectDefault.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get objectDefault;

  /// No description provided for @objectSecond.
  ///
  /// In en, this message translates to:
  /// **'Obstacle'**
  String get objectSecond;

  /// No description provided for @objectSpecial.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get objectSpecial;

  /// No description provided for @peg.
  ///
  /// In en, this message translates to:
  /// **'Peg'**
  String get peg;

  /// No description provided for @pegZone.
  ///
  /// In en, this message translates to:
  /// **'Peg Zone'**
  String get pegZone;

  /// No description provided for @plank.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get plank;

  /// No description provided for @wall.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get wall;

  /// No description provided for @wallLine.
  ///
  /// In en, this message translates to:
  /// **'Wall Line'**
  String get wallLine;

  /// No description provided for @bumper.
  ///
  /// In en, this message translates to:
  /// **'Bumper'**
  String get bumper;

  /// No description provided for @triangle.
  ///
  /// In en, this message translates to:
  /// **'Triangle'**
  String get triangle;

  /// No description provided for @rotating.
  ///
  /// In en, this message translates to:
  /// **'Rotating'**
  String get rotating;

  /// No description provided for @movableObject.
  ///
  /// In en, this message translates to:
  /// **'Moving'**
  String get movableObject;

  /// No description provided for @breakableObject.
  ///
  /// In en, this message translates to:
  /// **'Fragile Wall'**
  String get breakableObject;

  /// No description provided for @flipper.
  ///
  /// In en, this message translates to:
  /// **'Flipper'**
  String get flipper;

  /// No description provided for @bounce.
  ///
  /// In en, this message translates to:
  /// **'Bounce'**
  String get bounce;

  /// No description provided for @accelObject.
  ///
  /// In en, this message translates to:
  /// **'Accel'**
  String get accelObject;

  /// No description provided for @decelObject.
  ///
  /// In en, this message translates to:
  /// **'Decel'**
  String get decelObject;

  /// No description provided for @wormhole.
  ///
  /// In en, this message translates to:
  /// **'Wormhole'**
  String get wormhole;

  /// No description provided for @rope.
  ///
  /// In en, this message translates to:
  /// **'Rope'**
  String get rope;

  /// No description provided for @jsonExport.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get jsonExport;

  /// No description provided for @jsonExportDesc.
  ///
  /// In en, this message translates to:
  /// **'JSON copied to clipboard.'**
  String get jsonExportDesc;

  /// No description provided for @jsonImport.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get jsonImport;

  /// No description provided for @jsonImportDesc.
  ///
  /// In en, this message translates to:
  /// **'Paste JSON here'**
  String get jsonImportDesc;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @allDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get allDelete;

  /// No description provided for @testPlay.
  ///
  /// In en, this message translates to:
  /// **'Test Play'**
  String get testPlay;

  /// No description provided for @mapSave.
  ///
  /// In en, this message translates to:
  /// **'{text} Saved'**
  String mapSave(String text);

  /// No description provided for @guideTapDefault.
  ///
  /// In en, this message translates to:
  /// **'Tap a location to place'**
  String get guideTapDefault;

  /// No description provided for @guidePegZone01.
  ///
  /// In en, this message translates to:
  /// **'Tap start position (1/2)'**
  String get guidePegZone01;

  /// No description provided for @guidePegZone02.
  ///
  /// In en, this message translates to:
  /// **'Tap end position (2/2)'**
  String get guidePegZone02;

  /// No description provided for @guideWallLine01.
  ///
  /// In en, this message translates to:
  /// **'Tap points (2 or more)'**
  String get guideWallLine01;

  /// No description provided for @guideWallLineIng.
  ///
  /// In en, this message translates to:
  /// **'Tap points ({n} pts) [Done Button]'**
  String guideWallLineIng(int n);

  /// No description provided for @mapDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get mapDone;

  /// No description provided for @guideWormHole01.
  ///
  /// In en, this message translates to:
  /// **'Tap entrance (1/2)'**
  String get guideWormHole01;

  /// No description provided for @guideWormHole02.
  ///
  /// In en, this message translates to:
  /// **'Tap exit (2/2)'**
  String get guideWormHole02;

  /// No description provided for @guideRope01.
  ///
  /// In en, this message translates to:
  /// **'Tap start point (1/2)'**
  String get guideRope01;

  /// No description provided for @guideRope02.
  ///
  /// In en, this message translates to:
  /// **'Tap end point (2/2)'**
  String get guideRope02;

  /// No description provided for @noMap.
  ///
  /// In en, this message translates to:
  /// **'No maps created yet'**
  String get noMap;

  /// No description provided for @noMapDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'New Map\' button above to start!'**
  String get noMapDesc;

  /// No description provided for @mapName.
  ///
  /// In en, this message translates to:
  /// **'New map'**
  String get mapName;

  /// No description provided for @zone.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get zone;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @restitution.
  ///
  /// In en, this message translates to:
  /// **'Bounciness'**
  String get restitution;

  /// No description provided for @endPoint.
  ///
  /// In en, this message translates to:
  /// **'End Point'**
  String get endPoint;

  /// No description provided for @ratio.
  ///
  /// In en, this message translates to:
  /// **'Ratio'**
  String get ratio;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get strength;

  /// No description provided for @pi.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get pi;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @meter.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get meter;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @hp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get hp;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval (s)'**
  String get interval;

  /// No description provided for @where.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get where;

  /// No description provided for @isLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get isLeft;

  /// No description provided for @isRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get isRight;

  /// No description provided for @addPoint.
  ///
  /// In en, this message translates to:
  /// **'+ Add Point'**
  String get addPoint;

  /// No description provided for @delPoint.
  ///
  /// In en, this message translates to:
  /// **'- Delete Last'**
  String get delPoint;

  /// No description provided for @angle.
  ///
  /// In en, this message translates to:
  /// **'Angle'**
  String get angle;

  /// No description provided for @nums.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get nums;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'editor'**
  String get editor;

  /// No description provided for @chanllenger.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get chanllenger;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'following now!'**
  String get following;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @defaultMap.
  ///
  /// In en, this message translates to:
  /// **'Default Maps'**
  String get defaultMap;

  /// No description provided for @mapDelete.
  ///
  /// In en, this message translates to:
  /// **'Map delete'**
  String get mapDelete;

  /// No description provided for @mapDeleteName.
  ///
  /// In en, this message translates to:
  /// **'Do you want Map [{name}] delete?'**
  String mapDeleteName(String name);

  /// No description provided for @mapAdTitle.
  ///
  /// In en, this message translates to:
  /// **'You can create up to {n} custom maps!'**
  String mapAdTitle(int n);

  /// No description provided for @mapAdDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to create 2 maps!'**
  String get mapAdDesc;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Max Players'**
  String get player;

  /// No description provided for @playerAdTitle.
  ///
  /// In en, this message translates to:
  /// **'Max Players: {n}'**
  String playerAdTitle(int n);

  /// No description provided for @playerAdDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to increase the max player limit!'**
  String get playerAdDesc;

  /// No description provided for @mapSelect.
  ///
  /// In en, this message translates to:
  /// **'Map select'**
  String get mapSelect;

  /// No description provided for @playerAlert.
  ///
  /// In en, this message translates to:
  /// **'You can have up to {n} players!'**
  String playerAlert(int n);

  /// No description provided for @playerAlertDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad to increase the limit to 10 players!'**
  String get playerAlertDesc;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Current Ranking'**
  String get ranking;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'th'**
  String get rank;

  /// No description provided for @mapRange.
  ///
  /// In en, this message translates to:
  /// **'Map Area'**
  String get mapRange;

  /// No description provided for @appExit.
  ///
  /// In en, this message translates to:
  /// **'Quit the app?'**
  String get appExit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
