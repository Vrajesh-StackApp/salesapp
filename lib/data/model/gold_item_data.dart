class GoldItemData {
  String? id;
  String? loanId;
  int? goldItemId;
  String? goldItemName = '';
  String? quantity = '';
  String? pocketNo = '';
  String? grossWeight = '';
  String? riskClass = '';
  double? netWeight;
  int? deductionQuantity;
  double? deductionWeight;
  Map<String, dynamic>? deductionMap;

  GoldItemData({
    this.loanId,
    this.goldItemId,
    this.id,
    this.goldItemName,
    this.quantity,
    this.pocketNo,
    this.grossWeight,
    this.riskClass,
    this.netWeight,
    this.deductionQuantity,
    this.deductionWeight,
    this.deductionMap,
  });

  Map<String, dynamic> toMap() {
    return {
      'loanId': loanId,
      'goldItemId': goldItemId,
      'id': id,
      'goldItemName': goldItemName,
      'quantity': quantity,
      'pocketNo': pocketNo,
      'grossWeight': grossWeight,
      'riskClass': riskClass,
      'netWeight': netWeight,
      'deductionQuantity': deductionQuantity,
      'deductionWeight': deductionWeight,
      'deductionMap': deductionMap,
    };
  }
}
