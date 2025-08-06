// File: lib/shared/services/salon_network_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../features/salon_network/models/hairdresser_model.dart';
import '../../features/salon_network/models/hairstyle_post_model.dart';
import '../../features/salon_network/models/chat_model.dart';

class SalonNetworkService {
  static const String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API URL
  
  // HTTP client for making requests
  final http.Client _client = http.Client();

  // Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add authorization headers if needed
    // 'Authorization': 'Bearer $token',
  };

  // Get all hairdressers
  Future<List<Hairdresser>> getHairdressers() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/hairdressers'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Hairdresser.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hairdressers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all hairstyle posts
  Future<List<HairstylePost>> getHairstylePosts() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/hairstyle-posts'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HairstylePost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hairstyle posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all chat rooms
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/chat-rooms'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatRoom.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get messages for a specific chat room
  Future<List<ChatMessage>> getChatMessages(String chatRoomId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/chat-rooms/$chatRoomId/messages'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chat messages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Send a message
  Future<ChatMessage> sendMessage(String chatRoomId, String content, MessageType type) async {
    try {
      final body = json.encode({
        'content': content,
        'type': type.toString().split('.').last, // Convert enum to string
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _client.post(
        Uri.parse('$baseUrl/chat-rooms/$chatRoomId/messages'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatMessage.fromJson(data);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get hairdresser by ID
  Future<Hairdresser> getHairdresser(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/hairdressers/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Hairdresser.fromJson(data);
      } else {
        throw Exception('Failed to load hairdresser: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get hairstyle post by ID
  Future<HairstylePost> getHairstylePost(String id) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/hairstyle-posts/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HairstylePost.fromJson(data);
      } else {
        throw Exception('Failed to load hairstyle post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Like a hairstyle post
  Future<void> likePost(String postId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/hairstyle-posts/$postId/like'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to like post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Comment on a hairstyle post
  Future<void> commentOnPost(String postId, String comment) async {
    try {
      final body = json.encode({'comment': comment});
      
      final response = await _client.post(
        Uri.parse('$baseUrl/hairstyle-posts/$postId/comments'),
        headers: _headers,
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to comment on post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Clean up resources
  void dispose() {
    _client.close();
  }
}

// If you're not using a real API yet, you can use this mock version instead:
/*
class SalonNetworkService {
  // Mock data for testing
  Future<List<Hairdresser>> getHairdressers() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      // Add mock hairdresser data here
    ];
  }

  Future<List<HairstylePost>> getHairstylePosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      // Add mock hairstyle post data here
    ];
  }

  Future<List<ChatRoom>> getChatRooms() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      // Add mock chat room data here
    ];
  }

  Future<List<ChatMessage>> getChatMessages(String chatRoomId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      // Add mock chat message data here
    ];
  }

  Future<ChatMessage> sendMessage(String chatRoomId, String content, MessageType type) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
      timestamp: DateTime.now(),
      isFromUser: true,
    );
  }
}
*/