# ⚙️⛏️ Project Setup Guide: Sound Stage

This guide provides step-by-step instructions to set up the Sound Stage mobile app development environment 🎧📱, covering everything from installing essential software 💻 and configuring tools ⚙️ to setting up the project directory 📂 and ensuring compatibility with both iOS 🍏 and Android 🤖 platforms. By the end of this guide, you'll be ready to run the project 🚀!

&nbsp;
## 📦 Prerequisites

- **Flutter SDK** (Latest stable version)
- **Android Studio** or **Xcode** for emulator/device support
- **Visual Studio Code** (Optional, but recommended)
- **Firebase Project**
- **Stripe Account**
- **Cloudinary Account**
- **Git**

&nbsp;
## 1️⃣ Install Flutter SDK
- **Windows**: Use the [Flutter installation guide](https://flutter.dev/docs/get-started/install/windows)
- **macOS**: Use the [Flutter installation guide](https://flutter.dev/docs/get-started/install/macos)
- **Linux**: Use the [Flutter installation guide](https://flutter.dev/docs/get-started/install/linux)
>**Visual Studio Code**: Install the Flutter and Dart extensions from the marketplace.<br>
>**Android Studio**: Install for android emulator.

&nbsp;
## 2️⃣ Clone the Repository

```bash
git clone https://github.com/ameyjoshi0209/sound_stage.git
cd sound_stage
```

&nbsp;
## 3️⃣ Install Flutter Dependencies

```bash
flutter pub get
```

&nbsp;
## 4️⃣ Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new Firebase project
3. Add Android/iOS apps to the project
4. Download and place the configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
5. Enable the following in Firebase:
   - **Authentication** → Email/Password
   - **Firestore** → Create a database → Enabled by default

&nbsp;
## 5️⃣ Stripe Payment Setup

1. Create an account on [Stripe](https://stripe.com)
2. Retrieve your **Publishable** and **Secret** keys
3. Place them in the `lib\services\data.dart` file:
   ```dart
   String secretkey = "your-stripe-secret-key-here";
   String publishedkey = "your-stripe-published-key-here";
   ```

&nbsp;
## 6️⃣ Cloudinary Setup (Image Uploads)

1. Create an account on [Cloudinary](https://cloudinary.com)
2. Note your:
   - Cloud name
   - API key
   - API secret
3. Place them in the `lib\services\data.dart` file:
   ```dart
   String cloudName = 'cloudinary-cloud-name-here';
   String uploadPreset = 'cloudinary-upload-preset-name-here'
   String apikey = "cloudinary-api-key-here";
   String apiSecretKey = "cloudinary-secret-api-key-here";
   ```

&nbsp;
## 7️⃣ Configure Android & iOS (Optional)
**⚠️ Important Note**<br>
_The following configurations have been set up in the project. Ensure they are correct. No need to change them unless you have specific requirements._

### Android

- Update `android/app/build.gradle`:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

- Ensure `minSdkVersion` is at least `21`

### iOS

- Open `ios/Runner.xcworkspace` in Xcode
- Set deployment target to `12.0+`
- Ensure `GoogleService-Info.plist` is included in build

&nbsp;
## 8️⃣ Run the App

```bash
flutter run
```

To specify a device:

```bash
flutter devices
flutter run -d <device_id>
```
&nbsp;

## ✅ You're Ready!

The app should now be running locally with Firebase, Stripe, and Cloudinary configured. Ensure all credentials and environment settings are secure before production deployment.
