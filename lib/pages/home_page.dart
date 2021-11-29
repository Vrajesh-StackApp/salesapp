import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:salesapp/pages/add_gold_loan_page.dart';
import 'package:salesapp/rest/rest_services.dart';
import 'package:salesapp/utils/app_colors.dart';
import 'package:salesapp/utils/app_string.dart';
import 'package:salesapp/widget/common_loader.dart';
import 'package:salesapp/widget/common_snack_bar.dart';
import 'package:salesapp/widget/design.dart';
import 'package:salesapp/widget/listtile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RestServices restServices = RestServices();
  List loanDataList = [];
  bool isVisible = false;

  @override
  void initState() {
    getLoanData();
    super.initState();
  }

  getLoanData() async {
    setState(() {
      isVisible = true;
    });
    Response response = await restServices.get("loan/2047/goldLoan", context);
    if (response.data != null) {
      var result = response.data;
      loanDataList = result['object'];
      isVisible = false;
    } else {
      displayMessage(context, "Something went wrong");
      loanDataList = [];
    }
    setState(() {});
    print("Get Data Response ==> $loanDataList");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppString.assets,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: _homeBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Modular.to.navigate("${AppString.addGoldLoanPage}/2047/0"),
        elevation: 5.0,
        icon: const Icon(Icons.add),
        label: Text(AppString.goldLoan),
      ),
    ));
  }

  _homeBody() {
    return Stack(
      children: [
        const DesignWidget(),
        isVisible
            ? const CommonLoader()
            : loanDataList.isEmpty
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: loanDataList.length,
                    itemBuilder: (context, index) {
                      return ListTileWidget(
                        id: loanDataList[index]['id'],
                        loanId: 2047,
                        index:index,
                        quantity: loanDataList[index]['quantity'],
                        pocketNo: loanDataList[index]['pocketNo'],
                        grossWeight: loanDataList[index]['grossWeight'],
                        riskClass: loanDataList[index]['riskClass'],
                        netWeight: loanDataList[index]['netWeight'],
                        deductionQuantity: loanDataList[index]
                            ['deductionQuantity'],
                        deductionWeight: loanDataList[index]['deductionWeight'],
                        deductionData: loanDataList[index],
                        onTap: onTap,
                      );
                    },
                  ),
      ],
    );
  }

  Future<Function?> onTap(int index,int id,int loanId) async {
    setState(() {
      isVisible = true;
    });
    RestServices restServices = RestServices();
    Response response = await restServices.delete('goldLoan/$id/${loanId.toString()}', context);
    print("Response gold item deleted => $response");
    if(response.data != null){
      Modular.to.pop();
      setState(() {
        isVisible = false;
      });
      loanDataList.removeAt(index);
      displayMessage(context,response.data['displayMessage']);

    }
    else
    {
        displayMessage(context, 'Something went wrong for item deleted');
    }
    setState(() {

    });
  }
}
