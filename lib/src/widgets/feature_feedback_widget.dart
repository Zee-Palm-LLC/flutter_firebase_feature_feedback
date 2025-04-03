import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/screens/sent.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_card.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/tip_card.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class FeatureFeedbackList extends StatelessWidget {
  final String userId;
  final String collectionPath;
  final bool isAdmin;

  const FeatureFeedbackList({
    required this.userId,
    required this.collectionPath,
    required this.isAdmin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FeatureFeedbackProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: Platform.isIOS ? const CupertinoActivityIndicator() : const CircularProgressIndicator(),
          );
        }

        if (provider.error != null) return FeatureRequestSuccessErrorScreen(isSuccess: false);

        return ListView.separated(
          padding: const EdgeInsets.all(16).copyWith(top: 8, bottom: 50),
          itemCount: provider.featureRequests.length + (provider.featureRequests.isEmpty ? 2 : 1),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const TipCard();
            }
            if (provider.featureRequests.isEmpty) {
              return Center(
                child: Text(
                  'Be the first to suggest a new Feature!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            final request = provider.featureRequests[index - 1];
            return FeatureCard(
              feature: request,
              userId: userId,
              isAdmin: isAdmin,
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: index == 0 ? 12 : 8),
        );
      },
    );
  }
}
