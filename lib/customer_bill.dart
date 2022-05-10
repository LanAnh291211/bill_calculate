class CustomerBill {
  String? nameCustomer;
  num? bookQuantity;
  bool isVip;
  num? moneyTotal;
  CustomerBill({
    this.nameCustomer,
    this.bookQuantity,
    this.isVip=false,
    this.moneyTotal,
  });

  @override
  String toString() {
    return 'CustomerBill(nameCustomer: $nameCustomer, bookQuantity: $bookQuantity, isVip: $isVip, moneyTotal: $moneyTotal)';
  }
}

