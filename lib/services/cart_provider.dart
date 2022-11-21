import 'package:assignment/modal/cart_model.dart';
import 'package:assignment/services/dphelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBhelper dBhelper = DBhelper();

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getdata() async {
    _cart = dBhelper.getcartlist();
    return _cart;
  }

  void setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addItem() async {
    _counter++;
    setPrefs();
    notifyListeners();
  }

  void removeItem() async {
    if (_counter < 0) {
      _counter = 0;
    } else {
      _counter--;
    }
    setPrefs();
    notifyListeners();
  }

  int getCounter() {
    getPrefs();
    return _counter;
  }

  void addTotalPrice(double price) async {
    _totalPrice += price;
    setPrefs();
    notifyListeners();
  }

  void removeTotalPrice(double price) async {
    if (_totalPrice < 0) {
      _totalPrice = 0;
    } else {
      _totalPrice -= price;
    }
    setPrefs();
    notifyListeners();
  }

  double getTotalPrice() {
    getPrefs();
    return _totalPrice;
  }
}
