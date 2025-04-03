// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_firebase_feature_feedback/flutter_firebase_feature_feedback.dart';
// import 'package:provider/provider.dart';

// void showAddFeatureSheet(BuildContext context) {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final provider = context.read<FeatureFeedbackProvider>();

//   if (Platform.isIOS) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         title: const Text('Request New Feature'),
//         message: const Text('Share your ideas to help improve the app'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 CupertinoTextField(
//                   controller: titleController,
//                   placeholder: 'Feature title',
//                   padding: const EdgeInsets.all(12),
//                   style: TextStyle(color: textColor),
//                 ),
//                 const SizedBox(height: 16),
//                 CupertinoTextField(
//                   controller: descriptionController,
//                   placeholder: 'Describe the feature you would like to see',
//                   padding: const EdgeInsets.all(12),
//                   maxLines: 4,
//                   style: TextStyle(color: textColor),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             ),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
//                 provider.addFeatureRequest(
//                   title: titleController.text,
//                   description: descriptionController.text,
//                   userId: userId,
//                 );
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text('Submit'),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           onPressed: () => Navigator.pop(context),
//           isDestructiveAction: true,
//           child: const Text('Cancel'),
//         ),
//       ),
//     );
//   } else {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Request New Feature',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: textColor,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Share your ideas to help improve the app',
//                 style: TextStyle(color: textColor.withAlpha(153)),
//               ),
//               const SizedBox(height: 24),
//               TextField(
//                 controller: titleController,
//                 decoration: InputDecoration(
//                   labelText: 'Feature title',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                   labelText: 'Describe the feature you would like to see',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 maxLines: 4,
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Cancel',
//                       style: TextStyle(color: textColor.withAlpha(153)),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
//                         provider.addFeatureRequest(
//                           title: titleController.text,
//                           description: descriptionController.text,
//                           userId: userId,
//                         );
//                         Navigator.pop(context);
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Submit'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
