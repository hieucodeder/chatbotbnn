import 'dart:convert';

import 'package:flutter/material.dart';

class ChatbotConfig {
  List<DataConfig>? data;

  ChatbotConfig({this.data});

  factory ChatbotConfig.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData != null) {
      // print("History: ");
      // Map<String, dynamic> data =
      //     ((jsonData['data'] as List)[0] as Map<String, dynamic>);
      // print(data);
      // List<Map<String, dynamic>> historyList =
      //     List<Map<String, dynamic>>.from(json.decode(data["history"]));
      // Map<String, d>
      // print(history.toString());
      // print(jsonData['data']['history'].runtimeType.toString());
    }
    return ChatbotConfig(
      data: jsonData != null
          ? (jsonData['data'] as List)
              .map((v) => DataConfig.fromJson(v))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((v) => v.toJson()).toList(),
      };
}

class DataConfig {
  String? chatbotCode;
  String? userIndustry;
  String? queryRewrite;
  String? modelRerank;
  String? modelGenerate;
  String? fallbackResponse;
  String? systemPrompt;
  String? query;
  String? releventContext;
  int? topCount;
  double? threadHold;
  String? collectionName;
  int? temperature;
  String? lang;
  String? createdAt;
  String? updatedAt;
  dynamic slots;
  String? history;
  dynamic intentqueue;
  String? chatbotName;
  String? promptContent;
  String? slotsConfig;
  String? customizePrompt;
  int? promptId;

  DataConfig({
    this.chatbotCode,
    this.userIndustry,
    this.queryRewrite,
    this.modelRerank,
    this.modelGenerate,
    this.fallbackResponse,
    this.systemPrompt,
    this.query,
    this.releventContext,
    this.topCount,
    this.threadHold,
    this.collectionName,
    this.temperature,
    this.lang,
    this.createdAt,
    this.updatedAt,
    this.slots,
    this.history,
    this.intentqueue,
    this.chatbotName,
    this.promptContent,
    this.slotsConfig,
    this.customizePrompt,
    this.promptId,
  });

  factory DataConfig.fromJson(Map<String, dynamic> json) => DataConfig(
        chatbotCode: json['chatbot_code'],
        userIndustry: json['user_industry'],
        queryRewrite: json['query_rewrite'],
        modelRerank: json['model_rerank'],
        modelGenerate: json['model_generate'],
        fallbackResponse: json['fallback_response'],
        systemPrompt: json['system_prompt'],
        query: json['query'],
        releventContext: json['relevent_context'],
        topCount: json['top_count'],
        threadHold: (json['thread_hold'] as num?)?.toDouble(),
        collectionName: json['collection_name'],
        temperature: json['temperature'],
        lang: json['lang'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        slots: json['slots'],
        history: json['history'],
        intentqueue: json['intentqueue'],
        chatbotName: json['chatbot_name'],
        promptContent: json['prompt_content'],
        slotsConfig: json['slots_config'],
        customizePrompt: json['customize_prompt'],
        promptId: json['prompt_id'],
      );

  Map<String, dynamic> toJson() => {
        'chatbot_code': chatbotCode,
        'user_industry': userIndustry,
        'query_rewrite': queryRewrite,
        'model_rerank': modelRerank,
        'model_generate': modelGenerate,
        'fallback_response': fallbackResponse,
        'system_prompt': systemPrompt,
        'query': query,
        'relevent_context': releventContext,
        'top_count': topCount,
        'thread_hold': threadHold,
        'collection_name': collectionName,
        'temperature': temperature,
        'lang': lang,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'slots': slots,
        'history': history.toString(),
        'intentqueue': intentqueue,
        'chatbot_name': chatbotName,
        'prompt_content': promptContent,
        'slots_config': slotsConfig,
        // 'customize_prompt': customizePrompt,
        'prompt_id': promptId,
      };

  DataConfig copyWith({
    String? chatbotCode,
    dynamic userIndustry,
    String? queryRewrite,
    String? modelRerank,
    String? modelGenerate,
    String? fallbackResponse,
    String? systemPrompt,
    String? query,
    String? releventContext,
    int? topCount,
    double? threadHold,
    String? collectionName,
    int? temperature,
    String? lang,
    String? createdAt,
    String? updatedAt,
    dynamic slots,
    String? history,
    dynamic intentqueue,
    String? chatbotName,
    String? promptContent,
    String? slotsConfig,
    String? customizePrompt,
    int? promptId,
  }) {
    return DataConfig(
      chatbotCode: chatbotCode ?? this.chatbotCode,
      userIndustry: userIndustry ?? this.userIndustry,
      queryRewrite: queryRewrite ?? this.queryRewrite,
      modelRerank: modelRerank ?? this.modelRerank,
      modelGenerate: modelGenerate ?? this.modelGenerate,
      fallbackResponse: fallbackResponse ?? this.fallbackResponse,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      query: query ?? this.query,
      releventContext: releventContext ?? this.releventContext,
      topCount: topCount ?? this.topCount,
      threadHold: threadHold ?? this.threadHold,
      collectionName: collectionName ?? this.collectionName,
      temperature: temperature ?? this.temperature,
      lang: lang ?? this.lang,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      slots: slots ?? this.slots,
      history: history ?? this.history,
      intentqueue: intentqueue ?? this.intentqueue,
      chatbotName: chatbotName ?? this.chatbotName,
      promptContent: promptContent ?? this.promptContent,
      slotsConfig: slotsConfig ?? this.slotsConfig,
      customizePrompt: customizePrompt ?? this.customizePrompt,
      promptId: promptId ?? this.promptId,
    );
  }
}
