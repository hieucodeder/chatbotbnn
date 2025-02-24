class SuggestionResponeModel {
  String? message;
  bool? result;
  Data? data;

  SuggestionResponeModel({this.message, this.result, this.data});

  SuggestionResponeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    result = json['result'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['result'] = result;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suggestions'] = suggestions;
    return data;
  }
}
