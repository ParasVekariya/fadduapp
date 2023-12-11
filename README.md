- [Getting Started](#getting-started)
- [Flutter Set Up](#flutter-set-up)
- [Getting Started with Android Studio](#getting-started-with-android-studio)
- [Check for extra requirements](#check-for-extra-requirements)
- [Clone the repository](#clone-the-repository)
- [APK File](#apk-file)

# Android Login with OAuth

The project outlines the usage of OAuth with the login of Google, Facebook & Twitter. This also outlines the importance of Security using Software Defined Network.

## Getting Started

Let's get your machine set up for the smooth functioning of the app.

## Flutter Set Up
- The first step is to install **[Flutter] (https://docs.flutter.dev/get-started/install)** on your device and follow the instructions given in it.

## Getting Started with Android Studio
- Moving on we will install **[Android Studio](https://developer.android.com/studio/install)** which gives us access to anddroid tools.
- Once downloaded follow the steps
  - Open the DMG file
  - Drag and drop the application file to the Applications folder
  - Launch the Android Studio and set up Wizard, which includes downloading the Android sdk required for development
  - Note: Download **pixel 7** devices for better functioning of Android applications. This can be done from the AVD manager in the Android Studio application

## Check for extra requirements
- After the first two steps, run the following command on the terminal which checks for flutter development requirements to be fulfilled
  - ``` flutter doctor ```
  - This is how it would look like
  - <img width="638" alt="Screenshot 2023-12-11 at 5 33 14 PM" src="https://github.com/ParasVekariya/fadduapp/assets/81183082/347cc502-1ad9-474c-be15-c208de571f6b">
  -  If there are any issues, Just download the requirements
  -  You may be prompted to accept the **Android licenses** for development which can be done by
    - ```flutter doctor --android-licenses```
  - You may be prompted to install **XCode**, which is not a necessasity for android developement

## Clone the repository
- **Git** is necessary for the repository to be cloned
- Just open the terminal and type in
  - ```https://github.com/ParasVekariya/fadduapp.git```
- Navigate to the folder and run
  - ```flutter clean```
  - ```flutter pub get```

## APK File
In case you do not want to go through all steps, here is a quick way
- Open the [App](https://drive.google.com/drive/folders/147ifUN4TbSYQOlVbFirAeZ1n5-V_zoD7) drive link
- Install the apk file
- and you are good to go

For any furthur help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
