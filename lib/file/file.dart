import 'dart:io';
import 'dart:convert';

import 'package:file_project/product/product_model.dart';
import 'package:path_provider/path_provider.dart';

class CounterFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/counter.txt');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }
}

class CartFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/cart.txt');
  }

  Future<File> writeCounter(List<ProductModel> listCart) async {
    final file = await _localFile;
    // String cartJson = "[\n";
    // for (ProductModel item in listCart) {
    //   String itemJson =
    //       '{"id": "${item.id}", "title": "${item.title}", "price": "${item.price}", "description": "${item.description}", "category": "${item.category}", "image": "${item.image}", "quantity": "${item.quantity}"}';
    //   cartJson += '\t$itemJson,\n';
    // }
    // cartJson += "]";
    String cartJSON = jsonEncode(listCart);
    return file.writeAsString(cartJSON);
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }
}
