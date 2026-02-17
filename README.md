#  Islamic Companion App

A cross-platform Islamic Companion application built with **Flutter**, providing:
- Accurate prayer times based on user location
- Qibla direction (web + mobile support)
- Manual location fallback
- Clean, modern UI

🔗 **Live Web App:**  
https://rohanxco.github.io/Final-Year-Project/

---

##  Features

-  **Automatic location detection**
-  **Qibla direction**
  - Web: calculated bearing + static arrow
  - Mobile (Android/iOS): real-time compass rotation
-  **Daily prayer times**
-  **Manual location settings** (fallback when GPS is unavailable)
-  Works worldwide

---

##  Technology Stack

- **Flutter** (single codebase)
- **Dart**
- `geolocator` – location services
- `adhan` – prayer time calculations
- `flutter_compass` – device compass (mobile)
- GitHub Pages – web deployment

---

##  Platform Support

| Platform | Status |
|--------|--------|
| Web (Browsers) | ✅ |
| Android APK | ✅ |
| iOS | ✅ (build-ready) |

---

##  Running Locally

```bash
flutter pub get
flutter run -d chrome
