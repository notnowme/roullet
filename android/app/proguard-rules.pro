# Flutter 기본 설정 유지
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# AdMob (광고) 관련 설정 - R8이 광고 코드를 지우지 않게 보호
-keep public class com.google.android.gms.ads.** { *; }
-keep public class com.google.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }

# Forge2D / JBox2D 관련 (물리 엔진 연산 코드 보호)
-keep class org.jbox2d.** { *; }
-keep class com.google.fpl.liquidfun.** { *; }

# 에러가 나더라도 빌드를 강제로 진행하게 하는 옵션 (핵심!)
-ignorewarnings
-dontwarn com.google.android.gms.**
-dontwarn io.flutter.**