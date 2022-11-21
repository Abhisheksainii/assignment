// ignore_for_file: prefer_const_constructors

import 'package:assignment/modal/cart_model.dart';
import 'package:assignment/services/cart_provider.dart';
import 'package:assignment/services/dphelper.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: InkWell(
              onTap: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   return const CartScreen();
                // }));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Badge(
                  badgeContent:
                      Consumer<CartProvider>(builder: ((context, value, child) {
                    return Text(
                      value.counter.toString(),
                      style: const TextStyle(
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
        title: const Center(
          child: Text("My Products"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getdata(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        width: 100,
                                        height: 80,
                                        image: NetworkImage(
                                          snapshot.data![index].image
                                              .toString(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    snapshot.data![index]
                                                        .productName
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    DBhelper().delete(snapshot
                                                        .data![index].id!);
                                                    cart.removeItem();
                                                    cart.removeTotalPrice(
                                                        snapshot.data![index]
                                                            .productPrice);
                                                  },
                                                  icon: Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data![index].productPrice
                                                      .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  color: Colors.blue,
                                                  child: InkWell(
                                                      onTap: () {},
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                decrementQuantity(
                                                                    snapshot,
                                                                    index,
                                                                    cart);
                                                              },
                                                              child: Icon(Icons
                                                                  .remove)),
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .quantity
                                                                .toString(),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                incrementQuantity(
                                                                    snapshot,
                                                                    index,
                                                                    cart);
                                                              },
                                                              child: Icon(
                                                                  Icons.add)),
                                                        ],
                                                      )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Consumer<CartProvider>(
              builder: (context, value, child) {
                return Visibility(
                  visible: value.totalPrice == 0 || value.totalPrice == 0.0
                      ? false
                      : true,
                  child: PriceRow(
                      text: "Sub total: ",
                      value: value.getTotalPrice().toStringAsFixed(2)),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void incrementQuantity(
      AsyncSnapshot<List<Cart>> snapshot, int index, CartProvider cart) {
    int quantity = snapshot.data![index].quantity!;

    dynamic price = snapshot.data![index].initialPrice;

    quantity++;
    dynamic newprice = quantity * price;

    DBhelper()
        .update(Cart(
            productId: snapshot.data![index].productId,
            id: snapshot.data![index].id,
            productName: snapshot.data![index].productName,
            image: snapshot.data![index].image,
            initialPrice: snapshot.data![index].initialPrice,
            productPrice: newprice,
            quantity: quantity))
        .then((value) {
      newprice = 0;
      quantity = 0;
      cart.addTotalPrice(snapshot.data![index].initialPrice);
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  void decrementQuantity(
      AsyncSnapshot<List<Cart>> snapshot, int index, CartProvider cart) {
    int quantity = snapshot.data![index].quantity!;

    dynamic price = snapshot.data![index].initialPrice;

    if (quantity > 0) {
      quantity--;
    } else {
      quantity = 0;
    }
    dynamic newprice = quantity * price;

    DBhelper()
        .update(Cart(
            productId: snapshot.data![index].productId,
            id: snapshot.data![index].id,
            productName: snapshot.data![index].productName,
            image: snapshot.data![index].image,
            initialPrice: snapshot.data![index].initialPrice,
            productPrice: newprice,
            quantity: quantity))
        .then((value) {
      newprice = 0;
      quantity = 0;
      cart.removeTotalPrice(snapshot.data![index].initialPrice);
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({Key? key, required this.text, required this.value})
      : super(key: key);
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
