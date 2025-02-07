class GetHistoryid {
  int? id;
  int? chatHistoryId;
  String? messageType;
  String? content;
  int? likes;
  int? dislikes;
  String? createdAt;

  GetHistoryid(
      {this.id,
      this.chatHistoryId,
      this.messageType,
      this.content,
      this.likes,
      this.dislikes,
      this.createdAt});

  GetHistoryid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatHistoryId = json['chat_history_id'];
    messageType = json['message_type'];
    content = json['content'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_history_id'] = this.chatHistoryId;
    data['message_type'] = this.messageType;
    data['content'] = this.content;
    data['likes'] = this.likes;
    data['dislikes'] = this.dislikes;
    data['created_at'] = this.createdAt;
    return data;
  }
}
