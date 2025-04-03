import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/screens/new_request.dart';
import 'package:provider/provider.dart';

class NewFeatureButton extends StatelessWidget {
  final String userId;
  const NewFeatureButton({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16).copyWith(
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
            offset: Offset(0, 0),
            blurRadius: 24,
          ),
        ],
      ),
      child: FilledButton.icon(
        label: Text('New Feature'),
        icon: Icon(Icons.border_color_rounded),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<FeatureFeedbackProvider>(),
              child: NewFeatureRequestScreen(userId: userId),
            ),
          ),
        ),
      ),
    );
  }
}
