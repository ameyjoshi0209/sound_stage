# 🎵🎧 SoundStage – Music Event Ticketing App
[![Flutter](https://img.shields.io/badge/flutter-0061F2.svg?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/dart-87CEEB.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/firebase-ffca28.svg?style=flat&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Google Cloud](https://img.shields.io/badge/google%20cloud-0F9D58.svg?style=flat&logo=google-cloud&logoColor=white)](https://cloud.google.com/)
[![Cloudinary](https://img.shields.io/badge/cloudinary-3448C5.svg?style=flat&logo=cloudinary&logoColor=white)](https://cloudinary.com/)
[![Stripe](https://img.shields.io/badge/stripe-9B4DE5.svg?style=flat&logo=stripe&logoColor=white)](https://stripe.com/)
[![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=flat&logo=visual-studio-code&logoColor=white)](https://code.visualstudio.com/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/)
[![Git](https://img.shields.io/badge/git-F05032.svg?style=flat&logo=git&logoColor=white)](https://git-scm.com/)<br>
[![Windows](https://badgen.net/badge/icon/windows?icon=windows&label)](https://microsoft.com/windows/)
[![Linux](https://img.shields.io/badge/linux-FCC624.svg?style=flat&logo=linux&logoColor=black)](https://www.linux.org/)
[![Android](https://img.shields.io/badge/android-4CAF50.svg?style=flat&logo=android&logoColor=white)](https://www.android.com/)
[![iOS](https://img.shields.io/badge/iOS-000000.svg?style=flat&logo=apple&logoColor=white)](https://www.apple.com/ios/)
[![Size](https://4.vercel.app/github/size/ameyjoshi0209/sound_stage?icon=github)](src)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
<br>
&nbsp;

Welcome to SoundStage🎶 an innovative and fully-featured mobile application 📱 designed to streamline the experience of booking, managing, and attending music events. Built using Flutter and Firebase 🔥, it connects customers 🎟️, event organizers 🎤, and admins 👨‍💻 in a seamless, secure 🔒, and scalable 🌐 environment.

&nbsp;
## 🚀 Features

### 🎟️ For Customers
- Register, log in, and manage your profile.
- Browse and filter music events by date, location, or genre.
- Book tickets with secure Stripe payment integration.
- Receive a unique QR code for every ticket for secure event entry.
- View and manage booking history.

### 🎤 For Organizers
- Register and get approved by an admin.
- Upload, edit, or delete events.
- Access real-time stats on ticket sales and attendee analytics.
- Scan QR codes at the venue for secure ticket validation.
- Generate financial reports.

### 🛠️ For Admins
- Approve or reject organizers and their events.
- Manage all user data and event content.
- Generate comprehensive platform-wide financial and user activity reports.


&nbsp;
## 🧱 Tech Stack

| Layer         | Technology |
|---------------|------------|
| Frontend      | Flutter (Dart) |
| Backend       | Firebase (Firestore, Auth), Dart |
| Auth & Security | Firebase Auth, OAuth 2.0, crypto |
| Payments      | Stripe API via `flutter_stripe` |
| QR Code       | `pretty_qr_code`, `mobile_scanner` |
| Media Uploads | Cloudinary |
| Other Packages | `shared_preferences`, `intl`, `random_string`, etc. |


&nbsp;
## 📱 Screenshots

<p align="center">
  <img src="docs/images/user_login.png" alt="Login Screen" height=490 width=220 />&nbsp;
  <img src="docs/images/user_home.png" alt="Home Screen" height=490 width=220 />&nbsp;
  <img src="docs/images/org_home.png" alt="Organizer Login" height=490 width=220 />&nbsp;
  <img src="docs/images/org_dash.png" alt="Organizer Dashboard" height=490 width=220 />&nbsp;
  <img src="docs/images/admin_login.png" alt="Admin Login" height=490 width=220 />&nbsp;
  <img src="docs/images/admin_dash.png" alt="Admin Dashboard" height=490 width=220 />&nbsp;

</p>


&nbsp;
## 🪜 Modules

- **Authentication**
- **Event Management**
- **Ticket Booking and QR Code Generation**
- **Event Analytics and Reporting**
- **Admin Dashboard**


&nbsp;
## 🔧 Installation

1. Clone the repository:

```bash
git clone https://github.com/ameyjoshi0209/sound_stage.git
cd sound_stage
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Firebase in the project using your credentials.

4. Run the app:

```bash
flutter run
```

&nbsp;
>_**Note: For comprehensive setup, refer to the [SoundStage Setup Guide](docs/setup.md).**_

&nbsp;
## 📚 Documentation

- [Project Setup Guide](docs/setup.md)
- [User Manual](docs/manual.md)
- [Database Schema](docs/schema.md)
- [System Design Diagrams](docs/design_diagrams.md)


&nbsp;
## 🧠 Future Enhancements

- Add forgot password feature.
- Seat selection interface.
- Notification system for event updates and purchases.
- Language preferences and dark mode support.
- Bug reporting from within the app.


&nbsp;
## 🤝 Contributing

We welcome contributions! 🙌✨ If you'd like to contribute to the project, please fork the repository 🍴, make your changes, and submit a pull request 🔀. Your contributions help make the platform better for everyone! 💡🚀

&nbsp;
## 📖 License

This project is licensed under the [Apache-2.0 license](LICENSE).
