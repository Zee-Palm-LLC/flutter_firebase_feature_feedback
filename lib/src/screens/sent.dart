import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';

class FeatureRequestSuccessErrorScreen extends StatelessWidget {
  final bool isSuccess;
  const FeatureRequestSuccessErrorScreen({required this.isSuccess, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Icon(
                      isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                      size: 60,
                      color: isSuccess ? FeatureRequestStatus.implemented.color : Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isSuccess ? 'Feature Request Sent' : 'Something happened 🫠',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      isSuccess
                          ? 'Your feature has been added to the list. If it gets lots of votes, it will be implemented.'
                          : 'We are not sure what happened. Please try again later or contact support.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              child: Text('Go back'),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
