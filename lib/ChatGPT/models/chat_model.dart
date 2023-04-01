class ChatModel {
  final String content;
  final String role;
  // final int animateIndex;

  ChatModel({required this.content, required this.role});

  Map<String, dynamic> toJson() {
    return {"role": role, "content": content};
  }
}
