// import 'package:flutter/material.dart';
// import '../../analysis/models/chat_message_model.dart';

// class ChatInputBar extends StatefulWidget {
//   final Function(String, MessageType) onSendMessage;

//   const ChatInputBar({
//     super.key,
//     required this.onSendMessage,
//   });

//   @override
//   State<ChatInputBar> createState() => _ChatInputBarState();
// }

// class _ChatInputBarState extends State<ChatInputBar> {
//   final TextEditingController _messageController = TextEditingController();
//   bool _isComposing = false;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             // Attachment button
//             IconButton(
//               onPressed: _showAttachmentOptions,
//               icon: Icon(
//                 Icons.attach_file_rounded,
//                 color: Colors.grey[600],
//               ),
//             ),

//             // Text input
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: TextField(
//                   controller: _messageController,
//                   onChanged: (text) {
//                     setState(() {
//                       _isComposing = text.trim().isNotEmpty;
//                     });
//                   },
//                   onSubmitted: (_) => _sendMessage(),
//                   decoration: const InputDecoration(
//                     hintText: 'Type a message...',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                   maxLines: null,
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//             ),

//             const SizedBox(width: 8),

//             // Send button
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               child: FloatingActionButton(
//                 mini: true,
//                 backgroundColor: _isComposing ? const Color(0xFF6B73FF) : Colors.grey[400],
//                 elevation: 0,
//                 onPressed: _isComposing ? _sendMessage : null,
//                 child: Icon(
//                   _isComposing ? Icons.send_rounded : Icons.mic_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isNotEmpty) {
//       widget.onSendMessage(text, MessageType.text);
//       _messageController.clear();
//       setState(() {
//         _isComposing = false;
//       });
//     }
//   }

//   void _showAttachmentOptions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Send Attachment',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildAttachmentOption(
//                   icon: Icons.photo_library_rounded,
//                   label: 'Gallery',
//                   color: Colors.purple,
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Handle gallery selection
//                   },
//                 ),
//                 _buildAttachmentOption(
//                   icon: Icons.camera_alt_rounded,
//                   label: 'Camera',
//                   color: Colors.blue,
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Handle camera
//                   },
//                 ),
//                 _buildAttachmentOption(
//                   icon: Icons.insert_drive_file_rounded,
//                   label: 'Document',
//                   color: Colors.orange,
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Handle document
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAttachmentOption({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 28,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatInputBar extends StatelessWidget {
  final Function(String, MessageType) onSend;
  final TextEditingController messageController;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.messageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              onSend(messageController.text, MessageType.text);
            },
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
