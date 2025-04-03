import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/services/feature_feedback_service.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/feature_feedback_widget.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/new_feature_button.dart';
import 'package:provider/provider.dart';

//! Need to add the filtering by status and it is done
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
            title: Padding(
              padding: const EdgeInsets.only(left: 4.0),
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
