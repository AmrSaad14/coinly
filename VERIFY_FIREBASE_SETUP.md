# Verify Firebase Setup - Critical Steps

The error "Invalid app info in play_integrity_token" means Firebase can't verify your app. Let's verify everything is correct.

## ✅ Step 1: Verify SHA Certificates in Firebase Console

1. Go to: https://console.firebase.google.com/
2. Select project: **coinly-egypt**
3. Click ⚙️ **Settings** → **Project settings**
4. Scroll to **"Your apps"** section
5. **IMPORTANT**: Make sure you're looking at the **NEW** Android app you just added
6. Click on the Android app with package name: `com.coinly.owner`
7. **Verify you see BOTH fingerprints listed:**
   - ✅ SHA-1: `AB:AC:B1:58:99:21:D3:8E:ED:7D:0C:F5:04:71:02:CC:D7:6A:9B:F7`
   - ✅ SHA-256: `1E:FF:FC:B4:3F:09:D9:2E:59:88:BC:D6:A2:24:2E:2B:3B:20:E0:0D:A6:56:1F:C0:B2:C2:57:C8:A7:85:E0:97`

**If they're NOT there:**
- Click **"Add fingerprint"** button
- Add SHA-1 first, then add SHA-256
- **Download the new `google-services.json`**
- Replace `android/app/google-services.json`

## ✅ Step 2: Verify Package Name Matches

1. In Firebase Console → Your apps → Android app
2. Package name should be: `com.coinly.owner`
3. In your code (`android/app/build.gradle.kts`), verify:
   ```kotlin
   applicationId = "com.coinly.owner"
   ```
4. They must match **exactly** (case-sensitive, no spaces)

## ✅ Step 3: Download Latest google-services.json

1. Firebase Console → Project Settings → Your apps
2. Click on your Android app (`com.coinly.owner`)
3. Click **"Download google-services.json"**
4. **Replace** `android/app/google-services.json` with the downloaded file
5. Make sure the file has:
   - `"package_name": "com.coinly.owner"`
   - `"mobilesdk_app_id": "1:766956126566:android:ec1856ed80578e1b7048a7"`

## ✅ Step 4: Enable Phone Authentication

1. Firebase Console → **Authentication** → **Sign-in method**
2. Click on **Phone**
3. Toggle to **Enabled** if not already
4. Click **Save**

## ✅ Step 5: Verify Blaze Plan

1. Firebase Console → ⚙️ **Settings** → **Usage and billing**
2. Verify you're on **Blaze plan** (pay-as-you-go)
3. Phone authentication **requires** Blaze plan

## ✅ Step 6: Wait for Propagation

After adding SHA certificates:
- **Wait 5-10 minutes** for Firebase to propagate changes
- Changes don't take effect immediately

## ✅ Step 7: Clean Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

## 🔍 Still Not Working?

If you still get the error after verifying everything:

1. **Double-check SHA certificates are in the NEW app** (not the old one)
2. **Make sure you downloaded google-services.json AFTER adding SHA certificates**
3. **Wait 10-15 minutes** - Firebase can take time to propagate
4. **Check if there are multiple Android apps** - make sure you're using the right one

## 📋 Quick Checklist

- [ ] SHA-1 certificate added to Firebase Console
- [ ] SHA-256 certificate added to Firebase Console  
- [ ] Downloaded google-services.json AFTER adding certificates
- [ ] Package name matches: `com.coinly.owner`
- [ ] Phone authentication is enabled
- [ ] Blaze plan is active
- [ ] Waited 5-10 minutes after adding certificates
- [ ] Clean rebuild performed






