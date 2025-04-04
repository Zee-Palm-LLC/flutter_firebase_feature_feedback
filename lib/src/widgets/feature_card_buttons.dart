import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/models/feature_request.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:provider/provider.dart';

class FeatureUpVoteButton extends StatelessWidget {
  final String featureId;
  final String userId;
  final int votes;
  final bool userVoted;
  final bool isUpVotes;
  final bool isCompleted;
  const FeatureUpVoteButton({
    required this.featureId,
    required this.userId,
    required this.votes,
    required this.userVoted,
    this.isUpVotes = true,
    this.isCompleted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final votesButton = [
      Icon(
        isUpVotes ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
        size: 24,
        color: userVoted ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
      ),
      Text(
        votes.toString(),
        maxLines: 1,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              height: 1,
              color: userVoted ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurface,
            ),
      ),
      const SizedBox(height: 8),
    ];

    return GestureDetector(
      onTap: () => context.read<FeatureFeedbackProvider>().updateVote(
            featureId: featureId,
            userId: userId,
            isUpvote: isUpVotes,
          ),
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        height: 56,
        width: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isCompleted
              ? FeatureRequestStatus.implemented.color.withOpacity(.1)
              : userVoted
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.surfaceBright,
        ),
        child: isCompleted
            ? Icon(
                size: 28,
                Icons.check_circle_rounded,
                color: FeatureRequestStatus.implemented.color,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isUpVotes ? votesButton : votesButton.reversed.toList(),
              ),
      ),
    );
  }
}
