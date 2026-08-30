# sporky_maxi

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Apple Login on Android

Apple Login on Android uses Apple's web flow, so the redirect URL must be a public HTTPS backend URL registered in Apple Developer.

Run Flutter with the Apple Service ID and callback URL:

```bash
flutter run \
  --dart-define=APPLE_SERVICE_ID=com.sporky.maxi.web \
  --dart-define=APPLE_REDIRECT_URI=https://dev.sporkymaxi.com/api/v1/auth/apple/callback
```

The same callback URL must be added to the Apple Developer Services ID return URLs.
