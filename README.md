# Status Getter

<p float="left">
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/splash.png" width="200">
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/status.png" width="200" />
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/downloader.png" width="200" />
  <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/sidebar.png" width="200" />
</p>

**Overview:**
Status Getter is a Flutter app designed to effortlessly save WhatsApp and Business WhatsApp statuses directly to your Android device. Beyond its primary functionality, this app also supports seamless video downloading from over 10 of the most popular websites, including YouTube, TikTok, Facebook, Instagram, and more.

**Key Features:**

1. **WhatsApp Status Saver:** Save both personal and business WhatsApp statuses with ease.
2. **Video Downloading:** Enjoy the convenience of downloading videos from a diverse range of platforms.
3. **Multi-Platform Support:** Compatible with over 10 popular websites, ensuring a versatile video downloading experience.
4. **Google Mobile Ads:** Implemented Google Mobile Ads to enhance the user experience and support the app's sustainability.

**How to Use:**

1. Launch the app and navigate to the desired WhatsApp status.
2. Save the status directly to your Android device.
3. Explore and download videos from various platforms by pasting the video link.
4. Experience uninterrupted video downloading with support for popular websites.

**Technical Details:**

- **Framework:** Flutter
- **Ads Integration:** Google Mobile Ads

## Installation

Ensure you have the latest Flutter version installed, a minimum of 3.13 or above. You can download Flutter from [here](https://docs.flutter.dev/get-started/install).

Additionally, make sure you have Android Studio installed on your machine. You can download Android Studio [here](https://developer.android.com/studio). For MacBook users, install Xcode from the App Store.

Clone the GitHub repository:

```bash
git clone https://github.com/OttomanDeveloper/status_getter.git
```

Navigate to the project directory:

```bash
cd your_project
```

Run the following command in the terminal:

```bash
flutter pub get
```

The project utilizes Firebase as the backend server.
Ensure Firebase is well connected with the project to avoid app exceptions.

 <img src="https://github.com/OttomanDeveloper/status_getter/blob/main/repo_images/firestore_db_structure.png">

Firestore Collection name is `settings` and document name is `ads`. Below is document field names and dataTypes.

| Field Name         | Data Type |
| ------------------ | --------- |
| appstoreurl        | `String`  |
| googlebanner       | `String`  |
| adenable           | `Boolean` |
| googleinterstitial | `String`  |
| googlenative       | `String`  |
| privacyPolicyUrl   | `String`  |

Now you're ready to go.

## Developer Contact Details

- [Instagram](https://www.instagram.com/ottoman_coder/)
- [Telegram](https://t.me/ottomancoder)
- Skype ID: [Join Skype](https://join.skype.com/invite/Udbe33x6J98H)
- [Facebook Page](https://web.facebook.com/ottomancoder/)
- [YouTube Channel](https://www.youtube.com/c/OttomanCoder/videos)
- WhatsApp: `+923041561853`
- Email: `usman243786@gmail.com`

Feel free to contribute, report issues, or enhance the functionality of Status Getter. Your feedback and collaboration are highly valued.

Let's simplify status saving and video downloading with Status Getter!

🚀📱 #Flutter #WhatsAppStatusSaver #VideoDownloader #MobileApps #OpenSource
