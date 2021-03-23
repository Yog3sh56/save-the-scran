import 'dart:async';

import 'package:openfoodfacts/openfoodfacts.dart';

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


class OpenFoodApi {
  static Future<String> getProduct(String barcode) async {
    //check if there is a image or not
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode, language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result =
    await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {

      final text = result.product.productName;
      return text.isEmpty ? 'No information found in the Barcode' : text;
      // return result.product.productName;
    } else {
      final error_bar = "product not found!";
      return error_bar;
      // throw new Exception("product not found!");
    }
    }
}