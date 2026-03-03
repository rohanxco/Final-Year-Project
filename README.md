# Azaan

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Active%20Development-brightgreen)

A cross-platform Islamic utility application providing reliable prayer times, Qibla direction, and a Qur'an reader.

🔗 **Live Web Application:**  
https://rohanxco.github.io/Final-Year-Project/

---

## Overview

**Azaan** is a web-first, cross-platform application built using Flutter.  
It provides accurate daily prayer times, Qibla direction, and a Qur’an reader experience.

The system prioritises:

- Accessibility (public web deployment)
- Reliability (manual location fallback)
- Cross-platform consistency
- Clean, responsive user experience
- Maintainable and version-controlled workflow (GitHub)

---

## Academic Context

This project is developed as part of a Final Year Software Engineering project, focusing on cross-platform development, location-aware services, deterministic calculations, and scalable web deployment.

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

### Qur'an Reader
- Full Surah list (114 Surahs)
- JSON-based asset loading
- Surah detail view (Ayahs per Surah)
- Smooth navigation between Surahs
- Cross-platform asset support (Web, Android, iOS)

### Deployment
- Public hosting via GitHub Pages
- Android release APK build support
- iOS Simulator support (via Xcode)
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
| iOS (Simulator) | ✅ Supported |
| iOS (Physical Device) | ⚙️ Requires Apple Developer Signing |

---

## Running Locally

### 1️⃣ Install Dependencies

```bash
flutter pub get
