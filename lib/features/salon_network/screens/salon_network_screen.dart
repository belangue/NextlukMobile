// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../providers/salon_network_provider.dart';
// import '../widgets/salon_card.dart';
// import '../widgets/hairdresser_card.dart';
// import '../widgets/hairstyle_post_card.dart';
// import '../widgets/search_filter_bar.dart';
// import '../../core/theme/app_theme.dart';

// class SalonNetworkScreen extends StatefulWidget {
//   const SalonNetworkScreen({Key? key}) : super(key: key);

//   @override
//   State<SalonNetworkScreen> createState() => _SalonNetworkScreenState();
// }

// class _SalonNetworkScreenState extends State<SalonNetworkScreen> with TickerProviderStateMixin {
//   late TabController _tabController;
//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _initializeData();
//   }

//   void _initializeData() async {
//     // Get user location (implement location service)
//     const double userLat = 3.8480; // Yaoundé coordinates
//     const double userLng = 11.5021;

//     await context.read<SalonNetworkProvider>().initialize(userLat, userLng);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildTabBar(),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildHairstylesTab(),
//                 _buildSalonsTab(),
//                 _buildHairdressersTab(),
//                 _buildMapTab(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
//       decoration: BoxDecoration(
//         gradient: AppTheme.primaryGradient,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               const Icon(Icons.location_on, color: Colors.white, size: 20),
//               const SizedBox(width: 8),
//               const Text(
//                 'Yaoundé, Cameroun',
//                 style: TextStyle(color: Colors.white70, fontSize: 14),
//               ),
//               const Spacer(),
//               IconButton(
//                 onPressed: () => _showNotifications(),
//                 icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//               ),
//               IconButton(
//                 onPressed: () => _showChatList(),
//                 icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Découvrez les Meilleurs Salons',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Trouvez votre coiffeur idéal près de chez vous',
//             style: TextStyle(color: Colors.white70, fontSize: 16),
//           ),
//           const SizedBox(height: 20),
//           const SearchFilterBar(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: TabBar(
//         controller: _tabController,
//         indicator: BoxDecoration(
//           gradient: AppTheme.primaryGradient,
//           borderRadius: BorderRadius.circular(25),
//         ),
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey[600],
//         labelStyle: const TextStyle(fontWeight: FontWeight.w600),
//         tabs: const [
//           Tab(text: 'Styles'),
//           Tab(text: 'Salons'),
//           Tab(text: 'Coiffeurs'),
//           Tab(text: 'Carte'),
//         ],
//       ),
//     );
//   }

//   Widget _buildHairstylesTab() {
//     return Consumer<SalonNetworkProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (provider.error != null) {
//           return _buildErrorWidget(provider.error!);
//         }

//         return RefreshIndicator(
//           onRefresh: () => provider.loadHairstyleFeed(),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: provider.hairstyleFeed.length,
//             itemBuilder: (context, index) {
//               return HairstylePostCard(
//                 post: provider.hairstyleFeed[index],
//                 onLike: () => provider.likePost(provider.hairstyleFeed[index].id),
//                 onSave: () => provider.savePost(provider.hairstyleFeed[index].id),
//                 onComment: () => _showComments(provider.hairstyleFeed[index]),
//                 onShare: () => _sharePost(provider.hairstyleFeed[index]),
//                 onTryOn: () => _tryOnHairstyle(provider.hairstyleFeed[index]),
//                 onContactHairdresser: () => _contactHairdresser(provider.hairstyleFeed[index].hairdresserId),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSalonsTab() {
//     return Consumer<SalonNetworkProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (provider.error != null) {
//           return _buildErrorWidget(provider.error!);
//         }

//         return RefreshIndicator(
//           onRefresh: () => provider.loadNearbySalons(3.8480, 11.5021),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: provider.nearbySalons.length,
//             itemBuilder: (context, index) {
//               return SalonCard(
//                 salon: provider.nearbySalons[index],
//                 onTap: () => _showSalonDetails(provider.nearbySalons[index]),
//                 onCall: () => _callSalon(provider.nearbySalons[index]),
//                 onDirection: () => _getDirections(provider.nearbySalons[index]),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHairdressersTab() {
//     return Consumer<SalonNetworkProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (provider.error != null) {
//           return _buildErrorWidget(provider.error!);
//         }

