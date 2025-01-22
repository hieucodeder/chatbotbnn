class GetCodeModel {
  int? id;
  String? chatbotCode;
  String? userId;
  int? groupId;
  String? chatbotName;
  String? createdAt;
  String? updatedAt;
  int? totalCount;
  String? picture;
  String? initialMessages;
  dynamic suggestedMessages;
  dynamic messagePlaceholder;
  String? footer;
  dynamic theme;
  dynamic displayName;
  dynamic profilePicture;
  dynamic chatIcon;
  dynamic userMessageColor;
  dynamic isSyncHeader;
  int? totalMessages;
  int? active;

  GetCodeModel(
      {this.id,
      this.chatbotCode,
      this.userId,
      this.groupId,
      this.chatbotName,
      this.createdAt,
      this.updatedAt,
      this.totalCount,
      this.picture,
      this.initialMessages,
      this.suggestedMessages,
      this.messagePlaceholder,
      this.footer,
      this.theme,
      this.displayName,
      this.profilePicture,
      this.chatIcon,
      this.userMessageColor,
      this.isSyncHeader,
      this.totalMessages,
      this.active});

  GetCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatbotCode = json['chatbot_code'];
    userId = json['user_id'];
    groupId = json['group_id'];
    chatbotName = json['chatbot_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalCount = json['total_count'];
    picture = json['picture'];
    initialMessages = json['initial_messages'];
    suggestedMessages = json['suggested_messages'];
    messagePlaceholder = json['message_placeholder'];
    footer = json['footer'];
    theme = json['theme'];
    displayName = json['display_name'];
    profilePicture = json['profile_picture'];
    chatIcon = json['chat_icon'];
    userMessageColor = json['user_message_color'];
    isSyncHeader = json['is_sync_header'];
    totalMessages = json['total_messages'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chatbot_code'] = chatbotCode;
    data['user_id'] = userId;
    data['group_id'] = groupId;
    data['chatbot_name'] = chatbotName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_count'] = totalCount;
    data['picture'] = picture;
    data['initial_messages'] = initialMessages;
    data['suggested_messages'] = suggestedMessages;
    data['message_placeholder'] = messagePlaceholder;
    data['footer'] = footer;
    data['theme'] = theme;
    data['display_name'] = displayName;
    data['profile_picture'] = profilePicture;
    data['chat_icon'] = chatIcon;
    data['user_message_color'] = userMessageColor;
    data['is_sync_header'] = isSyncHeader;
    data['total_messages'] = totalMessages;
    data['active'] = active;
    return data;
  }
}
