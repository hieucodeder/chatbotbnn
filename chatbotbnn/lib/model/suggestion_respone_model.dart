class SuggestionResponeModel {
  String? message;
  bool? result;
  Data? data;

  SuggestionResponeModel({this.message, this.result, this.data});

  SuggestionResponeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['result'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? suggestions;

  Data({this.suggestions});

  Data.fromJson(Map<String, dynamic> json) {
    suggestions = json['suggestions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestions'] = this.suggestions;
    return data;
  }
}
