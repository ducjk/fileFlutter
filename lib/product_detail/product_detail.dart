import 'package:flutter/material.dart';
import 'package:file_project/cart/cart.dart';
import 'package:file_project/product/product_model.dart';
import 'package:file_project/product/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  final ProductModel product;
  final int numberCar;
  const ProductDetail(
      {super.key, required this.product, required this.numberCar});

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Product Detail")),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Image.network(
                product.image ?? "",
                fit: BoxFit.cover,
                height: 280,
                width: 280,
              ),
              Text(
                product.title ?? "Title is null",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${product.price.toString()}' ?? '00.00',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    product.category ?? '',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 80,
              ),
              TextButton(
                onPressed: () {
                  productProvider.getListCart(product);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) =>
                          (CartStore(listCart: productProvider.listCart))),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text(
                  "Add to cart",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
