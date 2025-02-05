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

  // Chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'turn': turn,
      'query': query,
      'answer': answer,
      'intents': intents,
    };
  }

  // Chuyển JSON thành đối tượng
  factory ChatHistory.fromJson(Map<String, dynamic> json) {
    return ChatHistory(
      turn: json['turn'],
      query: json['query'],
      answer: json['answer'],
      intents: json['intents'],
    );
  }
}
