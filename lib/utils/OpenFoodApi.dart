import 'dart:async';

import 'package:openfoodfacts/openfoodfacts.dart';

// Class that deals with OpenFoodApi and retrieves products and product imageUrls from the api database.

/// request a product from the OpenFoodFacts database
// Future<Product> getProduct() async {
//   var barcode = "0048151623426";
//
//   ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
//   ProductResult result =
//   await OpenFoodAPIClient.getProduct(configuration);
//
//   if (result.status == 1) {
//     return result.product;
//   } else {
//     throw new Exception("product not found!");
//   }
// }


//Changed to return a future list to store name of the product and imageURl of the product
class OpenFoodApi {
  static Future<List> getProduct(String barcode) async {
    //check if there is a image or not
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result =
    await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {

      final text = result.product.productName;
      final imageUrl = result.product.imgSmallUrl;
      //print(result.product.imgSmallUrl);
      return text.isEmpty||imageUrl.isEmpty ? ['No information found in the Barcode', ""] : [text,imageUrl];

      // return result.product.productName;
    } else {
      final error_bar = "product not found!";
      return [error_bar];
      // throw new Exception("product not found!");
    }
    }
}