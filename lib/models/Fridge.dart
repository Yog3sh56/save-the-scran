import 'Item.dart';

class Fridge {
  List<Item> items;
  String ownerId;



  //constructor for fridge, can be built with userID when user Registers
  Fridge(this.ownerId) {
    this.items = new List<Item>();
  }
  //get for fridge items (unordered)
  List<Item> get getItems => this.items;
}
