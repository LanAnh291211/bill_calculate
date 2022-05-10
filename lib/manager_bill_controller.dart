import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ManagerBillController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); //num
  final TextEditingController nameController = TextEditingController(text: Hive.box("testBox").get("customerName"));
  final TextEditingController bookQuantityController = TextEditingController(text: Hive.box("testBox").get("bookQuantity"));
  final TextEditingController customerQuantityController = TextEditingController(text: Hive.box("testBox").get("customerQuantity").toString());
  final TextEditingController customerVIPQuantityController = TextEditingController();
  final TextEditingController moneyQuantityController = TextEditingController();

  int totalCustomer = Hive.box("testBox").get("customerQuantity", defaultValue: 0);

  int countVip = Hive.box("testBox").get("countVip", defaultValue: 0);
  FocusNode nameFocusNode = FocusNode();
  RxDouble bill = 0.0.obs; //X
  RxBool isVIP = false.obs; //XX
  RxBool isDisplayStatisticalItem = false.obs;
  num totalProfit = Hive.box("testBox").get("totalProfit", defaultValue: 0);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    bill.value = Hive.box("testBox").get("bill", defaultValue: 0.0);
    isVIP.value = Hive.box("testBox").get("isVIP", defaultValue: false);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    nameController.dispose();
    bookQuantityController.dispose();
    customerQuantityController.dispose();
    customerVIPQuantityController.dispose();
    moneyQuantityController.dispose();
  }
}
