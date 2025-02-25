class BodyChatbotConfig {
  String? chatbotCode;

  BodyChatbotConfig({this.chatbotCode});

  BodyChatbotConfig.fromJson(Map<String, dynamic> json) {
    chatbotCode = json['chatbot_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatbot_code'] = chatbotCode;

    return data;
  }
}
