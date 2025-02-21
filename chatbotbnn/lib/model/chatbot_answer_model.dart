// class ChatbotAnswerModel {
//   String? message;
//   bool? results;
//   ChatbotData? data;

//   ChatbotAnswerModel({this.message, this.results, this.data});

//   ChatbotAnswerModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     results = json['results'];
//     data = json['data'] != null ? new ChatbotData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['message'] = message;
//     data['results'] = results;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class ChatbotData {
//   String? query;
//   String? response;
//   int? type;
//   List<String>? suggestions;
//   String? message;
//   List<ImageStatistic>? images;
//   List<Map<String, dynamic>>? table;

//   ChatbotData(
//       {this.query,
//       this.response,
//       this.type,
//       this.suggestions,
//       this.message,
//       this.images,
//       this.table});

//   ChatbotData.fromJson(Map<String, dynamic> json) {
//     query = json['query'];
//     response = json['response'];
//     type = json['type'];
//     message = json['message'];
//     suggestions = json['suggestions'] != null
//         ? List<String>.from(json['suggestions'])
//         : []; // Đảm bảo không lỗi khi JSON không có `suggestions`
//     if (json['images'] != null) {
//       images = <ImageStatistic>[];
//       json['images'].forEach((v) {
//         images!.add(ImageStatistic.fromJson(v));
//       });
//     }
//     if (json['table'] != null) {
//       table = List<Map<String, dynamic>>.from(json['table']);
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['query'] = query;
//     data['response'] = response;
//     data['type'] = type;
//     data['message'] = message;
//     data['suggestions'] = suggestions;

//     if (images != null) {
//       data['images'] = images!.map((v) => v.toJson()).toList();
//     }
//     if (table != null) {
//       data['table'] = table;
//     }
//     return data;
//   }
// }

// class ImageStatistic {
//   String? path;
//   String? description;

//   ImageStatistic({this.path, this.description});

//   ImageStatistic.fromJson(Map<String, dynamic> json) {
//     path = json['path'];
//     description = json['description'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'path': path,
//       'description': description,
//     };
//   }

//   @override
//   String toString() {
//     return 'ImageStatistic(path: $path, description: $description)';
//   }
// }
