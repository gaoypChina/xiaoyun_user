class EvaluateModel {
  int evaluateStar = 0;
  String evaluateTags = '';
  String evaluationContent = '';
  String evaluationTime = '';

  EvaluateModel.fromJson(Map<String, dynamic> json) {
    evaluateStar = json["evaluateStar"];
    evaluateTags = json["evaluateTags"] ?? "";
    evaluationContent = json["evaluationContent"] ?? "";
    evaluationTime = json["evaluationTime"] ?? "";
  }
}
