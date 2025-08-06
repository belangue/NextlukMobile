// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'features/analysis/providers/analysis_provider.dart';
// import 'features/analysis/screens/home_screen.dart';
// import 'features/salon_network/screens/chat_screen.dart';
// import 'features/salon_network/screens/salon_network_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AnalysisProvider()),
//       ],
//       child: MaterialApp(
//         title: 'NextLuk Mobile',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color(0xFF6B73FF),
//             brightness: Brightness.light,
//           ),
//           useMaterial3: true,
//           fontFamily: 'Poppins', // Will fallback to system font if not available
//         ),
//         // Fixed: Use proper routing structure
//         initialRoute: '/',
//         routes: {
//           '/': (context) => const MainNavigationScreen(), // Main screen with bottom navigation
//           '/chat': (context) => const ChatScreen(),
//           '/salon-network': (context) => const SalonNetworkScreen(),
//           '/home': (context) => const HomeScreen(),
//         },
//       ),
//     );
//   }
// }

// // Main Navigation Screen with Bottom Navigation Bar
// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   // List of screens for bottom navigation
//   late final List<Widget> _screens;

//   @override
//   void initState() {
//     super.initState();
//     _screens = [
//       const HomeScreen(), // Your existing home screen (analysis)
//       const SalonNetworkScreen(), // Your salon network screen
//       const ChatScreen(), // Your chat screen
//       const ProfileScreen(), // Profile screen
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF6B73FF),
//         unselectedItemColor: Colors.grey,
//         elevation: 8,
//         backgroundColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people_outline_rounded),
//             activeIcon: Icon(Icons.people_rounded),
//             label: 'Network',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat_bubble_outline_rounded),
//             activeIcon: Icon(Icons.chat_bubble_rounded),
//             label: 'Chat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline_rounded),
//             activeIcon: Icon(Icons.person_rounded),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Simple Profile Screen (add this if you don't have one)
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         backgroundColor: const Color(0xFF6B73FF),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6B73FF),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF6B73FF).withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.person_rounded,
//                 size: 50,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Your Profile',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2D3748),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Manage your account settings',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 32),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 children: [
//                   _buildProfileOption(
//                     icon: Icons.settings_rounded,
//                     title: 'Settings',
//                     onTap: () {},
//                   ),
//                   _buildProfileOption(
//                     icon: Icons.favorite_rounded,
//                     title: 'Favorites',
//                     onTap: () {},
//                   ),
//                   _buildProfileOption(
//                     icon: Icons.history_rounded,
//                     title: 'History',
//                     onTap: () {},
//                   ),
//                   _buildProfileOption(
//                     icon: Icons.help_rounded,
//                     title

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/analysis/providers/analysis_provider.dart';
import 'features/analysis/screens/home_screen.dart';
//import 'features/analysis/screens/analysis_screen.dart'; // Commented out - file doesn't exist
//import 'features/salon_network/screens/chat_screen.dart';
import 'features/salon_network/screens/salon_network_screen.dart';
// import 'features/salon_network/providers/salon_network_provider.dart'; // Commented out if it doesn't exist

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
        // ChangeNotifierProvider(create: (_) => SalonNetworkProvider()), // Commented out if provider doesn't exist
      ],
      child: MaterialApp(
        title: 'NextLuk Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B73FF),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MainNavigationScreen(),
          '/chat': (context) {
            final chatRoomId =
                ModalRoute.of(context)?.settings.arguments as String?;
            return ChatScreen(chatRoomId: chatRoomId ?? 'default');
          },
          '/salon-network': (context) =>
              const SalonNetworkScreen(), // Removed const
          '/home': (context) => const HomeScreen(),
          // '/analysis': (context) => const AnalysisScreen(), // Commented out - class doesn't exist
        },
      ),
    );
  }
}

// Main Navigation Screen with Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // List of screens for bottom navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const SalonNetworkScreen(), // Removed const
      const ChatScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF6B73FF),
        unselectedItemColor: Colors.grey,
        elevation: 8,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Default ChatScreen for bottom navigation (without chatRoomId requirement)
class ChatScreen extends StatelessWidget {
  final String? chatRoomId;

  const ChatScreen({super.key, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              chatRoomId != null
                  ? 'Chat Room: $chatRoomId'
                  : 'Select a chat room to start messaging',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/salon-network');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Browse Salon Network'),
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF6B73FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your account settings',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.favorite_rounded,
                    title: 'Favorites',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.history_rounded,
                    title: 'History',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B73FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF6B73FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
