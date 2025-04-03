import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum FeatureRequestStatus {
  pending(displayText: 'Pending Review', color: Colors.amber),
  approved(displayText: 'Approved', color: Colors.indigoAccent),
  rejected(displayText: 'Not Planned', color: Colors.red),
  implemented(displayText: 'Implemented', color: Colors.greenAccent);

  final String displayText;
  final Color color;
  const FeatureRequestStatus({required this.displayText, required this.color});

  static FeatureRequestStatus fromString(String status) => switch (status) {
        'approved' => FeatureRequestStatus.approved,
        'rejected' => FeatureRequestStatus.rejected,
        'implemented' => FeatureRequestStatus.implemented,
        _ => FeatureRequestStatus.pending,
      };
}

class FeatureRequest {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;
  final List<String> upvoterIds;
  final List<String> downvoterIds;
  final FeatureRequestStatus status;

  FeatureRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    List<String>? upvoterIds,
    List<String>? downvoterIds,
    this.status = FeatureRequestStatus.pending,
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
      upvoterIds: List<String>.from(data['upvoterIds'] ?? []),
      downvoterIds: List<String>.from(data['downvoterIds'] ?? []),
      status: FeatureRequestStatus.fromString(data['status'] ?? ''),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'upvoterIds': upvoterIds,
      'downvoterIds': downvoterIds,
      'status': status.displayText,
    };
  }

  FeatureRequest copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    FeatureRequestStatus? status,
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
      upvoterIds: upvoterIds ?? this.upvoterIds,
      downvoterIds: downvoterIds ?? this.downvoterIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
