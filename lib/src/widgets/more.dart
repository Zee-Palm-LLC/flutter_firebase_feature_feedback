import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:provider/provider.dart';

class FeatureMoreCardButton extends StatelessWidget {
  final FeatureRequest feature;
  const FeatureMoreCardButton({required this.feature, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert_rounded),
      onPressed: () => showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * .5,
        ),
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<FeatureFeedbackProvider>(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Change the Status:',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(.5),
                      ),
                ),
                const SizedBox(height: 12),
                ...FeatureRequestStatus.values.map(
                  (status) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: status == feature.status ? status.color.withOpacity(.1) : null,
                    ),
                    child: PopupMenuItem(
                      value: status,
                      onTap: () => context.read<FeatureFeedbackProvider>().updateStatus(
                            featureId: feature.id,
                            status: status.name,
                          ),
                      child: Text(
                        '${status.name[0].toUpperCase()}${status.name.substring(1)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
