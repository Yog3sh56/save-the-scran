class Item {
  String ownerid;
  String name;
  DateTime buyDate;
  DateTime expiry;
  
  Item(this.ownerid,this.name,{this.buyDate,this.expiry}){
    if (this.buyDate == null){
      buyDate = DateTime.now();
      this.buyDate = buyDate;
      this.expiry = buyDate.add(Duration(days:20));
    }
  }







}
