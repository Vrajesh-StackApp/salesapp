import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:salesapp/data/model/deduction_data.dart';
import 'package:salesapp/data/model/gold_child_item.dart';
import 'package:salesapp/data/model/gold_item.dart';
import 'package:salesapp/data/model/gold_item_data.dart';
import 'package:salesapp/data/model/gold_loan_deduction_form.dart';
import 'package:salesapp/rest/rest_services.dart';
import 'package:salesapp/utils/app_string.dart';
import 'package:salesapp/utils/common_validation.dart';
import 'package:salesapp/utils/utils.dart';
import 'package:salesapp/widget/common_loader.dart';
import 'package:salesapp/widget/common_snack_bar.dart';
import 'package:salesapp/widget/common_text_form_field.dart';
import 'package:salesapp/widget/design.dart';

List<GoldItemData> saveDataList = [];

class AddGoldLoanPage extends StatefulWidget {
  final Map<String, dynamic>? deductionEditData;
  final String? id;
  final String? loanId;

  const AddGoldLoanPage(
      {Key? key, this.deductionEditData, this.id, this.loanId})
      : super(key: key);

  @override
  _AddGoldLoanPageState createState() => _AddGoldLoanPageState();
}

class _AddGoldLoanPageState extends State<AddGoldLoanPage> {
  GlobalKey<FormState> saveFormKey = GlobalKey<FormState>();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _pocketNo = TextEditingController();
  final TextEditingController _grossWeight = TextEditingController();
  final TextEditingController _riskClass = TextEditingController();

  RestServices restService = RestServices();

  Map<String, dynamic> goldSelectedItem = {};
  List<GoldItem> goldItemList = [];
  List<GoldChildItem> goldChildItemList = [];
  List<GoldLoanDeductionForm> listChildDeductionForm = [];
  Map<String, dynamic> deductionMap = {};
  List<DeductionData> deductionList = [];

  int totalDeductionQ = 0;
  double totalDeductionW = 0;
  double netWeight = 0;
  int? goldItemId = 0;
  bool isShowAdd = false;
  bool showMore = false;
  bool isItemError = false;
  bool isVisible = false;

