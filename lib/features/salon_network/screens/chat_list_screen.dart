// // File: lib/features/salon_network/screens/chat_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/salon_network_provider.dart';
// import '../widgets/chat_room_tile.dart';

// class ChatListScreen extends StatefulWidget {
//   const ChatListScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SalonNetworkProvider>().loadChatRooms();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           'Messages',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: _searchChats,
//             icon: const Icon(Icons.search, color: Colors.black87),
//           ),
//         ],
//       ),
//       body: Consumer<SalonNetworkProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (provider.chatRooms.isEmpty) {
//             return _buildEmptyState();
//           }

//           return RefreshIndicator(
//             onRefresh: () => provider.loadChatRooms(),
//             child: ListView.builder(
//               itemCount: provider.chatRooms.length,
//               itemBuilder: (context, index) {
//                 final chatRoom = provider.chatRooms[index];
//                 return ChatRoomTile(
//                   chatRoom: chatRoom,
//                   onTap: () => _openChat(chatRoom.id),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
//           SizedBox(height: 16),
//           Text(
//             'Aucune conversation',
//             style: TextStyle(fontSize: 18, color: Colors.grey),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Commencez à discuter avec vos coiffeurs préférés',
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   void _searchChats() {
//     // Implement chat search functionality
//   }

//   void _openChat(String chatRoomId) {
//     context.read<SalonNetworkProvider>().loadChatMessages(chatRoomId);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChatScreen()),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/salon_network_provider.dart';
import '../widgets/chat_room_tile.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<SalonNetworkProvider>(context, listen: false);
      provider.loadChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Consumer<SalonNetworkProvider>(
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadChatRooms(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.chatRooms.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start a conversation with a hairdresser',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadChatRooms(),
            child: ListView.builder(
              itemCount: provider.chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = provider.chatRooms[index];
                return ChatRoomTile(
                  chatRoom: chatRoom,
                  onTap: () {
                    // Load messages before navigating
                    provider.loadChatMessages(chatRoom.id);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(chatRoom: chatRoom),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new chat creation
          _showNewChatDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Chat'),
        content: const Text('Choose a hairdresser to start chatting with'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to hairdresser selection screen
            },
            child: const Text('Choose Hairdresser'),
          ),
        ],
      ),
    );
  }
}
