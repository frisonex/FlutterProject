class BodegaModel {
  String whsCode;
  String whsName;

  BodegaModel({required this.whsCode, required this.whsName});

  factory BodegaModel.fromJson(Map<String, dynamic> json) => BodegaModel(whsCode: json["whsCode"], whsName: json["whsName"]);
}
