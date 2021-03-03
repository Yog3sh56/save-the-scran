class Item {
  String name;
  DateTime buyDate;
  DateTime expiry;
  
  Item(this.name,{this.buyDate,this.expiry}){
    if (this.buyDate == null){
      buyDate = DateTime.now();
    }
  }





}
