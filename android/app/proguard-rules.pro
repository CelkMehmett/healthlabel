# ML Kit için kurallar
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class androidx.** { *; }

# Google Play Core kuralları
-keep class com.google.android.play.** { *; }

# Flutter kuralları
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }

# Hive kuralları
-keep class * extends hive.HiveObject
-keep class * extends hive.TypeAdapter

# Image picker kuralları
-keep class androidx.lifecycle.** { *; }

# Firebase/ML Kit text recognition
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.play.**

# Genel optimizasyon kuralları
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
