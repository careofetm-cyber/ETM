# iOS Configuration

## 1. Google Maps API Key

### Add to ios/Runner/AppDelegate.swift:
```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 2. Firebase Configuration

### Download GoogleService-Info.plist from Firebase Console
### Place it in ios/Runner/GoogleService-Info.plist

### Add to ios/Runner/Info.plist:
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>googleusercontentcom</string>
</array>
```

## 3. Permissions

### Add to ios/Runner/Info.plist:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location for transport tracking.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location for transport tracking.</string>
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes.</string>
```

## 4. Build

```bash
# Debug
flutter build ios --debug

# Release
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```
