# Azaan – Prayer Times & Qibla Utility App

A cross-platform application built with **Flutter**, providing location-aware prayer times and Qibla direction across web and mobile platforms.

🔗 **Live Web Application:**  
https://rohanxco.github.io/Final-Year-Project/

---

## Overview

**Azaan** is a web-first, cross-platform utility application designed to provide:

- Accurate daily prayer times based on user location  
- Qibla direction using mathematical bearing calculation  
- Manual location fallback for improved reliability  
- Clean, minimal, and responsive user interface  

The project is deployed publicly via GitHub Pages and also supports Android APK builds.

---

## Features

### Location Handling
- Automatic location detection (with permission)
- Manual location entry as fallback
- Persistent local storage of selected location

### Qibla Direction
- **Web:** Calculated geographic bearing with visual directional arrow
- **Mobile:** Real-time compass rotation (where supported)
- Mathematical calculation ensures consistent cross-platform behaviour

### Prayer Times
- Daily prayer schedule
- Next prayer indicator
- Location-aware time calculation

### Deployment
- Public web deployment via GitHub Pages
- Android release APK build support

---

## Technology Stack

- **Flutter** – Cross-platform framework  
- **Dart** – Programming language  
- `geolocator` – Location services  
- `adhan` – Prayer time calculations  
- `flutter_compass` – Device compass (mobile only)  
- GitHub Pages – Web hosting & deployment  

---

## Platform Support

| Platform | Status |
|----------|--------|
| Web (Chrome, Edge, Safari, etc.) | ✅ Fully Supported |
| Android (APK build) | ✅ Supported |
| iOS | ⚙️ Build-ready (requires Xcode) |

---

## Running Locally

```bash
flutter pub get
flutter run -d chrome
```

---

## Build Android APK

```bash
flutter build apk --release
```

APK output location:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Project Structure

```
lib/
 ├── screens/
 ├── services/
 ├── models/
 └── main.dart
```

The application follows a modular structure separating UI screens from service logic (location, prayer calculations, Qibla bearing).

---

## Academic Context

This project was developed as part of a Final Year Project in BEng Software Engineering.  
The focus is on accessibility, reliability, and cross-platform deployment.

---

## License

This project is for academic and demonstration purposes.
