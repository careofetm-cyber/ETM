# Android Configuration

## 1. Google Maps API Key

### Add to android/app/src/main/AndroidManifest.xml:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    
    <application>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
    </application>
</manifest>
```

## 2. Firebase Configuration

### Download google-services.json from Firebase Console
### Place it in android/app/google-services.json

### Add to android/app/build.gradle:
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Add to android/build.gradle:
```gradle
classpath 'com.google.gms:google-services:4.4.0'
```

## 3. ProGuard Rules

### Create android/app/proguard-rules.pro:
```
-keep class com.google.android.gms.** { *; }
-keep class io.flutter.** { *; }
```

## 4. Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

## 5. Build App Bundle

```bash
flutter build appbundle --release
```
