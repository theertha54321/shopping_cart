import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class CartController with ChangeNotifier {

 static late Database database;
 List<Map> cartItems = [];
 double totalPrice = 0.0;
 static Future<void> initializeDatabase() async {
if (kIsWeb) {
  // Change default factory on the web
  databaseFactory = databaseFactoryFfiWeb;
}

  database = await openDatabase("cart.db",version: 1,onCreate: (db, version) async {
     await db.execute(
      'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, price REAL,image TEXT, des TEXT, productId INTEGER)');
  },); 
 }

 Future<void> addItems({
  required BuildContext context,
  required String name, 
  required String des, 
  required int productId,
  required String imagurl,
  required double price,
  }) async {
    await getAllItem();
    bool alreadyInCart = false;
    for(int i = 0; i < cartItems.length; i++){
      if(cartItems[i]["productId"] == productId){
        alreadyInCart = true;
      }
    }
    if(alreadyInCart == false){
    await database.rawInsert(
      'INSERT INTO Cart(name, qty, price, image, des, productId) VALUES(?, ?, ?, ?, ?, ?)',
      [name, 1, price, imagurl, des, productId]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("item added to cart")));
 } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Already in cart")));
 }
 }
  
 
 
 Future getAllItem() async {
   cartItems = await database.rawQuery('SELECT * FROM Cart');
   calculateTotal();
  log(cartItems.toString());
  notifyListeners();
 }

 Future removeAnItem(int id) async {
  await database
    .rawDelete('DELETE FROM Cart WHERE id = ?', [id]);
    await getAllItem();
    notifyListeners();
 }




 decrementQty(int qty, int id) async {
if(qty >= 2){
  qty--;
  await database.rawUpdate(
    'UPDATE Cart SET qty = ? WHERE id = ?',
    [qty,id]);
   await getAllItem();
}
 }


 incrementQty(int qty, int id) async {
  qty++;
  await database.rawUpdate(
    'UPDATE Cart SET qty = ? WHERE id = ?',
    [qty,id]);
   await getAllItem();
}

void calculateTotal(){
  totalPrice = 0.0;
  for(int i = 0 ; i<cartItems.length; i++){
    double currentItemPrice = cartItems[i]["qty"] * cartItems[i]["price"];
    totalPrice = totalPrice + currentItemPrice;
   }
   notifyListeners();
}
 }
