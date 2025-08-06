enum MessageType {
  text,
  image,
  appointment,
  system,
}

class ChatRoom {
  final String id;
  final String hairdresserId;
  final String hairdresserName;
  final String hairdresserImageUrl; // This was missing in your model
  final String? salonName; // Add this if needed
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.hairdresserId,
    required this.hairdresserName,
    required this.hairdresserImageUrl,
    this.salonName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  // Add these getters for backward compatibility
  String get hairdresserImage => hairdresserImageUrl;

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? '',
      hairdresserId: json['hairdresserId'] ?? '',
      hairdresserName: json['hairdresserName'] ?? '',
      hairdresserImageUrl:
          json['hairdresserImageUrl'] ?? json['hairdresserImage'] ?? '',
      salonName: json['salonName'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(
          json['lastMessageTime'] ?? DateTime.now().toIso8601String()),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hairdresserId': hairdresserId,
      'hairdresserName': hairdresserName,
      'hairdresserImageUrl': hairdresserImageUrl,
      'salonName': salonName,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  ChatRoom copyWith({
    String? id,
    String? hairdresserId,
    String? hairdresserName,
    String? hairdresserImageUrl,
    String? salonName,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      hairdresserId: hairdresserId ?? this.hairdresserId,
      hairdresserName: hairdresserName ?? this.hairdresserName,
      hairdresserImageUrl: hairdresserImageUrl ?? this.hairdresserImageUrl,
      salonName: salonName ?? this.salonName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String content;
  final MessageType type;
  final String? attachmentUrl;
  final DateTime timestamp;
  final bool isFromUser;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.type,
    this.attachmentUrl,
    required this.timestamp,
    required this.isFromUser,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      chatRoomId: json['chatRoomId'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      attachmentUrl: json['attachmentUrl'],
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isFromUser: json['isFromUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'content': content,
      'type': type.toString().split('.').last,
      'attachmentUrl': attachmentUrl,
      'timestamp': timestamp.toIso8601String(),
      'isFromUser': isFromUser,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? content,
    MessageType? type,
    String? attachmentUrl,
    DateTime? timestamp,
    bool? isFromUser,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      timestamp: timestamp ?? this.timestamp,
      isFromUser: isFromUser ?? this.isFromUser,
    );
  }
}
