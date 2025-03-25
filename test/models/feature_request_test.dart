import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('FeatureRequest', () {
    test('should create FeatureRequest with required fields', () {
      final now = DateTime.now();
      final request = FeatureRequest(
        id: 'test-id',
        title: 'Test Feature',
        description: 'This is a test feature',
        userId: 'user-123',
        createdAt: now,
      );

      expect(request.id, 'test-id');
      expect(request.title, 'Test Feature');
      expect(request.description, 'This is a test feature');
      expect(request.userId, 'user-123');
      expect(request.createdAt, now);
      expect(request.upvotes, 0);
      expect(request.downvotes, 0);
      expect(request.upvoterIds, isEmpty);
      expect(request.downvoterIds, isEmpty);
      expect(request.status, 'pending');
    });

    test('should create FeatureRequest with all fields', () {
      final now = DateTime.now();
      final request = FeatureRequest(
        id: 'test-id',
        title: 'Test Feature',
        description: 'This is a test feature',
        userId: 'user-123',
        createdAt: now,
        upvotes: 10,
        downvotes: 5,
        upvoterIds: ['user1', 'user2'],
        downvoterIds: ['user3'],
        status: 'approved',
      );

      expect(request.upvotes, 10);
      expect(request.downvotes, 5);
      expect(request.upvoterIds, ['user1', 'user2']);
      expect(request.downvoterIds, ['user3']);
      expect(request.status, 'approved');
    });

    test('should convert FeatureRequest to Firestore map', () {
      final now = DateTime.now();
      final request = FeatureRequest(
        id: 'test-id',
        title: 'Test Feature',
        description: 'This is a test feature',
        userId: 'user-123',
        createdAt: now,
        upvotes: 10,
        downvotes: 5,
        upvoterIds: ['user1', 'user2'],
        downvoterIds: ['user3'],
        status: 'approved',
      );

      final firestoreMap = request.toFirestore();
      
      expect(firestoreMap['title'], 'Test Feature');
      expect(firestoreMap['description'], 'This is a test feature');
      expect(firestoreMap['userId'], 'user-123');
      expect(firestoreMap['upvotes'], 10);
      expect(firestoreMap['downvotes'], 5);
      expect(firestoreMap['upvoterIds'], ['user1', 'user2']);
      expect(firestoreMap['downvoterIds'], ['user3']);
      expect(firestoreMap['status'], 'approved');
      expect(firestoreMap['createdAt'], isA<Timestamp>());
    });

    test('should create FeatureRequest from Firestore document', () async {
      // Create a fake Firestore instance
      final fakeFirestore = FakeFirebaseFirestore();
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);
      
      // Add test document
      final docRef = await fakeFirestore.collection('features').add({
        'title': 'Test Feature',
        'description': 'This is a test feature',
        'userId': 'user-123',
        'createdAt': timestamp,
        'upvotes': 10,
        'downvotes': 5,
        'upvoterIds': ['user1', 'user2'],
        'downvoterIds': ['user3'],
        'status': 'approved',
      });
      
      final doc = await docRef.get();
      final request = FeatureRequest.fromFirestore(doc);
      
      expect(request.id, doc.id);
      expect(request.title, 'Test Feature');
      expect(request.description, 'This is a test feature');
      expect(request.userId, 'user-123');
      expect(request.createdAt.year, now.year);
      expect(request.createdAt.month, now.month);
      expect(request.createdAt.day, now.day);
      expect(request.upvotes, 10);
      expect(request.downvotes, 5);
      expect(request.upvoterIds, ['user1', 'user2']);
      expect(request.downvoterIds, ['user3']);
      expect(request.status, 'approved');
    });

    test('should create a copy with modified fields', () {
      final now = DateTime.now();
      final request = FeatureRequest(
        id: 'test-id',
        title: 'Test Feature',
        description: 'This is a test feature',
        userId: 'user-123',
        createdAt: now,
      );

      final modifiedRequest = request.copyWith(
        title: 'Updated Title',
        status: 'implemented',
        upvotes: 15,
      );

      // Original should be unchanged
      expect(request.title, 'Test Feature');
      expect(request.status, 'pending');
      expect(request.upvotes, 0);

      // Modified should have updated fields
      expect(modifiedRequest.id, 'test-id'); // Same as original
      expect(modifiedRequest.title, 'Updated Title'); // Updated
      expect(modifiedRequest.description, 'This is a test feature'); // Same as original
      expect(modifiedRequest.status, 'implemented'); // Updated
      expect(modifiedRequest.upvotes, 15); // Updated
    });
  });
}

void testFeatureRequest() => main(); 