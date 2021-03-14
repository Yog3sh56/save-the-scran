class Item {
  String ownerid;
  String name;
  DateTime buyDate;
  DateTime expiry;

  bool inCommunity;


  
  Item(this.ownerid,this.name,{this.buyDate,this.expiry,this.inCommunity}){
    if (this.buyDate == null){
      buyDate = DateTime.now();
      this.buyDate = buyDate;
      this.expiry = buyDate.add(Duration(days:20));
      
    }
    if (this.inCommunity == null) this.inCommunity=false;
  }







}
