class AnswerModelPq {
  String? message;
  bool? results;
  Data? data;

  AnswerModelPq({this.message, this.results, this.data});

  AnswerModelPq.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    results = json['results'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['results'] = results;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<History>? history;
  List<String>? intentqueue;
  List<String>? slots;
  String? message;
  List<String>? images;

  Data({this.history, this.intentqueue, this.slots, this.message, this.images});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['history'] != null) {
      history = [];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    intentqueue = json['intentqueue'] != null
        ? List<String>.from(json['intentqueue'])
        : null;
    slots = json['slots'] != null ? List<String>.from(json['slots']) : null;
    message = json['message'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    if (intentqueue != null) {
      data['intentqueue'] = intentqueue;
    }
    if (slots != null) {
      data['slots'] = slots;
    }
    data['message'] = message;
    if (images != null) {
      data['images'] = images;
    }
    return data;
  }
}

class History {
  int? turn;
  String? query;
  String? answer;
  String? intents;

  History({this.turn, this.query, this.answer, this.intents});

  History.fromJson(Map<String, dynamic> json) {
    turn = json['turn'];
    query = json['query'];
    answer = json['answer'];
    intents = json['intents'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['turn'] = turn;
    data['query'] = query;
    data['answer'] = answer;
    data['intents'] = intents;
    return data;
  }
}
