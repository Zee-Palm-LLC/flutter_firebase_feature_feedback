import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/services/feature_feedback_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// Create a testing wrapper for widget tests
Widget createTestableWidget({
  required Widget child,
  required FeatureFeedbackProvider provider,
}) {
  return MaterialApp(
    home: ChangeNotifierProvider<FeatureFeedbackProvider>.value(
      value: provider,
      child: child,
    ),
  );
}

// Create test data
class TestData {
  static Map<String, dynamic> sampleFeatureRequestData = {
    'title': 'Sample Feature',
    'description': 'This is a sample feature request',
    'userId': 'test-user-id',
    'createdAt': DateTime.now(),
    'upvotes': 3,
    'downvotes': 1,
    'upvoterIds': ['user1', 'user2', 'user3'],
    'downvoterIds': ['user4'],
    'status': 'pending',
  };
  
  // Create a real service with a fake Firestore for integration tests
  static FeatureFeedbackService createTestService() {
    final fakeFirestore = FakeFirebaseFirestore();
    return FeatureFeedbackService(
      firestore: fakeFirestore,
      collectionPath: 'feature_requests_test',
    );
  }
} 