# Building

## 0. Dependencies

- (https://github.com/theos/theos)[Theos]
- Put the following into `$THEOS/lib`:
  - nanopb.framework
  - GoogleUtilities.framework
  - GoogleMobileAds.framework **\(Must be version 7.41\)**
  - GoogleAppMeasurement.framework
  - libGoogleMobileAds.a **\(Must be version 7.41\)**
- iOS 11.2 SDK

## 1. Preparing

- Do one of the following:
  - Open `SmartDepictions/DepictionAdmobView.mm` and remove the test devices line
  - Create a file name `SmartDepictions/AdmobTests.h` and create a macro named `AdMobTestDevices` which contains an `NSArray`

## 2. Compiling and packaging

- Debug build: `make clean package install`
- Release build: `FINALPACKAGE=1 DEBUG=0 make clean package install`

## 3. Troubleshooting

- If you are having an issue related to `___isOSVersionAtLeast`, open `macros.h` and replace `#if 0` with `#if 1`.