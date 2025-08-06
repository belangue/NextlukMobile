// import 'package:flutter/material.dart';
// import '../models/salon_model.dart';
// import '../models/hairdresser_model.dart';
// import '../models/hairstyle_post_model.dart';
// import 'features/salon_network/models/chat_model.dart';
// import '../services/salon_network_service.dart';

// class SalonNetworkProvider extends ChangeNotifier {
//   final SalonNetworkService _service = SalonNetworkService();

//   // State variables
//   List<Salon> _nearbySalons = [];
//   List<Hairdresser> _featuredHairdressers = [];
//   List<HairstylePost> _hairstyleFeed = [];
//   List<ChatRoom> _chatRooms = [];
//   List<ChatMessage> _currentChatMessages = [];

//   bool _isLoading = false;
//   bool _isChatLoading = false;
//   String? _error;

//   // Current selections
//   Salon? _selectedSalon;
//   Hairdresser? _selectedHairedresser;
//   HairstylePost? _selectedPost;
//   ChatRoom? _currentChatRoom;

//   // Filters
//   String _searchQuery = '';
//   List<String> _selectedServices = [];
//   double _maxDistance = 50.0;
//   String _sortBy = 'distance'; // distance, rating, price
//   List<String> _selectedHairTypes = [];
//   List<String> _selectedFaceShapes = [];

//   // Getters
//   List<Salon> get nearbySalons => _nearbySalons;
//   List<Hairdresser> get featuredHairdressers => _featuredHairdressers;
//   List<HairstylePost> get hairstyleFeed => _hairstyleFeed;
//   List<ChatRoom> get chatRooms => _chatRooms;
//   List<ChatMessage> get currentChatMessages => _currentChatMessages;

//   bool get isLoading => _isLoading;
//   bool get isChatLoading => _isChatLoading;
//   String? get error => _error;

//   Salon? get selectedSalon => _selectedSalon;
//   Hairdresser? get selectedHairedresser => _selectedHairedresser;
//   HairstylePost? get selectedPost => _selectedPost;
//   ChatRoom? get currentChatRoom => _currentChatRoom;

//   String get searchQuery => _searchQuery;
//   List<String> get selectedServices => _selectedServices;
//   double get maxDistance => _maxDistance;
//   String get sortBy => _sortBy;

//   // Initialize data
//   Future<void> initialize(double userLat, double userLng) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await Future.wait([
//         loadNearbySalons(userLat, userLng),
//         loadFeaturedHairdressers(),
//         loadHairstyleFeed(),
//         loadChatRooms(),
//       ]);
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Load nearby salons
//   Future<void> loadNearbySalons(double userLat, double userLng) async {
//     try {
//       _nearbySalons = await _service.getNearbySalons(
//         userLat,
//         userLng,
//         maxDistance: _maxDistance,
//         services: _selectedServices,
//         sortBy: _sortBy,
//       );
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Failed to load salons: $e');
//     }
//   }

//   // Load featured hairdressers
//   Future<void> loadFeaturedHairdressers() async {
//     try {
//       _featuredHairdressers = await _service.getFeaturedHairdressers();
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Failed to load hairdressers: $e');
//     }
//   }

//   // Load hairstyle feed
//   Future<void> loadHairstyleFeed() async {
//     try {
//       _hairstyleFeed = await _service.getHairstyleFeed(
//         hairTypes: _selectedHairTypes,
//         faceShapes: _selectedFaceShapes,
//         searchQuery: _searchQuery,
//       );
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Failed to load hairstyle feed: $e');
//     }
//   }

//   // Load chat rooms
//   Future<void> loadChatRooms() async {
//     try {
//       _chatRooms = await _service.getChatRooms();
//       notifyListeners();
//     } catch (e) {
//       throw Exception('Failed to load chat rooms: $e');
//     }
//   }

