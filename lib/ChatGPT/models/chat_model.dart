class ChatModel {
  final String content;
  final String role;
  int animateIndex;

  ChatModel(
      {required this.animateIndex, required this.content, required this.role});

  Map<String, dynamic> toJson() {
    return {"role": role, "content": content};
  }
}
