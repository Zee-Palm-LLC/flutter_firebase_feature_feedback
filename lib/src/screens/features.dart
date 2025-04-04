import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/services/feature_feedback_service.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_label.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_list.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/new_feature_button.dart';
import 'package:provider/provider.dart';

class FeaturesBoardScreen extends StatelessWidget {
  final String userId;
  final String collectionPath;
  final bool isAdmin;
  const FeaturesBoardScreen({
    required this.userId,
    this.collectionPath = 'feature_requests',
    this.isAdmin = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeatureFeedbackProvider(
        FeatureFeedbackService(collectionPath: collectionPath),
      ),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: Theme.of(context).colorScheme.surface,
            title: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Features Board',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 12),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: FeatureRequestStatus.values
                      .map(
                        (status) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: FeatureLabel(
                            status: status,
                            isSelected: context.watch<FeatureFeedbackProvider>().selectedStatus == status,
                            onSelected: () => context.read<FeatureFeedbackProvider>().setSelectedStatus(status),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: FeatureFeedbackList(
                  userId: userId,
                  collectionPath: collectionPath,
                  isAdmin: isAdmin,
                ),
              ),
              NewFeatureButton(userId: userId),
            ],
          ),
        );
      },
    );
  }
}
