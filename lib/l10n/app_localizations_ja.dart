// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'テクルル';

  @override
  String get appSubtitle => 'クルクル·ルーレット';

  @override
  String get homeDesc01 => '名前を入力してね！';

  @override
  String get homeDesc02 => ',(半角)で区切ってね。2人以上からスタートできるよ';

  @override
  String get start => 'スタート';

  @override
  String get condition => '勝利条件';

  @override
  String get winCondition01 => '一番勝ち';

  @override
  String get winCondition02 => 'ビリが勝ち';

  @override
  String get winCondition03 => '先着';

  @override
  String get winCondition04 => 'ワースト';

  @override
  String winCondition03Desc(int n) {
    return '$n人まで勝ち';
  }

  @override
  String winCondition04Desc(int n) {
    return '$n人まで勝ち';
  }

  @override
  String get confirm => 'OK';

  @override
  String get cancel => '戻る';

  @override
  String get defaultPlayers => 'ねこ,いぬ,さめ,とり';

  @override
  String get error2minPlayers => '２人以上からスタートできるよ';

  @override
  String get firstWarning => 'ビリが勝ちにしませんか？';

  @override
  String get lastWarning => '一番勝ちにしませんか？';

  @override
  String get settings => '設定';

  @override
  String get gameSettings => 'ゲーム設定';

  @override
  String get physicsSettings => '物理効果設定';

  @override
  String get policy => '規約とポリシー';

  @override
  String get servicePolicy => '利用規約';

  @override
  String get physics => '物理';

  @override
  String get gravity => '重力';

  @override
  String get ballSize => 'ボールの大きさ';

  @override
  String get maxSpeed => '最大速度';

  @override
  String get effects => '演出';

  @override
  String get trail => 'ボールトレイル';

  @override
  String get slowMotion => 'ゴール直前スロー';

  @override
  String get countdown => 'カウントダウン';

  @override
  String get ballSkins => 'ボールスキン - 種類ごとに物理特性が違うよ！';

  @override
  String get marble => 'マーブル';

  @override
  String get marbleDesc => '定番のビー玉スタイル';

  @override
  String get solar => '太陽系';

  @override
  String get solarDesc => '太陽系の惑星たち';

  @override
  String get sports => 'スポーツ';

  @override
  String get sportsDesc => 'いろんな球技ボール';

  @override
  String get pixel => '8ビットピクセル';

  @override
  String get pixelDesc => 'レトロなピクセルボール';

  @override
  String get slime => 'スライム';

  @override
  String get slimeDesc => 'ゼリーのような軽いボール';

  @override
  String get fruits => 'フルーツ';

  @override
  String get fruitsDesc => 'カラフルな果物たち';

  @override
  String get optionsBack => 'オプション初期化';

  @override
  String get adReward => '広告で解放';

  @override
  String get policyAlert => '規約ページに移動しますか？';

  @override
  String get warning => 'あちゃ...!';

  @override
  String get error => 'エラー!';

  @override
  String get winnerCountError => '優勝者は参加者より少なくしてね！';

  @override
  String get mercury => 'マーキュリー';

  @override
  String get venus => 'ヴィーナス';

  @override
  String get earth => 'アース';

  @override
  String get mars => 'マーズ';

  @override
  String get jupiter => 'ジュピター';

  @override
  String get saturn => 'サターン';

  @override
  String get uranus => 'ウラヌス';

  @override
  String get neptune => 'ネプチューン';

  @override
  String get apple => 'リンゴ';

  @override
  String get pear => '梨';

  @override
  String get pineapple => 'パイナップル';

  @override
  String get orange => 'オレンジ';

  @override
  String get lemon => 'レモン';

  @override
  String get kiwi => 'キウイ';

  @override
  String get strawberry => 'イチゴ';

  @override
  String get coconut => 'ココナッツ';

  @override
  String get durian => 'ドリアン';

  @override
  String get banana => 'バナナ';

  @override
  String get baseball => '野球ボール';

  @override
  String get soccerBall => 'サッカーボール';

  @override
  String get basketball => 'バスケットボール';

  @override
  String get tennisBall => 'テニスボール';

  @override
  String get volleyball => 'バレーボール';

  @override
  String get golfBall => 'ゴルフボール';

  @override
  String get billiardBall => 'ビリヤードボール';

  @override
  String get bowlingBall => 'ボウリングボール';

  @override
  String get cameraFirst => 'ファースト';

  @override
  String get cameraLast => 'ワースト';

  @override
  String get cameraAll => '全体';

  @override
  String get gameRest => 'やり直し';

  @override
  String get victory => 'やったぜ！かったぜ！';

  @override
  String get customMap => 'カスタムマップ';

  @override
  String get newMap => '新規マップ';

  @override
  String get mapObject => 'オブジェクト';

  @override
  String mapCount(int n) {
    return '$n個';
  }

  @override
  String get scroll => 'スクロール';

  @override
  String get move => '移動';

  @override
  String get zoomRest => 'ズームリセット';

  @override
  String get objectDefault => '基本';

  @override
  String get objectSecond => '障害物';

  @override
  String get objectSpecial => '特殊';

  @override
  String get peg => 'ピン';

  @override
  String get pegZone => 'ピンエリア';

  @override
  String get plank => '板';

  @override
  String get wall => '壁';

  @override
  String get wallLine => '壁ライン';

  @override
  String get bumper => 'バンパー';

  @override
  String get triangle => '三角形';

  @override
  String get rotating => '回転';

  @override
  String get movableObject => '移動';

  @override
  String get breakableObject => '破壊壁';

  @override
  String get flipper => 'フリッパー';

  @override
  String get bounce => 'バウンス';

  @override
  String get accelObject => '加速';

  @override
  String get decelObject => '減速';

  @override
  String get wormhole => 'ワームホール';

  @override
  String get rope => 'ロープ';

  @override
  String get jsonExport => 'JSON書き出し';

  @override
  String get jsonExportDesc => 'JSONをクリップボードにコピーしました。';

  @override
  String get jsonImport => 'JSON読み込み';

  @override
  String get jsonImportDesc => 'JSONを貼り付けてください';

  @override
  String get import => 'インポート';

  @override
  String get allDelete => '全削除';

  @override
  String get testPlay => 'テストプレイ';

  @override
  String mapSave(String text) {
    return '$text 保存完了';
  }

  @override
  String get guideTapDefault => '配置する場所をタップしてね';

  @override
  String get guidePegZone01 => '開始位置をタップしてね (1/2)';

  @override
  String get guidePegZone02 => '終了位置をタップしてね (2/2)';

  @override
  String get guideWallLine01 => '点をタップしてね (2個以上)';

  @override
  String guideWallLineIng(int n) {
    return '点をタップしてね ($n個) [完了ボタン]';
  }

  @override
  String get mapDone => '完了';

  @override
  String get guideWormHole01 => '入口をタップしてね (1/2)';

  @override
  String get guideWormHole02 => '出口をタップしてね (2/2)';

  @override
  String get guideRope01 => 'ロープの始点をタップしてね (1/2)';

  @override
  String get guideRope02 => 'ロープの終点をタップしてね (2/2)';

  @override
  String get noMap => 'まだ作ったマップがないよ';

  @override
  String get noMapDesc => '上の『新規マップ』ボタンを押してみてね！';

  @override
  String get mapName => '新規マップ';

  @override
  String get zone => '範囲';

  @override
  String get exit => '出口';

  @override
  String get restitution => '反発係数';

  @override
  String get endPoint => '終点';

  @override
  String get ratio => '倍率';

  @override
  String get width => '幅';

  @override
  String get strength => 'パワー';

  @override
  String get pi => '半径';

  @override
  String get size => 'サイズ';

  @override
  String get meter => '長さ';

  @override
  String get speed => '速度';

  @override
  String get hp => 'HP';

  @override
  String get interval => '往復 (秒)';

  @override
  String get where => '方向';

  @override
  String get isLeft => '左';

  @override
  String get isRight => '右';

  @override
  String get addPoint => '+ 点を追加';

  @override
  String get delPoint => '- 最後を削除';

  @override
  String get angle => '角度';

  @override
  String get nums => '密度';

  @override
  String get editor => 'マップ作成';

  @override
  String get chanllenger => '参加者紹介';

  @override
  String get following => 'フォロー中';

  @override
  String get delete => '削除';

  @override
  String get defaultMap => 'デフォルトマップ';

  @override
  String get mapDelete => 'マップ削除';

  @override
  String mapDeleteName(String name) {
    return 'マップ [$name] 削除しますか？';
  }

  @override
  String mapAdTitle(int n) {
    return 'カスタムマップは$n個まで作ることができるよ';
  }

  @override
  String get mapAdDesc => '広告を見て、もう２個作りましょう！';

  @override
  String get player => '最大人数';

  @override
  String playerAdTitle(int n) {
    return '最大参加人数 $n人';
  }

  @override
  String get playerAdDesc => '広告を見て、最大人数を増やしましょう';

  @override
  String get mapSelect => 'マップ選択';

  @override
  String playerAlert(int n) {
    return '最大$n人までできるよ！';
  }

  @override
  String get playerAlertDesc => '広告を見て、10人まで追加しましょう！';

  @override
  String get ranking => 'ランキング';

  @override
  String get rank => '位';

  @override
  String get mapRange => 'マップ範囲';

  @override
  String get appExit => 'アプリを終了しますか？';
}
