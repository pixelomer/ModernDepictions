# Building

## 0. Dependencies

- (https://github.com/theos/theos)[Theos]
- Put the following into `$THEOS/lib`:
  - GoogleMobileAds.framework **\(Must be version 7.41\)**
  - libGoogleMobileAds.a **\(Must be version 7.41\)**
- iOS 11.2 SDK

## 1. Preparing

- Do one of the following:
  - Open `ModernDepictions/DepictionAdmobView.mm` and remove the test devices line
  - Create a file name `ModernDepictions/AdmobTests.h` and create a macro named `AdMobTestDevices` which contains an `NSArray`

## 2. Compiling and packaging

- Debug build: `make clean package install`
- Release build: `FINALPACKAGE=1 DEBUG=0 make clean package install`
