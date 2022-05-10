import 'package:flutter/material.dart';

class CustomerInfoDetail extends StatefulWidget {
  const CustomerInfoDetail({Key? key}) : super(key: key);

  @override
  State<CustomerInfoDetail> createState() => _CustomerInfoDetailState();
}

class _CustomerInfoDetailState extends State<CustomerInfoDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin KH"),
      ),
    );
  }
}