  @override
  void initState() {
    fillDropDownGoldItem();
    loadEditData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _back(),
      child: SafeArea(
        child: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() => AppBar(
        title: Text(AppString.goldLoan),
        leading: IconButton(
          onPressed: () => _back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      );

  Widget _body() => Stack(
        children: [
          const DesignWidget(),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Form(
                  key: saveFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      goldLoanFormFieldItem(),
                      if (isShowAdd) addButton(),
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: listChildDeductionForm.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                right: 16, top: 8, left: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white38,
                            ),
                            child: goldLoanChildItem(index),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      deductionField(AppString.deductionQuantity,
                          totalDeductionQ.toString()),
                      const SizedBox(height: 8),
                      deductionField(AppString.deductionWeight,
                          totalDeductionW.toString()),
                      const SizedBox(height: 8),
                      deductionField(AppString.netWeight, netWeight.toString()),
                      const SizedBox(height: 8),
                      riskClass(),
                      const SizedBox(height: 8),
                      saveButton(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isVisible ? const CommonLoader() : Container(),
        ],
      );

  goldLoanFormFieldItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          DropdownButtonFormField<Map<String, dynamic>>(
            value: goldSelectedItem,
            decoration: InputDecoration(
                labelText: 'Item',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isItemError ? Colors.black : Colors.red))),
            onChanged: (value) {
              goldSelectedItem = value!;
              if (value['id'] != '0') {
                isShowAdd = true;
              } else {
                isShowAdd = false;
              }
              setState(() {});
            },
            items:
                goldItemList.map<DropdownMenuItem<Map<String, dynamic>>>((e) {
              return DropdownMenuItem<Map<String, dynamic>>(
                child: Text(e.itemMap['name']),
                value: e.itemMap,
              );
            }).toList(),
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
          ),
          const SizedBox(height: 8),
          Visibility(
            visible: isItemError,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Gold item required',
                style: TextStyle(fontSize: 12, color: Colors.red),
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          CommonTextFormField(
            controller: _quantity,
            labelText: AppString.quantity,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
            ],
            validator: (value) =>
                CommonValidation.commonValidation(value!, AppString.quantity),
          ),
          const SizedBox(height: 8),
          CommonTextFormField(
            controller: _pocketNo,
            labelText: AppString.pocketNo,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
            ],
            validator: (value) =>
                CommonValidation.commonValidation(value!, AppString.pocketNo),
          ),
          const SizedBox(height: 8),
          CommonTextFormField(
            controller: _grossWeight,
            labelText: AppString.grossWeight,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
            ],
            validator: (value) => CommonValidation.commonValidation(
                value!, AppString.grossWeight),
            onChanged: (value) => setState(() {
              if (value.isEmpty) {
                netWeight = 0;
              } else {
                netWeight = double.parse(value);
              }
            }),
          )
        ],
      ),
    );
  }

  addButton() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () {
          _addEmptyView();
        },
        child: Text(AppString.add),
      ),
    );
  }

  deductionField(label, value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white38,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  riskClass() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CommonTextFormField(
        controller: _riskClass,
        labelText: AppString.riskClass,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputFormatters: [
          LengthLimitingTextInputFormatter(5),
        ],
        validator: (value) =>
            CommonValidation.commonValidation(value!, AppString.riskClass),
      ),
    );
  }

  saveButton() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            isVisible = true;
          });

          if (goldItemList[0].itemMap == goldSelectedItem) {
            setState(() {
              isItemError = true;
            });
          } else {
            setState(() {
              isItemError = false;
            });
          }

          if (saveFormKey.currentState!.validate() && !isItemError) {
            var data = GoldItemData(
              loanId: widget.loanId,
              goldItemId: int.parse(goldSelectedItem['id']),
              goldItemName: goldSelectedItem['name'],
              quantity: _quantity.text.trim(),
              pocketNo: _pocketNo.text.trim(),
              grossWeight: _grossWeight.text.trim(),
              riskClass: _riskClass.text.trim(),
              deductionQuantity: totalDeductionQ,
              deductionWeight: totalDeductionW,
              netWeight: netWeight,
            );

            if (widget.id != '0') {
              data.id = widget.id;
            }

            Response response =
                await restService.post('goldLoan', data.toMap(), context);

            if (response.data != null) {
              var deductionDataList = [];
              var data = response.data;

              print("ID ==> ${data['id']}");

              if (widget.id == '0') {
                for (var element in listChildDeductionForm) {
                  if (!element.isAdded!) {
                    deductionDataList.add({
                      'loanId': widget.loanId,
                      'goldLoanId': data['id'],
                      'goldDeductionId': element.deductionItemName!['id'],
                      'deductionQuantity': element.deductionQuantity,
                      'deductionWeight': element.deductionWeight
                    });
                  }
                }
              } else {
                print("Else ==> ");

                for (var element in listChildDeductionForm) {
                  if (!element.isAdded!) {
                    Map<String, dynamic> map = {
                      'loanId': widget.deductionEditData!['loanId'],
                      'goldLoanId': widget.deductionEditData!['id'],
                      'goldDeductionId': element.deductionItemName!['id'],
                      'deductionQuantity': element.deductionQuantity,
                      'deductionWeight': element.deductionWeight
                    };
                    if (element.id != null) {
                      map["id"] = element.id;
                    }
                    print("Edit Map => $map");
                    deductionDataList.add(map);
                    print("deductionDataList ====> $deductionDataList");
                  }
                }
              }

              if (deductionDataList.isEmpty) {
                onDataSaved(response.data);
              } else {
                Response res = await restService.post(
                    "goldDeductionLoan/saveList", deductionDataList, context);

                if (res.data != null) {
                  onDataSaved(res.data);
                }
              }
            }

            Modular.to.navigate('/');
          }
          setState(() {
            isVisible = false;
          });
        },
        child: Text(goldItemId != 0 ? AppString.update : AppString.save),
        style: ElevatedButton.styleFrom(
            elevation: 5.0,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
      ),
    );
  }

  fillDropDownGoldItem() async {
    Map<String, dynamic> selectedDeductionType = {};

    goldItemList.add(GoldItem({"id": "0", "name": "Please select item"}));
    goldItemList.add(GoldItem({"id": "1", "name": "Bangles"}));
    goldItemList.add(GoldItem({"id": "2", "name": "Bangles Rings"}));
    goldItemList.add(GoldItem({"id": "3", "name": "Bracelet"}));
    goldItemList.add(GoldItem({"id": "4", "name": "Chain"}));
    goldItemList.add(GoldItem({"id": "5", "name": "Gold Bars"}));
    goldItemList.add(GoldItem({"id": "6", "name": "Gold Coins"}));
    goldItemList.add(GoldItem({"id": "7", "name": "Gold Earrings"}));
    goldItemList.add(GoldItem({"id": "8", "name": "Gold Jewellery"}));
    goldItemList.add(GoldItem({"id": "9", "name": "Rings"}));

    goldChildItemList.add(
        GoldChildItem({"id": "0", "name": "Please select deduction item"}));
    goldChildItemList.add(GoldChildItem({"id": "1", "name": "Stone"}));
    goldChildItemList.add(GoldChildItem({"id": "2", "name": "Pearl"}));
    goldChildItemList.add(GoldChildItem({"id": "3", "name": "Colours"}));
    goldChildItemList.add(GoldChildItem({"id": "4", "name": "Coin"}));

    if (widget.deductionEditData != null) {
      goldItemId = widget.deductionEditData!['goldItemId'];

      for (int i = 0; i < goldItemList.length; i++) {
        if (goldItemList[i].itemMap['id'] ==
            widget.deductionEditData!['goldItemId'].toString()) {
          goldSelectedItem = goldItemList[i].itemMap;
        }
      }
    } else if (widget.deductionEditData == null && goldItemList.isNotEmpty) {
      goldSelectedItem = goldItemList[0].itemMap;
    }

    if (widget.id != '0') {
      setState(() {
        isShowAdd = true;
        showMore = true;
      });

      Response dedRes = await restService.get(
          "goldDeductionLoan/${widget.deductionEditData!['loanId']}/${widget.id}",
          context);

      if (dedRes.data != null) {
        for (var deduction in dedRes.data) {
          for (int j = 0; j < goldChildItemList.length; j++) {
            if (deduction['goldDeductionId'] ==
                int.parse(goldChildItemList[j].childItem['id'])) {
              selectedDeductionType = goldChildItemList[j].childItem;
            }
          }

          GoldLoanDeductionForm goldLoanDeductionForm = GoldLoanDeductionForm(
            id: deduction['goldDeductionId'],
            deductionItemName: selectedDeductionType,
            deductionQuantity: deduction['deductionQuantity'].toString(),
            deductionWeight: deduction['deductionWeight'].toString(),
            isAdded: false,
          );

          listChildDeductionForm.add(goldLoanDeductionForm);
        }
      } else {
        return null;
      }
      setState(() {});
    }
  }

  _back() {
    Modular.to.navigate('/');
  }

  _addEmptyView() {
    if (goldChildItemList.isNotEmpty) {
      GoldLoanDeductionForm goldLoanDeductionForm = GoldLoanDeductionForm(
        deductionItemName: goldChildItemList[0].childItem,
        deductionQuantity: "",
        deductionWeight: "",
        isAdded: true,
      );
      listChildDeductionForm.add(goldLoanDeductionForm);
      setState(() {});
    } else {
      displayMessage(context, 'Gold deduction item empty');
    }
  }

  goldLoanChildItem(int index) {
    GoldLoanDeductionForm item = listChildDeductionForm[index];
    final goldLoanFormKey = GlobalKey<FormState>();
    final TextEditingController deductionQuantity =
        TextEditingController(text: item.deductionQuantity);
    final TextEditingController deductionWeight =
        TextEditingController(text: item.deductionWeight);
    return Form(
      key: goldLoanFormKey,
      child: Column(
        children: [
          DropdownButtonFormField<Map<String, dynamic>>(
            value: item.deductionItemName,
            decoration: const InputDecoration(
              labelText: 'Deduction Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (Map<String, dynamic>? newValue) {
              listChildDeductionForm[index].deductionItemName = newValue!;
              if (newValue['id'] != '0') {
                showMore = true;
              } else {
                showMore = false;
              }
              setState(() {});
            },
            items: goldChildItemList
                .map<DropdownMenuItem<Map<String, dynamic>>>((item) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: item.childItem,
                child: Text(item.childItem["name"]),
              );
            }).toList(),
            icon: const Icon(Icons.expand_more),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
          ),
          const SizedBox(height: 8),
          if (showMore)
            CommonTextFormField(
              controller: deductionQuantity,
              labelText: AppString.deductionQuantity,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return '${AppString.deductionQuantity} is required';
                }
                return null;
              },
            ),
          const SizedBox(height: 8),
          if (showMore)
            CommonTextFormField(
              controller: deductionWeight,
              labelText: AppString.deductionWeight,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return '${AppString.deductionWeight} is required';
                }
                return null;
              },
            ),
          const SizedBox(height: 8),
          if (showMore)
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      bool validation =
                          goldLoanFormKey.currentState!.validate();

                      if (validation) {
                        GoldLoanDeductionForm goldLoanDeductionForm =
                            GoldLoanDeductionForm(
                          loanId: '100',
                          goldLoanId: goldSelectedItem['id'],
                          id: int.parse(listChildDeductionForm[index]
                              .deductionItemName!['id']),
                          deductionItemName:
                              listChildDeductionForm[index].deductionItemName!,
                          deductionName: listChildDeductionForm[index]
                              .deductionItemName!['name'],
                          deductionQuantity: deductionQuantity.text.trim(),
                          deductionWeight: deductionWeight.text.trim(),
                          isAdded: false,
                        );

                        listChildDeductionForm[index] = goldLoanDeductionForm;

                        print(
                            "listChildDeductionForm => $listChildDeductionForm");

                        displayMessage(context, "Item Saved.");
                        countDeductionValue();
                      }
                    },
                    child: item.isAdded!
                        ? const Icon(Icons.add)
                        : const Icon(Icons.done),
                    style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  item.isAdded!
                      ? Container()
                      : ElevatedButton(
                          child: const Icon(Icons.close),
                          onPressed: () async {
                            if (item.id != null) {
                              await onDeleteEditModeItem(item, index);
                            } else {
                              listChildDeductionForm.removeAt(index);
                              displayMessage(context, "Item Removed.");
                              countDeductionValue();
                            }
                          },
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red,
                            ),
                          ),
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  countDeductionValue() {
    totalDeductionQ = 0;
    totalDeductionW = 0;
    netWeight = 0;
    for (var element in listChildDeductionForm) {
      if (!element.isAdded!) {
        if (isNumeric(element.deductionQuantity!.toString().trim())) {
          totalDeductionQ += int.parse(element.deductionQuantity!);
        }
        if (isNumeric(element.deductionWeight!.toString().trim())) {
          totalDeductionW += double.parse(element.deductionWeight!);
        }
      }
    }
    String? grossWeight = _grossWeight.text.toString().trim();
    if (grossWeight.isNotEmpty) {
      if (isNumeric(grossWeight)) {
        netWeight = double.parse(grossWeight) - totalDeductionW;
      }
    }
    setState(() {});
  }

  void loadEditData() {
    if (widget.deductionEditData != null) {
      _quantity.text = widget.deductionEditData!['quantity'].toString();
      _pocketNo.text = widget.deductionEditData!['pocketNo'].toString();
      _grossWeight.text = widget.deductionEditData!['grossWeight'].toString();
      _riskClass.text = widget.deductionEditData!['riskClass'].toString();
      netWeight = widget.deductionEditData!['netWeight'];
      totalDeductionQ = widget.deductionEditData!['deductionQuantity'];
      totalDeductionW = widget.deductionEditData!['deductionWeight'];
    }
  }

  onDataSaved(data) {
    displayMessage(context, data['displayMessage']);
    _back();
  }

  onDeleteEditModeItem(GoldLoanDeductionForm item, int index) async {
    setState(() {
      isVisible = true;
    });

    print("Item Id ===> ${item.id}");

    Response deductionResponse = await restService.delete('goldDeductionLoan/${widget.loanId}/${item.id}', context);
    print("Delete Deduction Response ===> $deductionResponse");
    var deductionData = deductionResponse.data;
    if(deductionData != null)
      {
        print("Deduction ===> ");
        listChildDeductionForm.removeAt(index);
        countDeductionValue();

        displayMessage(context,deductionData['displayMessage']);

        var editData = {
          'loanId': widget.loanId,
          'goldItemId': goldSelectedItem['id'],
          'id': widget.id,
          'quantity': _quantity.text.trim(),
          'pocketNo': _pocketNo.text.trim(),
          'grossWeight': _grossWeight.text.trim(),
          'deductionQuantity': totalDeductionQ,
          'deductionWeight': totalDeductionW,
          'netWeight': netWeight,
          'riskClass': _riskClass.text.trim(),
        };

        Response response = await restService.post('goldLoan', editData, context);
        print("Delete goldLoan -> $response");

        var updateResponse = response.data;
        if (updateResponse != null) {
          displayMessage(context, updateResponse["displayMessage"]);
        } else {
          displayMessage(context, 'Something went wrong for update details.');
        }

      }
    else{
      displayMessage(index,"Something went wrong for item deletion.");
    }

    setState(() {
      isVisible = false;
    });
  }
}
