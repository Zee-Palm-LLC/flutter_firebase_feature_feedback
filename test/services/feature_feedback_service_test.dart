import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_feature_feedback/src/services/feature_feedback_service.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('FeatureFeedbackService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FeatureFeedbackService service;
    const collectionPath = 'feature_requests';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      service = FeatureFeedbackService(
        firestore: fakeFirestore,
        collectionPath: collectionPath,
      );
    });

    test('should create a feature request', () async {
      // Create a feature request
      final request = await service.createFeatureRequest(
        title: 'New Feature',
        description: 'This is a new feature request',
        userId: 'user-456',
      );

      // Verify the request was created correctly
      expect(request.id, isNotEmpty);
      expect(request.title, 'New Feature');
      expect(request.description, 'This is a new feature request');
      expect(request.userId, 'user-456');
      expect(request.upvotes, 0);
      expect(request.downvotes, 0);
      expect(request.status, 'pending');

      // Verify the request exists in Firestore
      final doc = await fakeFirestore.collection(collectionPath).doc(request.id).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['title'], 'New Feature');
    });

    test('should retrieve all feature requests', () async {
      // Add sample feature requests
      await fakeFirestore.collection(collectionPath).add({
        'title': 'Feature 1',
        'description': 'Description 1',
        'userId': 'user-1',
        'createdAt': Timestamp.now(),
        'upvotes': 5,
        'downvotes': 1,
        'upvoterIds': ['user-2', 'user-3'],
        'downvoterIds': ['user-4'],
        'status': 'pending',
      });

      await fakeFirestore.collection(collectionPath).add({
        'title': 'Feature 2',
        'description': 'Description 2',
        'userId': 'user-2',
        'createdAt': Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
        'upvotes': 10,
        'downvotes': 2,
        'upvoterIds': ['user-1', 'user-3', 'user-5'],
        'downvoterIds': ['user-4', 'user-6'],
        'status': 'approved',
      });

      // Test Future-based method
      final requests = await service.getFeatureRequestsFuture();
      expect(requests.length, 2);
      
      // Verify order (newest first)
      expect(requests[0].title, 'Feature 1');
      expect(requests[1].title, 'Feature 2');

      // Test Stream-based method (more complex)
      final streamRequests = await service.getFeatureRequests().first;
      expect(streamRequests.length, 2);
      expect(streamRequests[0].title, 'Feature 1');
      expect(streamRequests[1].title, 'Feature 2');
    });

    test('should update votes for a feature request', () async {
      // Add a sample feature request
      final docRef = await fakeFirestore.collection(collectionPath).add({
        'title': 'Feature X',
        'description': 'Description X',
        'userId': 'user-x',
        'createdAt': Timestamp.now(),
        'upvotes': 1,
        'downvotes': 0,
        'upvoterIds': ['user-existing'],
        'downvoterIds': [],
        'status': 'pending',
      });

      // Test upvoting - add a new upvote
      await service.updateVote(
        featureId: docRef.id,
        userId: 'user-new',
        isUpvote: true,
      );

      // Verify upvote was added
      var updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['upvotes'], 2);
      expect(updatedDoc.data()?['upvoterIds'], contains('user-new'));

      // Test upvoting - remove an existing upvote
      await service.updateVote(
        featureId: docRef.id,
        userId: 'user-existing',
        isUpvote: true,
      );

      // Verify upvote was removed
      updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['upvotes'], 1);
      expect(updatedDoc.data()?['upvoterIds'], isNot(contains('user-existing')));

      // Test downvoting - add a downvote
      await service.updateVote(
        featureId: docRef.id,
        userId: 'user-downvoter',
        isUpvote: false,
      );

      // Verify downvote was added
      updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['downvotes'], 1);
      expect(updatedDoc.data()?['downvoterIds'], contains('user-downvoter'));

      // Test switching from upvote to downvote
      await service.updateVote(
        featureId: docRef.id,
        userId: 'user-new',
        isUpvote: false,
      );

      // Verify vote was switched
      updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['upvotes'], 0);
      expect(updatedDoc.data()?['downvotes'], 2);
      expect(updatedDoc.data()?['upvoterIds'], isNot(contains('user-new')));
      expect(updatedDoc.data()?['downvoterIds'], contains('user-new'));
    });

    test('should update the status of a feature request', () async {
      // Add a sample feature request
      final docRef = await fakeFirestore.collection(collectionPath).add({
        'title': 'Status Test Feature',
        'description': 'Test updating status',
        'userId': 'user-status',
        'createdAt': Timestamp.now(),
        'upvotes': 0,
        'downvotes': 0,
        'upvoterIds': [],
        'downvoterIds': [],
        'status': 'pending',
      });

      // Update the status
      await service.updateStatus(
        featureId: docRef.id,
        status: 'implemented',
      );

      // Verify the status was updated
      final updatedDoc = await docRef.get();
      expect(updatedDoc.data()?['status'], 'implemented');
    });

    test('should delete a feature request', () async {
      // Add a sample feature request
      final docRef = await fakeFirestore.collection(collectionPath).add({
        'title': 'Feature to Delete',
        'description': 'This feature will be deleted',
        'userId': 'user-delete',
        'createdAt': Timestamp.now(),
        'upvotes': 0,
        'downvotes': 0,
        'upvoterIds': [],
        'downvoterIds': [],
        'status': 'pending',
      });

      // Verify it exists
      var doc = await docRef.get();
      expect(doc.exists, isTrue);

      // Delete the feature
      await service.deleteFeatureRequest(docRef.id);

      // Verify it was deleted
      doc = await docRef.get();
      expect(doc.exists, isFalse);
    });
  });
}

void testFeatureFeedbackService() => main(); 