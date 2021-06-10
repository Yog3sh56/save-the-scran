class Item {
  String ownerid;
  String name;
  DateTime buyDate;
  DateTime expiry;

  bool inCommunity;

  // add a property to store image urls
  String imageUrl;


  
  Item(this.ownerid,this.name,this.imageUrl,{this.buyDate,this.expiry,this.inCommunity}){
    if (this.buyDate == null){
      buyDate = DateTime.now();
      this.buyDate = buyDate;
      this.expiry = buyDate.add(Duration(days:20));
      
    }
    if (this.inCommunity == null) this.inCommunity=false;
  }







}
