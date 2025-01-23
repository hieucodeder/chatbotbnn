class BodyHistoryAll {
  String? chatbotCode;
  String? endDate;
  String? startDate;
  String? userId;

  BodyHistoryAll({this.chatbotCode, this.endDate, this.startDate, this.userId});

  BodyHistoryAll.fromJson(Map<String, dynamic> json) {
    chatbotCode = json['chatbot_code'];
    endDate = json['end_date'];
    startDate = json['start_date'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatbot_code'] = chatbotCode;
    data['end_date'] = endDate;
    data['start_date'] = startDate;
    data['user_id'] = userId;
    return data;
  }
}
