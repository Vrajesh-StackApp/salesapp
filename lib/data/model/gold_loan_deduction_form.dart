class GoldLoanDeductionForm {
  String? loanId;
  String? goldLoanId;
  int? id;
  String? deductionName;
  Map<String, dynamic>? deductionItemName;
  String? deductionQuantity;
  String? deductionWeight;
  bool? isAdded;

  GoldLoanDeductionForm({
    this.loanId,
    this.goldLoanId,
    this.id,
    this.deductionName,
    this.deductionItemName,
    this.deductionQuantity,
    this.deductionWeight,
    this.isAdded,
  });
}
