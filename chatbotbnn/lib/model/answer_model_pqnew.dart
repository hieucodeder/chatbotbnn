class AnswerModelPqnew {
  List<DataModel>? data;
  List<Map<String, dynamic>>? table;
  List<String>? suggestions;
  List<Choices>? choices;

  AnswerModelPqnew({this.data, this.table, this.suggestions, this.choices});

  factory AnswerModelPqnew.fromJson(Map<String, dynamic> json) {
    var tableData = json['table'];
    return AnswerModelPqnew(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      choices: (json['choices'] as List<dynamic>?)
          ?.map((e) => Choices.fromJson(e as Map<String, dynamic>))
          .toList(),
      table: (tableData is List<dynamic>) // Kiểm tra nếu tableData là List
          ? tableData.whereType<Map<String, dynamic>>().toList()
          : [],
      suggestions: json['suggestion'] != null
          ? List<String>.from(json['suggestion'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((e) => e.toJson()).toList(),
      'table': table,
      'suggestion': suggestions,
      'choices': choices?.map((e) => e.toJson()).toList(),
    };
  }
}

class Choices {
  Delta? delta;

  Choices({this.delta});

  Choices.fromJson(Map<String, dynamic> json) {
    delta = json['delta'] != null ? new Delta.fromJson(json['delta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.delta != null) {
      data['delta'] = this.delta!.toJson();
    }
    return data;
  }
}

class DeltaImages {
  String? content;

  DeltaImages({this.content});

  DeltaImages.fromJson(Map<String, dynamic> json) {
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    return data;
  }
}

class DataModel {
  String? id;
  String? object;
  int? created;
  String? model;
  String? serviceTier;
  String? systemFingerprint;
  List<Choice>? choices;

  DataModel({
    this.id,
    this.object,
    this.created,
    this.model,
    this.serviceTier,
    this.systemFingerprint,
    this.choices,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      object: json['object'],
      created: json['created'],
      model: json['model'],
      serviceTier: json['service_tier'],
      systemFingerprint: json['system_fingerprint'],
      choices: (json['choices'] as List<dynamic>?)
          ?.map((e) => Choice.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'service_tier': serviceTier,
      'system_fingerprint': systemFingerprint,
      'choices': choices?.map((e) => e.toJson()).toList(),
    };
  }
}

class Choice {
  int? index;
  Delta? delta;
  dynamic logprobs;
  dynamic finishReason;

  Choice({
    this.index,
    this.delta,
    this.logprobs,
    this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      index: json['index'],
      delta: json['delta'] != null ? Delta.fromJson(json['delta']) : null,
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'delta': delta?.toJson(),
      'logprobs': logprobs,
      'finish_reason': finishReason,
    };
  }
}

class Delta {
  String? content;

  Delta({this.content});

  factory Delta.fromJson(Map<String, dynamic> json) {
    return Delta(
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

class TableModel {
  List<Map<String, dynamic>>? table;

  TableModel({this.table});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      table: (json['table'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table': table,
    };
  }
}
