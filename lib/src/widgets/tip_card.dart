import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Transform.flip(
              flipY: true,
              child: Icon(
                Icons.wb_incandescent_outlined,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Vote on the features that you like, so we can implement them faster.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
