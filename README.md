# Azaan 

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Active%20Development-brightgreen)

A cross-platform Islamic utility application providing reliable, location-aware prayer times and Qibla direction.

🔗 **Live Web Application:**  
https://rohanxco.github.io/Final-Year-Project/

---

## Overview

**Azaan** is a web-first, cross-platform application built using Flutter.  
It provides accurate daily prayer times and Qibla direction using deterministic geographic calculations rather than relying solely on device sensors.

The system prioritises:

- Accessibility (public web deployment)
- Reliability (manual location fallback)
- Cross-platform consistency
- Clean, responsive user experience

The project supports both public web access and Android APK distribution.

---

## Core Features

### Location Handling
- Automatic location detection (permission-based)
- Manual location entry fallback
- Persistent local storage of selected location

### Prayer Times
- Daily prayer schedule
- Next prayer indicator
- Location-aware time calculation using `adhan`

### Qibla Direction
- Mathematical bearing calculation using spherical trigonometry
- Visual directional arrow
- Mobile compass support (where available)
- Consistent behaviour across web and mobile

### Deployment
- Public hosting via GitHub Pages
- Android release APK build support
- Version-controlled development workflow

---

## Technology Stack

- **Flutter** – Cross-platform framework  
- **Dart** – Programming language  
- `geolocator` – Location services  
- `adhan` – Prayer time calculations  
- `flutter_compass` – Device compass (mobile only)  
- GitHub Pages – Web deployment  

---

## Platform Support

| Platform | Status |
|----------|--------|
| Web (Chrome, Edge, Safari, etc.) | ✅ Fully Supported |
| Android (APK Build) | ✅ Supported |
| iOS | ⚙️ Build-ready (requires Xcode) |

---

## Running Locally

```bash
flutter pub get
flutter run -d chrome
