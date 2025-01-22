class ChatbotAnswerModel {
  final String message;
  final bool results;
  final ChatbotData data;

  ChatbotAnswerModel({
    required this.message,
    required this.results,
    required this.data,
  });

  factory ChatbotAnswerModel.fromJson(Map<String, dynamic> json) {
    return ChatbotAnswerModel(
      message: json['message'] ?? '',
      results: json['results'] ?? false,
      data: ChatbotData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'results': results,
      'data': data.toJson(),
    };
  }
}

class ChatbotData {
  final List<ChatHistory> history;
  final List<dynamic> intentQueue;
  final List<Slot> slots;
  final String message;
  final List<String> images;

  ChatbotData({
    required this.history,
    required this.intentQueue,
    required this.slots,
    required this.message,
    required this.images,
  });

  factory ChatbotData.fromJson(Map<String, dynamic> json) {
    return ChatbotData(
      history: (json['history'] as List<dynamic>?)
              ?.map((item) => ChatHistory.fromJson(item))
              .toList() ??
          [],
      intentQueue: json['intentqueue'] ?? [],
      slots: (json['slots'] as List<dynamic>?)
              ?.map((item) => Slot.fromJson(item))
              .toList() ??
          [],
      message: json['message'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history': history.map((item) => item.toJson()).toList(),
      'intentqueue': intentQueue,
      'slots': slots.map((item) => item.toJson()).toList(),
      'message': message,
      'images': images,
    };
  }
}

class ChatHistory {
  final int turn;
  final String query;
  final String answer;
  final String intents;

  ChatHistory({
    required this.turn,
    required this.query,
    required this.answer,
    required this.intents,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      turn: json['turn'] ?? 0,
      query: json['query'] ?? '',
      answer: json['answer'] ?? '',
      intents: json['intents'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turn': turn,
      'query': query,
      'answer': answer,
      'intents': intents,
    };
  }
}

class Slot {
  final String id;
  final String intentSlots;
  final Map<String, String> slotDetails;

  Slot({
    required this.id,
    required this.intentSlots,
    required this.slotDetails,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] ?? '',
      intentSlots: json['intent_slots'] ?? '',
      slotDetails: Map<String, String>.from(json['slot_details'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'intent_slots': intentSlots,
      'slot_details': slotDetails,
    };
  }
}
