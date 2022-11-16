import 'package:file_project/file/file.dart';
import 'package:flutter/material.dart';
import 'package:file_project/cart/cart.dart';
import 'package:file_project/product/product_model.dart';
import 'package:file_project/product/product_provider.dart';
import 'package:file_project/product_detail/product_detail.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late CartFile cartfile;
  final _searchKey = TextEditingController();
  String cartJSON = '';

  bool showGrid = true;
  List<ProductModel> listProduct = [];
  List<String> listCategories = [];
  List<ProductModel> listCart = [];
  int numberCar = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartfile = CartFile();
    cartfile.readCounter().then((value) {
      setState(() {
        cartJSON = value;
        print(cartJSON);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<ProductProvider>(context);
    if (productProvider.list.isEmpty &&
        productProvider.listCategories.isEmpty) {
      productProvider.getList();
      productProvider.getCategories();
    }
    if (listProduct.isEmpty && listCategories.isEmpty) {
      listProduct = [...productProvider.list];
      listCategories = [...productProvider.listCategories];
      listCart = productProvider.listCart;
    }
    numberCar = productProvider.listCart.length;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Danh mục",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
            ),
            SizedBox(
              height: 4,
            ),
            buildListCategory(context, productProvider),
            SizedBox(
              height: 10,
            ),
            buildSearch(context, productProvider),
            SizedBox(
              height: 10,
            ),
            buildIconButton(context),
            showGrid
                ? buildGridView(context, productProvider)
                : buildList(context, productProvider),
          ],
        ),
      ),
    );
  }

  buildIconButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              showGrid = false;
            });
          },
          icon: Icon(Icons.list),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                showGrid = true;
              });
            },
            icon: Icon(Icons.grid_view))
      ],
    );
  }

  buildListCategory(BuildContext context, ProductProvider productProvider) {
    return Container(
      height: 80,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...listCategories.map((e) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 20, 4),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      listProduct = [...productProvider.list];
                      listProduct
                          .retainWhere((element) => element.category == e);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  buildSearch(BuildContext context, ProductProvider productProvider) {
    return Row(
      children: [
        SizedBox(
            height: 36,
            width: 142,
            child: Container(
              child: TextField(
                maxLines: 1,
                style: TextStyle(fontSize: 16),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).iconTheme.color),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  contentPadding: EdgeInsets.only(right: 4),
                  hintText: 'Search',
                ),
                controller: _searchKey,
              ),
            )),
        SizedBox(
          width: 8,
        ),
        TextButton(
          onPressed: () {
            listProduct = [...productProvider.list];
            setState(() {
              listProduct.sort(
                (a, b) => a.price!.toDouble().compareTo(b.price!.toDouble()),
              );
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            "Min",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        TextButton(
          onPressed: () {
            listProduct = [...productProvider.list];
            setState(() {
              listProduct.sort(
                (a, b) => b.price!.toDouble().compareTo(a.price!.toDouble()),
              );
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            "Max",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        TextButton(
          onPressed: () {
            listProduct = [...productProvider.list];
            setState(() {
              listProduct.retainWhere((element) => (element.category!
                      .toLowerCase()
                      .contains(_searchKey.text.toLowerCase()) ||
                  element.title!
                      .toLowerCase()
                      .contains(_searchKey.text.toLowerCase())));
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
          child: Text(
            "Lọc",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) =>
                    (CartStore(listCart: productProvider.listCart))),
              ),
            );
          },
          icon: Icon(Icons.shopping_cart),
        ),
        Text(
          '${numberCar}',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  buildList(BuildContext context, ProductProvider productProvider) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ...listProduct.map((e) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => (ProductDetail(
                          product: e,
                          numberCar: numberCar,
                        ))),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.network(
                        e.image ?? "",
                        fit: BoxFit.cover,
                        height: 200,
                        width: 200,
                      ),
                      Text(
                        e.title ?? "Title is null",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${e.price.toString()}' ?? '00.00',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            e.category ?? '',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          productProvider.getListCart(e);
                          setState(() {
                            numberCar = productProvider.listCart.length;
                          });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: ((context) => (CartStore(
                          //         listCart: productProvider.listCart))),
                          //   ),
                          // );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Text(
                          "Add to cart",
                          style: TextStyle(
                            fontSize: 16,
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
          }).toList()
        ],
      ),
    );
  }

  buildGridView(BuildContext context, ProductProvider productProvider) {
    return Expanded(
      child: GridView.count(
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          ...listProduct.map((e) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => (ProductDetail(
                          product: e,
                          numberCar: numberCar,
                        ))),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0)),
                child: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      Image.network(
                        e.image ?? "",
                        fit: BoxFit.cover,
                        height: 108,
                        width: 108,
                      ),
                      Text(
                        e.title ?? "Title is null",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${e.price.toString()}' ?? '00.00',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            e.category ?? '',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      TextButton(
                        onPressed: () {
                          productProvider.getListCart(e);
                          cartfile.writeCounter(productProvider.listCart);
                          setState(() {
                            numberCar = productProvider.listCart.length;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Text(
                          "Add to cart",
                          style: TextStyle(
                            fontSize: 12,
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
          }).toList()
        ],
      ),
    );
  }
}
