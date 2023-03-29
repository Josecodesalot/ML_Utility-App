class ModelsModel {
  final String id;
  final String root;

  ModelsModel({required this.id, required this.root});

  factory ModelsModel.fromJson(Map<String, dynamic> json) => ModelsModel(
        id: json["id"],
        root: json["root"],
      );
}
