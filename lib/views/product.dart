import 'package:assignment/modal/cart_model.dart';
import 'package:assignment/services/cart_provider.dart';
import 'package:assignment/services/dphelper.dart';
import 'package:assignment/views/cart_screen.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainProduct extends StatefulWidget {
  const MainProduct(
      {Key? key,
      required this.index,
      required this.id,
      required this.imageid,
      required this.descritption,
      required this.productName,
      required this.price,
      required this.title,
      required this.rating})
      : super(key: key);
  final String imageid;
  final dynamic price;
  final int index;
  final int id;
  final String title;
  final String productName;
  final Map rating;
  final String descritption;
  @override
  State<MainProduct> createState() => _MainProductState();
}

class _MainProductState extends State<MainProduct> {
  DBhelper dBhelper = DBhelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Products"),
        centerTitle: true,
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
                      style:const TextStyle(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.network(widget.imageid)),
              const SizedBox(
                height: 20.0,
              ),
              Text(widget.title),
              const SizedBox(
                height: 20.0,
              ),
              Flexible(child: Text(widget.descritption)),
              const SizedBox(
                height: 30.0,
              ),
              Text(widget.price.toString()),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 40,
                width: 100,
                color: Colors.blue,
                child: InkWell(
                    onTap: () {
                      dBhelper
                          .insert(Cart(
                              id: widget.index,
                              productId: widget.index.toString(),
                              productName: widget.productName,
                              image: widget.imageid,
                              initialPrice: widget.price,
                              productPrice: widget.price,
                              quantity: 1))
                          .then((value) {
                        cart.addTotalPrice(widget.price);
                        cart.addItem();
                      }).onError((error, stackTrace) {
                        print(error);
                      });
                    },
                    child: const Center(child: Text("Add To Cart"))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
