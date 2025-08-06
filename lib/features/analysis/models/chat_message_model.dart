enum AnalysisMessageType {
  text,
  image,
  file,
  location,
}

class AnalysisChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final AnalysisMessageType type;
  final String? imageUrl;
  final String? fileUrl;
  final bool isRead;

  AnalysisChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.type,
    this.imageUrl,
    this.fileUrl,
    this.isRead = false,
  });

  factory AnalysisChatMessage.fromJson(Map<String, dynamic> json) {
    return AnalysisChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      content: json['content'] ?? '',
      timestamp:
          DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: AnalysisMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnalysisMessageType.text,
      ),
      imageUrl: json['imageUrl'],
      fileUrl: json['fileUrl'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'isRead': isRead,
    };
  }

  AnalysisChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    AnalysisMessageType? type,
    String? imageUrl,
    String? fileUrl,
    bool? isRead,
  }) {
    return AnalysisChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      isRead: isRead ?? this.isRead,
    );
  }
}
