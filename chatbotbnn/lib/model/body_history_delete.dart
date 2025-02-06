class BodyHistoryDelete {
  int? history;

  BodyHistoryDelete({this.history});

  BodyHistoryDelete.fromJson(Map<String, dynamic> json) {
    history = json['chatbot_history_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatbot_history_id'] = history;

    return data;
  }
}
