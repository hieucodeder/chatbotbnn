class ResponeForgetpassword {
  String? message;
  bool? results;

  ResponeForgetpassword({this.message, this.results});

  ResponeForgetpassword.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    results = json['results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['results'] = results;
    return data;
  }
}
