class HistoryAllModel {
  List<Data>? data;

  HistoryAllModel({this.data});

  HistoryAllModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? chatbotHistoryId;
  String? updatedAt;
  String? slots;
  List<Messages>? messages;

  Data({this.chatbotHistoryId, this.updatedAt, this.slots, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    chatbotHistoryId = json['chatbot_history_id'];
    updatedAt = json['updated_at'];
    slots = json['slots'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatbot_history_id'] = chatbotHistoryId;
    data['updated_at'] = updatedAt;
    data['slots'] = slots;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? likes;
  String? content;
  int? dislikes;
  String? messageType;

  Messages({this.likes, this.content, this.dislikes, this.messageType});

  Messages.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
    content = json['content'];
    dislikes = json['dislikes'];
    messageType = json['message_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['likes'] = likes;
    data['content'] = content;
    data['dislikes'] = dislikes;
    data['message_type'] = messageType;
    return data;
  }
}
