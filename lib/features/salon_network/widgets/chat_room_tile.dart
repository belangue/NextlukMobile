import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final VoidCallback? onTap;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: chatRoom.hairdresserImageUrl.isNotEmpty
            ? NetworkImage(chatRoom.hairdresserImageUrl)
            : null,
        child: chatRoom.hairdresserImageUrl.isEmpty
            ? Text(
                chatRoom.hairdresserName.isNotEmpty
                    ? chatRoom.hairdresserName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        chatRoom.hairdresserName,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chatRoom.salonName != null && chatRoom.salonName!.isNotEmpty)
            Text(
              chatRoom.salonName!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          const SizedBox(height: 2),
          Text(
            chatRoom.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: chatRoom.unreadCount > 0
                  ? Theme.of(context).textTheme.bodyLarge?.color
                  : Colors.grey[600],
              fontWeight: chatRoom.unreadCount > 0
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(chatRoom.lastMessageTime),
            style: TextStyle(
              fontSize: 12,
              color: chatRoom.unreadCount > 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey[500],
              fontWeight: chatRoom.unreadCount > 0
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
          if (chatRoom.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                chatRoom.unreadCount > 99
                    ? '99+'
                    : chatRoom.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${time.day}/${time.month}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Now';
    }
  }
}
