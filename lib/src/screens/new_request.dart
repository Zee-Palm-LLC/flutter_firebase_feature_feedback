import 'package:flutter/material.dart';
import 'package:flutter_firebase_feature_feedback/src/providers/feature_feedback_provider.dart';
import 'package:flutter_firebase_feature_feedback/src/screens/sent.dart';
import 'package:flutter_firebase_feature_feedback/src/widgets/styled_text_field.dart';
import 'package:provider/provider.dart';

class NewFeatureRequestScreen extends StatefulWidget {
  final String userId;
  const NewFeatureRequestScreen({required this.userId, super.key});

  @override
  State<NewFeatureRequestScreen> createState() => FormViewState();
}

class FormViewState extends State<NewFeatureRequestScreen> {
  late final TextEditingController titleController = TextEditingController();
  late final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('New Feature Request'),
        actions: [
          IconButton(
            icon: Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        spacing: 12,
        children: [
          StyledTextField(
            controller: titleController,
            minLines: 1,
            hintText: 'Feature title',
            autoFocus: true,
            title: true,
          ),
          Expanded(
            child: StyledTextField(
              controller: descriptionController,
              minLines: 7,
              hintText: 'Describe your idea...',
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              child: Text('Submit'),
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  context.read<FeatureFeedbackProvider>().addFeatureRequest(
                        title: titleController.text,
                        description: descriptionController.text,
                        userId: widget.userId,
                      );
                  Navigator.pop(context);
                  showGeneralDialog(
                    context: context,
                    transitionDuration: kThemeAnimationDuration,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const FeatureRequestSuccessErrorScreen(isSuccess: true);
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
