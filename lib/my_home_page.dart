// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tulam1/customer_bill.dart';
import 'package:tulam1/manager_bill_controller.dart';



class HomePage extends StatelessWidget {


  final ManagerBillController _managerBillController = Get.put(ManagerBillController());




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //
        title: Text("demo app"),
        toolbarTextStyle: TextStyle(backgroundColor: Colors.blue[900]),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _title1(),
            _title2(),
            Form(
              key: _managerBillController.formKey,
              child: Column(
                //e nghe a
                children: [
                  _textFieldWithLabel(
                      label: "Tên Khách Hàng ",
                      controller: _managerBillController.nameController,
                      focusNode: _managerBillController.nameFocusNode,
                      validator: (value) {
                        if (value!.trim().isEmpty) return "Bạn không được để trống tên KH";
                        if (value.trim().length < 5) return "Tên KH phải tối thiểu 5 ký tự";
                        return null;
                      },
                      keyboardType: TextInputType.name),
                  _textFieldWithLabel(
                      controller: _managerBillController.bookQuantityController,
                      label: "Số lượng sách ",
                      validator: (value) {
                        if (value!.trim().isEmpty) return "Bạn phải nhập số lượng";
                        if (int.parse(value.trim()) < 2) return "Bạn phải mua ít nhất 2 cuốn sách ";
                        return null;
                      }),
                ],
              ),
            ),
            _isVIPCustomer(),
            _totalMoney(),
            _buttonList(),
            _statisticalItem(),
            _exitApp(),
            // TextButton(onPressed: () => Get.to(CustomerInfoDetail()), child: Text("Xem thông tin KH"))
          ],
        ),
      ),
    );
  }

  Obx _statisticalItem() {
    return Obx(() => Visibility(
          visible: _managerBillController.isDisplayStatisticalItem.value,
          child: Column(
            children: [
              _title3(),
              _textFieldWithLabel(label: "Tổng số KH ", controller: _managerBillController.customerQuantityController),
              _textFieldWithLabel(label: "Tổng số KH là VIP ", controller: _managerBillController.customerVIPQuantityController),
              _textFieldWithLabel(label: "Tổng doanh thu ", controller: _managerBillController.moneyQuantityController, enabled: false),
              Container(
                color: Colors.blue,
                height: 30.h,
              ),
            ],
          ),
        ));
  }

  Row _buttonList() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,// anh ơi :v VÔ
      children: [
        _button(label: "TÍNH TT", onPressed: _calculate),
        _button(label: "TIẾP", onPressed: _saveCustomerBill),
        _button(label: "THỐNG KÊ", onPressed: _statistical),
      ],
    );
  }

  Align _exitApp() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _showDialog /* exit(0) */,
        child: Container(
            margin: EdgeInsets.only(top: 10.h, right: 5.h), padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), color: Colors.grey, child: const Icon(Icons.logout)),
      ),
    );
  }

  Container _title3() {
    return Container(
      color: Colors.blue,
      width: Get.width,
      height: 30.h,
      child: Text(
        "Thông tin Thống kê ",
        // style: TextStyle(color: Colors.white),
      ),
    );
  }

  Row _totalMoney() {
    return Row(
      children: [
        Expanded(flex: 1, child: const Text("Thành tiền")),
        Expanded(
          flex: 2,
          child: Container(
            height: 30.h,
            color: Colors.grey,
            child: Center(
                child: Obx(() => Text(
                      _managerBillController.bill.value.toString(),
                      style: TextStyle(color: Color.fromARGB(255, 69, 211, 71), fontSize: 20.sp),
                    ))),
          ),
        ),
      ],
    );
  }
  // dạ anh :v

  Row _isVIPCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // có anh
        Obx(() => Checkbox(
              value: _managerBillController.isVIP.value,
              onChanged: (value) {
                _managerBillController.isVIP.value = value!;
                ;
              },
            )),
        Text("Khách hàng là VIP")
      ],
    );
  }

  Container _title2() {
    return Container(
      color: Colors.blue,
      width: Get.width,
      height: 30.h,
      child: Text(
        "Thông tin hóa đơn ",
        // style: TextStyle(color: Colors.white),
      ),
    );
  }

  Container _title1() {
    return Container(
      color: const Color.fromARGB(255, 33, 177, 243),
      width: Get.width,
      height: 20.h,
      child: const Text(
        "THông tin",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Expanded _button({required String label, required void Function()? onPressed}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)), onPressed: onPressed, child: Text(label)),
      ),
    );
  }

  Row _textFieldWithLabel(
      {required String label,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.number,
      String? Function(String?)? validator,
      FocusNode? focusNode,
      bool enabled = true}) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(label)),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            enabled: enabled,
            focusNode: focusNode,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            // sửa kiểu bàn phím dữ liệu
          ),
        ),
      ],
    );
  }

  _calculate() {
    if (_managerBillController.formKey.currentState!.validate()) {
      double money = double.parse(_managerBillController.bookQuantityController.text) * 20000;
      _managerBillController.bill.value = _managerBillController.isVIP.value ? (money * 90 / 100) : money;
    }
    ;
  }

  _saveCustomerBill() {
    CustomerBill customerBill = CustomerBill(
        nameCustomer: _managerBillController.nameController.text,
        bookQuantity: num.parse(_managerBillController.bookQuantityController.text),
        isVip: _managerBillController.isVIP.value,
        moneyTotal: _managerBillController.bill.value);
    _managerBillController.totalCustomer++;
    _managerBillController.customerQuantityController.text = _managerBillController.totalCustomer.toString();
    if (_managerBillController.isVIP.value) {
      _managerBillController.countVip++;
      _managerBillController.customerVIPQuantityController.text = _managerBillController.countVip.toString();
    }
    _managerBillController.totalProfit += _managerBillController.bill.value;
    _managerBillController.moneyQuantityController.text = _managerBillController.totalProfit.toString();

    _managerBillController.isVIP.value = false;
    _managerBillController.bill.value = 0;
    ;

    FocusScope.of(Get.context!).requestFocus(_managerBillController.nameFocusNode);
  }

  _statistical() {
    _managerBillController.isDisplayStatisticalItem.value = !_managerBillController.isDisplayStatisticalItem.value;
    ;
    _managerBillController.customerQuantityController.text = _managerBillController.totalCustomer.toString();
    // if (_countVip > 0) _countVip = 0;
    // for (int i = 0; i < _listCustomerBill.length; i++) {
    //   if (_listCustomerBill[i].isVip) {
    //     _countVip++;
    //   }
    // }
    // print(_countVip.toString());
    _managerBillController.customerVIPQuantityController.text = _managerBillController.countVip.toString();
    _managerBillController.moneyQuantityController.text = _managerBillController.totalProfit.toString();
  }

  _showDialog() => showAnimatedDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ClassicGeneralDialogWidget(
            titleText: 'Ban co muon thoat ung dung khong',
            //contentText: 'content',
            onPositiveClick: () async {
              await Hive.box("testBox").put("customerName", _managerBillController.nameController.text);
              await Hive.box("testBox").put("bookQuantity", _managerBillController.bookQuantityController.text);
              await Hive.box("testBox").put("isVIP", _managerBillController.isVIP.value);
              await Hive.box("testBox").put("bill", _managerBillController.bill.value);
              await Hive.box("testBox").put("customerQuantity", _managerBillController.totalCustomer);
              await Hive.box("testBox").put("countVip", _managerBillController.countVip);
              await Hive.box("testBox").put("totalProfit", _managerBillController.totalProfit);
              exit(0);
            },
            onNegativeClick: () {
              Navigator.of(context).pop();
            },
            negativeText: "khong",
            positiveText: "co",
          );
        },
        animationType: DialogTransitionType.fadeRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
      );

  /* showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(' Ban co muon thoat ung dung khong'),
          // content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Khong'),
              child: const Text('khong'),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: const Text('Co'),
            ),
          ],
        ),
      ) */
}
