import 'package:cloud_firestore/cloud_firestore.dart';

class FeatureRequest {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;
  final int upvotes;
  final int downvotes;
  final List<String> upvoterIds;
  final List<String> downvoterIds;
  final String status; // 'pending', 'approved', 'rejected', 'implemented'

  FeatureRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    this.upvotes = 0,
    this.downvotes = 0,
    List<String>? upvoterIds,
    List<String>? downvoterIds,
    this.status = 'pending',
  })  : upvoterIds = upvoterIds ?? [],
        downvoterIds = downvoterIds ?? [];

  factory FeatureRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FeatureRequest(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      upvoterIds: List<String>.from(data['upvoterIds'] ?? []),
      downvoterIds: List<String>.from(data['downvoterIds'] ?? []),
      status: data['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'upvotes': upvotes,
      'downvotes': downvotes,
      'upvoterIds': upvoterIds,
      'downvoterIds': downvoterIds,
      'status': status,
    };
  }

  FeatureRequest copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    String? status,
    int? upvotes,
    int? downvotes,
    List<String>? upvoterIds,
    List<String>? downvoterIds,
    DateTime? createdAt,
  }) {
    return FeatureRequest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      upvoterIds: upvoterIds ?? this.upvoterIds,
      downvoterIds: downvoterIds ?? this.downvoterIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
