# Status Getter - WhatsApp Status Saver & Video Downloader

<p align="center">
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/splash.png" width="200">
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/status.png" width="200" />
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/downloader.png" width="200" />
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/sidebar.png" width="200" />
</p>

## Overview

**Status Getter** is a feature-rich Flutter application that lets you **save WhatsApp statuses** (images and videos) directly to your Android device — without needing the `MANAGE_EXTERNAL_STORAGE` permission. It uses Android's **Storage Access Framework (SAF)** for secure, scoped access to WhatsApp's `.Statuses` folder, making it fully compliant with Google Play's latest storage policies.

Beyond WhatsApp status saving, the app doubles as a powerful **all-in-one video downloader** — paste any video link from TikTok, YouTube, Facebook, Instagram, and 10+ other platforms to save videos directly to your device.

## Key Features

### WhatsApp Status Saver
- Save **WhatsApp** and **WhatsApp Business** statuses (photos & videos)
- **SAF-based permission** on Android 11+ — no broad filesystem access needed
- **Legacy support** for Android 9 and 10 with `READ_EXTERNAL_STORAGE`
- Browse statuses in a fast, lazy-loaded grid with cached thumbnails
- Full-screen image viewer with **pinch-to-zoom** and **Hero transition** animations
- Video player with native aspect ratio, autoplay, and looping
- **One-tap save** to gallery and **share** to any app

### All Video Downloader
- Download videos from **TikTok, YouTube, Facebook, Instagram, Dailymotion, Vimeo, Reddit, VK**, and more
- Multiple quality options per video (when available)
- **Real-time download progress** with percentage and progress bar
- Automatic file type detection via HTTP content headers
- Downloads saved to public **Downloads** folder with system notification

### Modern UI
- **Material 3** design with custom green color scheme
- **Light and dark mode** with animated day/night toggle
- Segmented tab bar in AppBar with smooth sliding indicator
- Polished sidebar with themed drawer tiles
- Animated splash screen with scale + fade entry
- Hero animations between grid and full-screen viewers

## Architecture

```
lib/
├── core/
│   ├── ad_flow/          # Google AdMob integration (banner, interstitial, native)
│   ├── domain/           # Social download mixin (savefrom.net scraper)
│   ├── extensions/       # BuildContext, String, List, FileSystemEntity extensions
│   ├── functions/        # WaUtils (SAF + legacy path), GetIt setup
│   ├── model/            # StatusItemModel, SafFileInfo, SiteModel
│   ├── router/           # GoRouter configuration
│   └── services/         # SafService (MethodChannel wrapper)
├── meta/                 # Colors, themes, assets, settings constants
├── views/
│   ├── dashboard/        # Main dashboard with PageView + tab navigation
│   │   └── layouts/      # WhatsApp, Business WA, TikTok download tabs
│   ├── splash/           # Animated splash screen
│   ├── status_saver/     # Image and video viewer screens
│   └── widgets/          # CustomScaffold, drawer, theme toggle, bottom nav
android/
├── app/src/main/kotlin/
│   └── com/androidsaver/statusgetter/
│       ├── MainActivity.kt   # Flutter engine + thumbnail MethodChannel
│       └── SafHandler.kt     # SAF MethodChannel (7 methods)
```

## SAF Migration (MANAGE_EXTERNAL_STORAGE Removal)

The app was migrated from `MANAGE_EXTERNAL_STORAGE` to **Storage Access Framework** to comply with Google Play policies. The migration is split across three layers:

| Layer | Files | What it does |
|-------|-------|-------------|
| **Kotlin native** | `SafHandler.kt`, `MainActivity.kt` | SAF folder picker, persisted permissions, fast `ContentResolver.query()` file listing, on-demand file caching, thumbnail generation from content URIs |
| **Dart service** | `SafService`, `SafFileInfo` | MethodChannel wrapper mapping 1:1 to Kotlin methods |
| **Dart logic** | `WaUtils`, BLoCs | `useSaf` (SDK >= 30) vs `_useModernPath` (SDK >= 29) branching, shared `fetchStatusesViaSaf()` for both WhatsApp variants |

### Android Version Support

| Android | SDK | Permission | Path | Status Fetching |
|---------|-----|-----------|------|-----------------|
| 9 and below | ≤ 28 | `READ_EXTERNAL_STORAGE` | `/WhatsApp/Media/.Statuses` | `Directory.listSync()` |
| 10 | 29 | `READ_EXTERNAL_STORAGE` + `requestLegacyExternalStorage` | `/Android/media/com.whatsapp/...` | `Directory.listSync()` |
| 11-12 | 30-32 | **SAF folder picker** | SAF content URI | `ContentResolver.query()` |
| 13+ | ≥ 33 | **SAF folder picker** | SAF content URI | `ContentResolver.query()` |

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.44 / Dart 3.12 |
| State Management | BLoC / Cubit (flutter_bloc) + HydratedBloc |
| Dependency Injection | GetIt |
| Routing | GoRouter |
| Ads | Google Mobile Ads (AdMob) |
| Video Player | video_player + Chewie |
| Storage | SAF (native Kotlin) + permission_handler (legacy) |
| Backend | Cloud Firestore (ad configuration) |
| Build System | AGP 9.0.1, Kotlin 2.3.20, Gradle 9.1.0 |

## Installation

### Prerequisites
- Flutter 3.44+ ([Download Flutter](https://docs.flutter.dev/get-started/install))
- Android Studio with SDK 35+ ([Download Android Studio](https://developer.android.com/studio))
- Firebase project with Firestore enabled

### Setup

```bash
git clone https://github.com/OttomanDeveloper/status_getter.git
cd status_getter
flutter pub get
```

### Firebase Configuration

Connect Firebase to the project. The app reads ad configuration from Firestore:

<img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/firestore_db_structure.png">

**Collection:** `settings` | **Document:** `ads`

| Field Name         | Data Type |
| ------------------ | --------- |
| appstoreurl        | `String`  |
| googlebanner       | `String`  |
| adenable           | `Boolean` |
| googleinterstitial | `String`  |
| googlenative       | `String`  |
| privacyPolicyUrl   | `String`  |

### Build & Run

```bash
# Debug
flutter run

# Release APK
flutter build apk --release

# Clean install (to test SAF permission flow)
flutter run --uninstall-first
```

## Developer Contact

- [Instagram](https://www.instagram.com/ottoman_coder/)
- [Telegram](https://t.me/ottomancoder)
- Skype: [Join Skype](https://join.skype.com/invite/Udbe33x6J98H)
- [Facebook](https://web.facebook.com/ottomancoder/)
- [YouTube](https://www.youtube.com/c/OttomanCoder/videos)
- WhatsApp: `+923041561853`
- Email: `usman243786@gmail.com`

Contributions, bug reports, and feature requests are welcome.

## Keywords

WhatsApp Status Saver, WhatsApp Status Downloader, Business WhatsApp Status Saver, WA Status Saver, WhatsApp Status Saver Flutter, WhatsApp Status Saver Android, Save WhatsApp Status Without Screenshot, WhatsApp Status Download App, All Video Downloader Flutter, TikTok Video Downloader, YouTube Video Downloader, Facebook Video Downloader, Instagram Video Downloader, Social Media Video Downloader, Flutter Video Downloader App, SAF WhatsApp Status Saver, Storage Access Framework Flutter, MANAGE_EXTERNAL_STORAGE Alternative, Scoped Storage WhatsApp, WhatsApp Status Saver Without Root, Flutter WhatsApp Status App, Status Saver APK, WhatsApp DP Saver, WhatsApp Story Saver, Save WhatsApp Status to Gallery
