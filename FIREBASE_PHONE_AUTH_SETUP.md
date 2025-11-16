# Firebase Phone Authentication Setup Guide

This guide will help you complete the setup for Firebase Phone Authentication on both Android and iOS platforms.

## ✅ Already Completed

The following has already been configured in your project:
- ✅ Firebase dependencies added to `pubspec.yaml`
- ✅ Firebase initialized in `main.dart`
- ✅ Android `google-services.json` file added
- ✅ Android Google Services plugin configured
- ✅ Android minSdk set to 21 and MultiDex enabled
- ✅ iOS Info.plist configured with URL schemes structure

## 📱 Android Setup

### 1. Add SHA Certificates to Firebase Console

Firebase Phone Authentication requires your app's SHA-1 and SHA-256 fingerprints.

#### Debug Certificate (For Development)

**Windows:**
```powershell
cd android
./gradlew signingReport
```

Or manually get the debug certificate:
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Mac/Linux:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Release Certificate (For Production)

```bash
keytool -list -v -keystore /path/to/your/release/keystore.jks -alias your_key_alias
```

#### Add Certificates to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** (⚙️ icon)
4. Scroll down to **Your apps** section
5. Select your Android app
6. Scroll to **SHA certificate fingerprints**
7. Click **Add fingerprint** and paste your SHA-1
8. Click **Add fingerprint** again and paste your SHA-256
9. Click **Save**

### 2. Enable Phone Authentication in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Authentication** → **Sign-in method**
4. Click on **Phone** provider
5. Click **Enable** toggle
6. Click **Save**

### 3. Test Phone Numbers (Optional - For Testing)

For testing without sending real SMS:

1. Go to **Authentication** → **Sign-in method**
2. Scroll down to **Phone numbers for testing**
3. Add test phone numbers with verification codes
   - Example: `+1 650-555-1234` → `123456`

### 4. Android Build Configuration

Already configured, but verify in `android/app/build.gradle.kts`:

```kotlin
defaultConfig {
    minSdk = 21  // ✅ Required for Firebase Phone Auth
    multiDexEnabled = true  // ✅ Enable MultiDex
}
```

## 🍎 iOS Setup

### 1. Add GoogleService-Info.plist

**Important:** The iOS `GoogleService-Info.plist` file is **NOT** present in your project yet!

#### Steps:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** (⚙️ icon)
4. In the **Your apps** section, find your iOS app
   - If you don't have an iOS app, click **Add app** → **iOS**
   - Use bundle ID: `com.example.coinly` (or your custom bundle ID)
5. Download the `GoogleService-Info.plist` file
6. **Drag and drop** the `GoogleService-Info.plist` file into your Xcode project:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Drag the file into the **Runner** folder in Xcode's project navigator
   - ✅ **Check** "Copy items if needed"
   - ✅ **Check** "Runner" under "Add to targets"
   - Click **Finish**

### 2. Configure URL Scheme with REVERSED_CLIENT_ID

After adding `GoogleService-Info.plist`:

1. Open `GoogleService-Info.plist` in a text editor
2. Find the `REVERSED_CLIENT_ID` value (looks like: `com.googleusercontent.apps.123456789-abcdefgh`)
3. Copy that value
4. Open `ios/Runner/Info.plist`
5. Find the `CFBundleURLSchemes` section (already added by us)
6. Replace `com.googleusercontent.apps.YOUR_REVERSED_CLIENT_ID` with your actual `REVERSED_CLIENT_ID`

Example:
```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.123456789-abcdefgh</string>
</array>
```

### 3. Enable Push Notifications in Xcode

Firebase Phone Authentication on iOS requires APNs (Apple Push Notifications):

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the **Runner** project in the navigator
3. Select the **Runner** target
4. Go to **Signing & Capabilities** tab
5. Click **+ Capability**
6. Add **Push Notifications**

### 4. Configure APNs in Firebase Console

#### Option A: APNs Authentication Key (Recommended)

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Go to **Certificates, Identifiers & Profiles**
3. Click **Keys** → **+** (Create a new key)
4. Give it a name (e.g., "Firebase APNs Key")
5. Check **Apple Push Notifications service (APNs)**
6. Click **Continue** → **Register**
7. Download the `.p8` file and note the **Key ID**
8. Go to [Firebase Console](https://console.firebase.google.com/)
9. Go to **Project Settings** → **Cloud Messaging** tab
10. Under **Apple app configuration**:
    - Upload the `.p8` file
    - Enter your **Key ID**
    - Enter your **Team ID** (found in Apple Developer Portal)
11. Click **Upload**

#### Option B: APNs Certificates (Alternative)

1. Generate a Certificate Signing Request (CSR) from Keychain Access on Mac
2. Go to Apple Developer Portal → Certificates
3. Create an APNs certificate
4. Download and install it in Keychain
5. Export as `.p12` file
6. Upload to Firebase Console under **Cloud Messaging**

### 5. Test Phone Numbers (iOS)

Same as Android - add test phone numbers in Firebase Console if needed.

## 🧪 Testing Your Setup

### Test on Android:

```bash
flutter run -d android
```

### Test on iOS:

```bash
flutter run -d ios
```

Or open in Xcode:
```bash
open ios/Runner.xcworkspace
```

## 🔍 Troubleshooting

### Android Issues

**Issue: "UNIMPLEMENTED" or "This operation is not implemented"**
- Make sure you've added SHA-1 and SHA-256 to Firebase Console
- Make sure `google-services.json` is in `android/app/` directory
- Clean and rebuild: `flutter clean && flutter pub get`

**Issue: "We have blocked all requests from this device due to unusual activity"**
- Firebase has rate limits for phone authentication
- Use test phone numbers for development

### iOS Issues

**Issue: "Missing GoogleService-Info.plist"**
- Download from Firebase Console and add to Xcode project
- Make sure it's in the Runner target

**Issue: "reCAPTCHA verification failed"**
- Make sure URL scheme (REVERSED_CLIENT_ID) is correctly configured
- Check that Push Notifications capability is enabled
- Verify APNs key/certificate is uploaded to Firebase

**Issue: "Invalid API key"**
- Re-download `GoogleService-Info.plist` from Firebase Console
- Make sure you're using the correct project

## 📝 Next Steps

After completing this setup:

1. ✅ Verify all certificates and configuration files are in place
2. ✅ Test phone authentication on both platforms
3. ✅ Implement the actual Firebase Auth logic in your screens:
   - `lib/presentation/screens/auth/signup_screen.dart`
   - `lib/presentation/screens/auth/otp_verification_screen.dart`

## 📚 Resources

- [Firebase Phone Auth Documentation](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/docs/auth/phone)
- [Firebase Console](https://console.firebase.google.com/)
- [Apple Developer Portal](https://developer.apple.com/account/)

## 🚀 Implementation Example

Here's a quick example of how to implement phone authentication in your Flutter code:

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  // Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        print('OTP sent to $phoneNumber');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // Verify OTP
  Future<UserCredential?> verifyOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }
}
```

---

**Need Help?** If you encounter any issues during setup, refer to the troubleshooting section or check the Firebase and Flutter documentation linked above.

