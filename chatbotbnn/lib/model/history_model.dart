class HistoryModel {
  List<DataHistory>? data;

  HistoryModel({this.data});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataHistory>[];
      json['data'].forEach((v) {
        data!.add(DataHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataHistory {
  int? id;
  int? chatHistoryId;
  String? messageType;
  String? content;
  int? likes;
  int? dislikes;
  String? createdAt;

  DataHistory(
      {this.id,
      this.chatHistoryId,
      this.messageType,
      this.content,
      this.likes,
      this.dislikes,
      this.createdAt});

  DataHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatHistoryId = json['chat_history_id'];
    messageType = json['message_type'];
    content = json['content'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chat_history_id'] = chatHistoryId;
    data['message_type'] = messageType;
    data['content'] = content;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['created_at'] = createdAt;
    return data;
  }
}
