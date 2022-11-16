import 'package:flutter/material.dart';
import 'package:file_project/product/product_list_page.dart';
import 'package:file_project/product/product_model.dart';

class CartStore extends StatefulWidget {
  final List<ProductModel> listCart;

  const CartStore({super.key, required this.listCart});

  @override
  State<CartStore> createState() => _CartStoreState();
}

class _CartStoreState extends State<CartStore> {
  @override
  Widget build(BuildContext context) {
    double total = 0;
    widget.listCart.forEach((element) {
      total += element.price!.toDouble() * element.quantity!.toDouble();
    });
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cart Store')),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 620,
            child: buildProductView(context, widget.listCart),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, top: 12, right: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total: ",
                  style: TextStyle(fontSize: 30),
                ),
                Text('${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 400,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.listCart.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => (ProductListPage())),
                    ),
                  );
                },
                child: const Text(
                  "Check Out",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildProductView(BuildContext context, List<ProductModel> listCart) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ...listCart.map((e) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 60, width: 60, child: Image.network(e.image ?? "")),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          e.title ?? "Title is null",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          '${e.quantity}',
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              e.quantity = (e.quantity! + 1);
                            });
                          },
                          icon: Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              if (e.quantity! <= 1) {
                                listCart.remove(e);
                              } else
                                e.quantity = (e.quantity! - 1);
                            });
                          },
                          icon: Icon(Icons.remove))
                    ],
                  ),
                ),
              ],
            );
          }).toList()
        ],
      ),
    );
  }
}
