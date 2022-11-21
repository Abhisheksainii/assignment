// ignore_for_file: prefer_const_constructors

import 'package:assignment/modal/product_model.dart';
import 'package:assignment/services/cart_provider.dart';
import 'package:assignment/views/cart_screen.dart';
import 'package:assignment/views/product.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    API().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<API>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Products")),
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const CartScreen();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: ((context, value, child) {
                    return Text(
                      value.counter.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  })),
                  child: const Icon(Icons.shopping_bag),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: FutureBuilder<List<Product>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProductGrid(snapshot: snapshot);
          }
          return const Text("error");
        },
        future: api.getProducts(),
      )),
    );
  }
}

class ProductGrid extends StatefulWidget {
  const ProductGrid({Key? key, required this.snapshot}) : super(key: key);
  final AsyncSnapshot snapshot;
  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 5,
              mainAxisSpacing: 15),
          itemCount: widget.snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MainProduct(
                    productName: widget.snapshot.data![index].title,
                    id: widget.snapshot.data![index].id,
                    index: index,
                    price: widget.snapshot.data![index].price,
                    title: widget.snapshot.data![index].title,
                    rating: widget.snapshot.data![index].rating,
                    imageid: widget.snapshot.data![index].imageid,
                    descritption: widget.snapshot.data[index].description,
                  );
                }));
              },
              child: SizedBox(
                width: 500,
                height: 80,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child:
                            Image.network(widget.snapshot.data![index].imageid),
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 50,
                            child: Text("Description: " +
                                widget.snapshot.data![index].description),
                          ),
                          Text("Category: " +
                              widget.snapshot.data![index].category),
                          Text(
                            "price: " +
                                widget.snapshot.data![index].price.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
