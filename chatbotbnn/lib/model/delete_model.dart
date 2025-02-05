class DeleteModel {
  final String message;
  final bool results;

  DeleteModel({required this.message, required this.results});

  // Chuyển từ JSON sang model
  factory DeleteModel.fromJson(Map<String, dynamic> json) {
    return DeleteModel(
      message: json['message'] ?? '',
      results: json['results'] ?? false,
    );
  }

  // Chuyển từ model sang JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'results': results,
    };
  }
}
