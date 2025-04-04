import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';

class FeatureLabel extends StatelessWidget {
  final FeatureRequestStatus status;
  final Function()? onSelected;
  final bool isSelected;
  const FeatureLabel({
    required this.status,
    required this.isSelected,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      FeatureRequestStatus.implemented when onSelected == null => const SizedBox.shrink(),
      _ => FilterChip(
        label: Text(
          status.displayText,
          maxLines: 1,
        ),
        showCheckmark: false,
        labelStyle: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: isSelected ? status.color : Theme.of(context).colorScheme.onSurface.withOpacity(.7)),
        selectedColor: status.color.withOpacity(.1),
        selected: isSelected,
        onSelected: (_) => onSelected?.call(),
      ),
    };
  }
}
