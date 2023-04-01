class ChatModel {
  final String content;
  final String role;

  ChatModel({required this.content, required this.role});

  // factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
  //       message: json["message"],
  //       role: json["chatIndex"],
  //     );

  Map<String, dynamic> toJson() {
    return {"role": role, "content": content};
  }
}
