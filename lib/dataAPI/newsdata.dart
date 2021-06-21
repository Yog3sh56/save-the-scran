import 'package:save_the_scran/models/CategoryModel.dart';

List<CategoryModel> getCategory(){

  List<CategoryModel> category = [];
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.categoryId = "United Nation";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1590274853856-f22d5ee3d228?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryId = "Food waste";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryId = "Agriculture";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1564417947365-8dbc9d0e718e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80";
  category.add(categoryModel);

  categoryModel = new CategoryModel();
  categoryModel.categoryId = "Research";
  categoryModel.imageUrl = "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=750&q=80";
  category.add(categoryModel);

  return category;




}