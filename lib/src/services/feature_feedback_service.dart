import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feature_request.dart';

class FeatureFeedbackService {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  FeatureFeedbackService({
    FirebaseFirestore? firestore,
    required this.collectionPath,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection(collectionPath);

  // Create a new feature request
  Future<FeatureRequest> createFeatureRequest({
    required String title,
    required String description,
    required String userId,
  }) async {
    final docRef = await _collection.add({
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.now(),
      'upvoterIds': [],
      'downvoterIds': [],
      'status': 'pending',
    });

    final doc = await docRef.get();
    return FeatureRequest.fromFirestore(doc);
  }

  // Get all feature requests
  Stream<List<FeatureRequest>> getFeatureRequests({List<FeatureRequestStatus>? statuses}) {
    Query query = _collection;
    if (statuses != null) {
      query = query.where('status', whereIn: statuses.map((status) => status.name).toList());
    }

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => FeatureRequest.fromFirestore(doc)).toList());
  }

  // Get all feature requests
  Future<List<FeatureRequest>> getFeatureRequestsFuture({List<FeatureRequestStatus>? statuses}) async {
    Query query = _collection;
    if (statuses != null) {
      query = query.where('status', whereIn: statuses.map((status) => status.name).toList());
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => FeatureRequest.fromFirestore(doc)).toList();
  }

  // Update vote for a feature request
  Future<void> updateVote({
    required String featureId,
    required String userId,
    required bool isUpvote,
  }) async {
    final docRef = _collection.doc(featureId);

    return _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);
      final featureRequest = FeatureRequest.fromFirestore(docSnapshot);

      final upvoterIds = List<String>.from(featureRequest.upvoterIds);
      final downvoterIds = List<String>.from(featureRequest.downvoterIds);

      if (isUpvote) {
        if (upvoterIds.contains(userId)) {
          upvoterIds.remove(userId);
        } else {
          upvoterIds.add(userId);
          downvoterIds.remove(userId);
        }
      } else {
        if (downvoterIds.contains(userId)) {
          downvoterIds.remove(userId);
        } else {
          downvoterIds.add(userId);
          upvoterIds.remove(userId);
        }
      }

      transaction.update(docRef, {
        'upvoterIds': upvoterIds,
        'downvoterIds': downvoterIds,
      });
    });
  }

  // Update feature request status
  Future<void> updateStatus({
    required String featureId,
    required String status,
  }) async {
    await _collection.doc(featureId).update({'status': status});
  }

  // Delete feature request
  Future<void> deleteFeatureRequest(String featureId) async {
    await _collection.doc(featureId).delete();
  }
}
