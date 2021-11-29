import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:salesapp/rest/rest_services.dart';
import 'package:salesapp/utils/app_string.dart';

class ListTileWidget extends StatelessWidget {
  final int? id;
  final int? loanId;
  final int? index;
  final int? quantity;
  final String? pocketNo;
  final double? grossWeight;
  final String? riskClass;
  final double? netWeight;
  final int? deductionQuantity;
  final double? deductionWeight;
  final Map<String, dynamic>? deductionData;
  final Function? onTap;

  const ListTileWidget(
      {this.id,
        this.loanId,
        this.index,
      this.quantity,
      this.pocketNo,
      this.grossWeight,
      this.riskClass,
      this.netWeight,
      this.deductionQuantity,
      this.deductionWeight,
      this.deductionData,
        this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 5,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: ListTile(
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No : # $id",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                        Text(
                          "Risk Class : $riskClass",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                        Text(
                          "Pocket No : $pocketNo",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Net Weight : $netWeight",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                        Text(
                          "Deduction Weight : $deductionWeight",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                        Text(
                          "Gross Weight : $grossWeight",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  ElevatedButton(
                    onPressed: () {
                      Modular.to.navigate(
                          "${AppString.addGoldLoanPage}/2047/${deductionData!['id']}",
                          arguments: deductionData);
                    },
                    child: const Icon(Icons.edit),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 5.0,
                            title: Text(
                              AppString.delete,
                              style: const TextStyle(color: Colors.black),
                            ),
                            content: Text(
                              AppString.areYouSureDelete,
                              style: const TextStyle(color: Colors.black),
                            ),
                            actions: [
                              TextButton(
                                onPressed: ()  {
                                  onTap!.call(index,id,loanId);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Modular.to.pop();
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.delete),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              )
            ],
          ),
        ),
        // horizontalTitleGap: 20.0,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      ),
    );
  }
}
