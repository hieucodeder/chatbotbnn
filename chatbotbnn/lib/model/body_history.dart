class BodyHistory {
  String? history;

  BodyHistory({this.history});

  BodyHistory.fromJson(Map<String, dynamic> json) {
    history = json['chat_history_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_history_id'] = history;

    return data;
  }
}
