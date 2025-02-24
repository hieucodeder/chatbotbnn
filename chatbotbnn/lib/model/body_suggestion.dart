class BodySuggestion {
  String? query;
  String? prompt;
  String? genmodel;

  BodySuggestion({this.query, this.prompt, this.genmodel});

  BodySuggestion.fromJson(Map<String, dynamic> json) {
    query = json['query'];
    prompt = json['prompt'];
    genmodel = json['genmodel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['query'] = query;
    data['prompt'] = prompt;
    data['genmodel'] = genmodel;
    return data;
  }
}
