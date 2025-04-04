import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_card_buttons.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_label.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/more.dart';

class FeatureCard extends StatelessWidget {
  final FeatureRequest feature;
  final String userId;
  final bool isAdmin;
  const FeatureCard({required this.feature, required this.userId, required this.isAdmin, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(feature.id),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Column(
            spacing: 4,
            children: [
              FeatureUpVoteButton(
                featureId: feature.id,
                userId: userId,
                votes: feature.upvoterIds.length,
                userVoted: feature.upvoterIds.contains(userId),
                isCompleted: feature.status == FeatureRequestStatus.implemented,
              ),
              if (feature.status != FeatureRequestStatus.implemented)
                FeatureUpVoteButton(
                  featureId: feature.id,
                  userId: userId,
                  isUpVotes: false,
                  votes: feature.downvoterIds.length,
                  userVoted: feature.downvoterIds.contains(userId),
                ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feature.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    if (isAdmin) FeatureMoreCardButton(feature: feature)
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                FeatureLabel(
                  status: feature.status,
                  isSelected: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