//   // Search functionality
//   void updateSearchQuery(String query) {
//     _searchQuery = query;
//     notifyListeners();
//     // Debounce search
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (_searchQuery == query) {
//         loadHairstyleFeed();
//       }
//     });
//   }

//   // Filter updates
//   void updateServiceFilters(List<String> services) {
//     _selectedServices = services;
//     notifyListeners();
//   }

//   void updateDistanceFilter(double distance) {
//     _maxDistance = distance;
//     notifyListeners();
//   }

//   void updateSortBy(String sortBy) {
//     _sortBy = sortBy;
//     notifyListeners();
//   }

//   void updateHairTypeFilters(List<String> hairTypes) {
//     _selectedHairTypes = hairTypes;
//     notifyListeners();
//   }

//   void updateFaceShapeFilters(List<String> faceShapes) {
//     _selectedFaceShapes = faceShapes;
//     notifyListeners();
//   }

//   // Selection methods
//   void selectSalon(Salon salon) {
//     _selectedSalon = salon;
//     notifyListeners();
//   }

//   void selectHairdresser(Hairdresser hairdresser) {
//     _selectedHairedresser = hairdresser;
//     notifyListeners();
//   }

//   void selectPost(HairstylePost post) {
//     _selectedPost = post;
//     notifyListeners();
//   }

//   // Post interactions
//   Future<void> likePost(String postId) async {
//     try {
//       await _service.likePost(postId);
//       // Update local state
//       int index = _hairstyleFeed.indexWhere((post) => post.id == postId);
//       if (index != -1) {
//         // Create updated post (would need to be implemented in model)
//         loadHairstyleFeed(); // Refresh for now
//       }
//     } catch (e) {
//       _error = 'Failed to like post: $e';
//       notifyListeners();
//     }
//   }

//   Future<void> savePost(String postId) async {
//     try {
//       await _service.savePost(postId);
//       loadHairstyleFeed(); // Refresh
//     } catch (e) {
//       _error = 'Failed to save post: $e';
//       notifyListeners();
//     }
//   }

//   Future<void> addComment(String postId, String content) async {
//     try {
//       await _service.addComment(postId, content);
//       loadHairstyleFeed(); // Refresh
//     } catch (e) {
//       _error = 'Failed to add comment: $e';
//       notifyListeners();
//     }
//   }

//   // Chat functionality
//   Future<void> startChat(String hairdresserId) async {
//     try {
//       _currentChatRoom = await _service.createOrGetChatRoom(hairdresserId);
//       await loadChatMessages(_currentChatRoom!.id);
//       notifyListeners();
//     } catch (e) {
//       _error = 'Failed to start chat: $e';
//       notifyListeners();
//     }
//   }

//   Future<void> loadChatMessages(String chatRoomId) async {
//     _isChatLoading = true;
//     notifyListeners();

//     try {
//       _currentChatMessages = await _service.getChatMessages(chatRoomId);
//     } catch (e) {
//       _error = 'Failed to load messages: $e';
//     } finally {
//       _isChatLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> sendMessage(String content, MessageType type, {String? attachmentUrl}) async {
//     if (_currentChatRoom == null) return;

//     try {
//       final message = await _service.sendMessage(
//         _currentChatRoom!.id,
//         content,
//         type,
//         attachmentUrl: attachmentUrl,
//       );
//       _currentChatMessages.add(message);
//       notifyListeners();
//     } catch (e) {
//       _error = 'Failed to send message: $e';
//       notifyListeners();
//     }
//   }

//   // Booking functionality
//   Future<void> requestBooking(String hairdresserId, String serviceType, DateTime preferredTime) async {
//     try {
//       await _service.requestBooking(hairdresserId, serviceType, preferredTime);
//       // Show success message or navigate
//     } catch (e) {
//       _error = 'Failed to request booking: $e';
//       notifyListeners();
//     }
//   }

//   // Clear selections
//   void clearSelections() {
//     _selectedSalon = null;
//     _selectedHairedresser = null;
//     _selectedPost = null;
//     _currentChatRoom = null;
//     _currentChatMessages.clear();
//     notifyListeners();
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import '../models/hairdresser_model.dart';
import '../models/hairstyle_post_model.dart';
import '../models/chat_model.dart'; // This imports ChatMessage and MessageType
import '/shared/services/salon_network_service.dart';

class SalonNetworkProvider with ChangeNotifier {
  final SalonNetworkService _service = SalonNetworkService();

  // Hairdressers
  List<Hairdresser> _hairdressers = [];
  bool _isLoading = false;
  String _error = '';

  // Hairstyle Posts
  List<HairstylePost> _posts = [];
  bool _isPostsLoading = false;

  // Chat
  List<ChatRoom> _chatRooms = [];
  List<ChatMessage> _messages = [];
  bool _isNetworkLoading = false;

  // Getters
  List<Hairdresser> get hairdressers => _hairdressers;
  List<HairstylePost> get posts => _posts;
  List<ChatRoom> get chatRooms => _chatRooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isPostsLoading => _isPostsLoading;
  bool get isNetworkLoading => _isNetworkLoading;
  String get error => _error;

  // Load hairdressers
  Future<void> loadHairdressers() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _hairdressers = await _service.getHairdressers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load hairstyle posts
  Future<void> loadPosts() async {
    _isPostsLoading = true;
    _error = '';
    notifyListeners();

    try {
      _posts = await _service.getHairstylePosts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isPostsLoading = false;
      notifyListeners();
    }
  }

  // Load chat rooms
  Future<void> loadChatRooms() async {
    _isNetworkLoading = true;
    _error = '';
    notifyListeners();

    try {
      _chatRooms = await _service.getChatRooms();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isNetworkLoading = false;
      notifyListeners();
    }
  }

  // Load chat messages
  Future<void> loadChatMessages(String chatRoomId) async {
    _isNetworkLoading = true;
    _error = '';
    notifyListeners();

    try {
      _messages = await _service.getChatMessages(chatRoomId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isNetworkLoading = false;
      notifyListeners();
    }
  }

  // Send message
  Future<void> sendMessage(
      String chatRoomId, String content, MessageType type) async {
    try {
      final message = await _service.sendMessage(chatRoomId, content, type);
      _messages.add(message);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add text message
  Future<void> sendTextMessage(String chatRoomId, String content) async {
    await sendMessage(chatRoomId, content, MessageType.text);
  }

  // Add image message
  Future<void> sendImageMessage(String chatRoomId, String imageUrl) async {
    await sendMessage(chatRoomId, 'Image', MessageType.image);
  }

  // Add appointment message
  Future<void> sendAppointmentMessage(
      String chatRoomId, String appointmentDetails) async {
    await sendMessage(chatRoomId, appointmentDetails, MessageType.appointment);
  }

  // Add system message
  Future<void> sendSystemMessage(
      String chatRoomId, String systemMessage) async {
    await sendMessage(chatRoomId, systemMessage, MessageType.system);
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