//         return RefreshIndicator(
//           onRefresh: () => provider.loadFeaturedHairdressers(),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: provider.featuredHairdressers.length,
//             itemBuilder: (context, index) {
//               return HairdresserCard(
//                 hairdresser: provider.featuredHairdressers[index],
//                 onTap: () => _showHairdresserProfile(provider.featuredHairdressers[index]),
//                 onChat: () => _startChat(provider.featuredHairdressers[index]),
//                 onBook: () => _bookAppointment(provider.featuredHairdressers[index]),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMapTab() {
//     return Consumer<SalonNetworkProvider>(
//       builder: (context, provider, child) {
//         return GoogleMap(
//           initialCameraPosition: const CameraPosition(
//             target: LatLng(3.8480, 11.5021), // Yaoundé
//             zoom: 12,
//           ),
//           onMapCreated: (GoogleMapController controller) {
//             _mapController = controller;
//           },
//           markers: _buildMapMarkers(provider.nearbySalons),
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//         );
//       },
//     );
//   }

//   Set<Marker> _buildMapMarkers(List<Salon> salons) {
//     return salons.map((salon) {
//       return Marker(
//         markerId: MarkerId(salon.id),
//         position: LatLng(salon.latitude, salon.longitude),
//         infoWindow: InfoWindow(
//           title: salon.name,
//           snippet: '${salon.rating} ⭐ • ${salon.services.take(2).join(', ')}',
//           onTap: () => _showSalonDetails(salon),
//         ),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//       );
//     }).toSet();
//   }

//   Widget _buildErrorWidget(String error) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.grey),
//           const SizedBox(height: 16),
//           Text(
//             'Une erreur s\'est produite',
//             style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             error,
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () => _initializeData(),
//             child: const Text('Réessayer'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Action methods
//   void _showNotifications() {
//     // Navigate to notifications screen
//   }

//   void _showChatList() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChatListScreen()),
//     );
//   }

//   void _showComments(HairstylePost post) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => CommentsBottomSheet(post: post),
//     );
//   }

//   void _sharePost(HairstylePost post) {
//     // Implement share functionality
//   }

//   void _tryOnHairstyle(HairstylePost post) {
//     // Navigate to AR try-on screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HairstyleTryOnScreen(post: post),
//       ),
//     );
//   }

//   void _contactHairdresser(String hairdresserId) {
//     context.read<SalonNetworkProvider>().startChat(hairdresserId);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChatScreen()),
//     );
//   }

//   void _showSalonDetails(Salon salon) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SalonDetailsScreen(salon: salon),
//       ),
//     );
//   }

//   void _callSalon(Salon salon) {
//     // Implement phone call functionality
//   }

//   void _getDirections(Salon salon) {
//     // Implement navigation to salon
//   }

//   void _showHairdresserProfile(Hairdresser hairdresser) {
//     Navigator.push(
//       context,
//       MaterialPageReference(
//         builder: (context) => HairdresserProfileScreen(hairdresser: hairdresser),
//       ),
//     );
//   }

//   void _startChat(Hairdresser hairdresser) {
//     context.read<SalonNetworkProvider>().startChat(hairdresser.id);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChatScreen()),
//     );
//   }

//   void _bookAppointment(Hairdresser hairdresser) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => BookingBottomSheet(hairdresser: hairdresser),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
// }

// SALON_NETWORK_SCREEN.dart - Example template
import 'package:flutter/material.dart';

class SalonNetworkScreen extends StatefulWidget {
  const SalonNetworkScreen({super.key});

  @override
  _SalonNetworkScreenState createState() => _SalonNetworkScreenState();
}

class _SalonNetworkScreenState extends State<SalonNetworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salon Network'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search hairstyles...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Categories
          const Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Cuts'),
                _buildCategoryChip('Colors'),
                _buildCategoryChip('Styling'),
                _buildCategoryChip('Treatments'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Posts section
          const Text(
            'Latest Posts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Here you would use your HairstylePostCard widgets
          _buildSamplePost(),
          _buildSamplePost(),
          _buildSamplePost(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new post functionality
          _showAddPostDialog();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.purple[100],
        labelStyle: TextStyle(color: Colors.purple[800]),
      ),
    );
  }

  Widget _buildSamplePost() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text('Hair Stylist Name'),
            subtitle: const Text('Salon Name'),
            trailing: Chip(
              label: const Text('Cuts'),
              backgroundColor: Colors.orange[100],
            ),
          ),

          // Image placeholder
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 50, color: Colors.grey[500]),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amazing New Haircut Style',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is a description of the hairstyle post...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Post'),
        content: const Text('Add new post functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// CHAT_SCREEN.dart - Example template
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I help you today?',
      'isMe': false,
      'time': '10:30 AM',
    },
    {
      'text': 'Hi! I\'d like to book an appointment.',
      'isMe': true,
      'time': '10:32 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(
                  message['text'],
                  message['isMe'],
                  message['time'],
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.purple,
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? Colors.purple : Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: isMe ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[400],
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time':
              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        });
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
