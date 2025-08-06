import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../providers/salon_network_provider.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<SalonNetworkProvider>(context, listen: false);
      provider.loadChatMessages(widget.chatRoom.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<SalonNetworkProvider>(
              builder: (context, provider, child) {
                if (provider.isNetworkLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${provider.error}'),
                        ElevatedButton(
                          onPressed: () =>
                              provider.loadChatMessages(widget.chatRoom.id),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return ChatMessageWidget(
                      message: message,
                      isCurrentUser: message.isFromUser,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputBar(
            messageController: _messageController,
            onSend: (content, messageType) =>
                _sendMessage(content, messageType),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: widget.chatRoom.hairdresserImageUrl.isNotEmpty
                ? NetworkImage(widget.chatRoom.hairdresserImageUrl)
                : null,
            child: widget.chatRoom.hairdresserImageUrl.isEmpty
                ? Text(
                    widget.chatRoom.hairdresserName.isNotEmpty
                        ? widget.chatRoom.hairdresserName[0].toUpperCase()
                        : '?',
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatRoom.hairdresserName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (widget.chatRoom.salonName != null &&
                    widget.chatRoom.salonName!.isNotEmpty)
                  Text(
                    widget.chatRoom.salonName!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {
            // Handle call action
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // Handle more options
          },
        ),
      ],
    );
  }

  void _sendMessage(String content, dynamic messageType) {
    final trimmedContent = content.trim();
    if (trimmedContent.isNotEmpty) {
      final provider =
          Provider.of<SalonNetworkProvider>(context, listen: false);
      provider.sendTextMessage(widget.chatRoom.id, trimmedContent);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
