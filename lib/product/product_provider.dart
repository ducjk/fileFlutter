import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_project/product/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> list = [];
  List<ProductModel> listProductWithCatgory = [];
  List<String> listCategories = [];
  List<ProductModel> listCart = [];
  void getList() async {
    String urlAPI = 'https://fakestoreapi.com/products';
    var client = http.Client();
    var rs = await client.get(Uri.parse(urlAPI));
    var jsonString = rs.body;
    var jsonObject = jsonDecode(jsonString) as List;
    list = jsonObject.map((e) {
      return ProductModel(
          id: e['id'],
          title: e['title'],
          description: e['description'],
          price: e['price'],
          image: e['image'],
          category: e['category'],
          quantity: 1);
    }).toList();

    notifyListeners();
  }

  void getCategories() async {
    String urlAPI = 'https://fakestoreapi.com/products/categories';
    var client = http.Client();
    var rs = await client.get(Uri.parse(urlAPI));
    var jsonString = rs.body;
    var jsonObject = jsonDecode(jsonString) as List;
    listCategories = jsonObject.map((e) {
      return e.toString();
    }).toList();

    notifyListeners();
  }

  void getListWithCategory(String category) async {
    String urlAPI = 'https://fakestoreapi.com/products/category/$category';
    var client = http.Client();
    var rs = await client.get(Uri.parse(urlAPI));
    var jsonString = rs.body;
    var jsonObject = jsonDecode(jsonString) as List;
    listProductWithCatgory = jsonObject.map((e) {
      return ProductModel(
        id: e['id'],
        title: e['title'],
        description: e['description'],
        price: e['price'],
        image: e['image'],
        category: e['category'],
        quantity: 1,
      );
    }).toList();

    notifyListeners();
  }

  void getListCart(ProductModel product) {
    if (listCart.isEmpty) {
      listCart.add(product);
    } else {
      int kt = 0;
      for (var element in listCart) {
        if (element.id == product.id) {
          kt = 1;
          element.quantity = (element.quantity! + 1);
          break;
        }
      }
      if (kt == 0) {
        listCart.add(product);
      }
    }
  }

  notifyListeners();
}
