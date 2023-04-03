class ImageModel {
  final String prompt;
  final String url;
  final String role;

  ImageModel({required this.role, required this.prompt, required this.url});

  Map<String, String> toJson() {
    return {
      "prompt": prompt,
      "url": url,
      "role": role,
    };
  }
}
