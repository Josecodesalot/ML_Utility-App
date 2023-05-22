import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> shopify_create_products(String text) async {
  final List productList = jsonDecode(text);
  for (final i in productList) {
    await shopify_create_product(i);
  }
}

Future<void> shopify_create_product(product) async {
  //This is the latest API version of 2023-04
  const apiVersion = "2023-04";
  //BaseURI should have your domain
  const baseUri = '5f4a5b.myshopify.com';

  const endpoint = 'products.json';
  //Secret Token
  //Jose, you can generate this token from App and Sales channel in Shopify dashboard.
  const accessToken = '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';

  //Api Headers
  final headers = {
    'Content-Type': 'application/json',
    'X-Shopify-Access-Token': accessToken,
  };

  // var productBody = {
  //   'product': {
  //     'title': 'Your Product Name',
  //     'body_html': '<strong>Your Product Description</strong>',
  //     'vendor': 'Your Vendor Name',
  //     'product_type': 'Your Product Type',
  //     'tags': 'Your Product, Tags',
  //   }
  // };

  final parsedProductBody = jsonEncode(product);
  var response = await http.post(
    Uri.parse('https://$baseUri/admin/api/$apiVersion/$endpoint'),
    headers: headers,
    body: parsedProductBody,
  );

  if (response.statusCode == 201) {
    var data = jsonDecode(response.body);
    print('Created Product: ${data['product']}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
