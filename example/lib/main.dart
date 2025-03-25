import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_feature_feedback/flutter_firebase_feature_feedback.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Feature Feedback Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Feature Feedback Demo'),
        ),
        body:  FeatureFeedbackWidget(
          userId: 'test-user',
          collectionPath: 'feature_requests',
          isDeveloper: true,
          primaryColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
