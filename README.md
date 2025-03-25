# Flutter Firebase Feature Feedback

A Flutter package that enables developers to collect and manage feature feedback from their users using Firebase. This package provides an easy way to implement feature request functionality in your Flutter applications.

## Screenshots

| Feature List | Add Feature Form |
|:------------:|:---------------:|
| ![Feature List](screenshots/home_page.png) | ![Add Feature Form](screenshots/add_feature_sheet.png) |

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

1.  Use the FeatureFeedbackWidget wherever you want to display the feedback UI:

```dart
  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Request Feature'),
                          ),
                          body: FeatureFeedbackWidget(
                            collectionPath: 'feature_requests',
                            userId: uc.user!.id,
                          ),
                        ),
                      ),
                    );
```

## Example

Check out the `/example` folder for a complete working example.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
