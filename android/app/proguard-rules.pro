# Règles ProGuard pour Flutter et Firebase

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Play Core (pour les builds release)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Riverpod
-keep class com.riverpod.** { *; }
-keep class **$StateNotifier { *; }

# Gson (si utilisé)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Modèles de données (gardez vos classes de modèles)
-keep class com.matlav.flutter_ecom.models.** { *; }

# Réflexion
-keepattributes *Annotation*
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}
