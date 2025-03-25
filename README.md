<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Flutter Firebase Feature Feedback

A Flutter package that enables developers to collect and manage feature feedback from their users using Firebase. This package provides an easy way to implement feature request functionality in your Flutter applications.

## Features

- 🎯 Easy-to-use Feature Feedback Widget
- 🔥 Firebase Integration
- 👥 User Voting System
- 📊 Feature Request Management
- 🔄 Real-time Updates
- 🎨 Customizable UI

## Getting Started

### Prerequisites

1. Add Firebase to your Flutter project
2. Enable Cloud Firestore in your Firebase Console

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_firebase_feature_feedback: ^0.0.1
```

### Firebase Setup

1. Initialize Firebase in your app:
```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

2. Ensure you have the necessary Firebase configuration files:
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)

## Usage

1. Wrap your app with the FeatureFeedbackProvider:

```dart
void main() {
  runApp(
    FeatureFeedbackProvider(
      child: MyApp(),
    ),
  );
}
```

2. Use the FeatureFeedbackWidget wherever you want to display the feedback UI:

```dart
FeatureFeedbackWidget(
  onSubmit: (FeatureRequest request) {
    print('New feature request: ${request.title}');
  },
)
```

## Example

Check out the `/example` folder for a complete working example.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
