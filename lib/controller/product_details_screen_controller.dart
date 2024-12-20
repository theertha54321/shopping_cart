



import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';
import 'package:shopping_cart_may/models/all_products_model.dart';

class ProductDetailsScreenController with ChangeNotifier{

bool issingleProductLoading = false;
AllproductModel? singleProductList;

Future<void> getSingleProducts({int? id}) async{
    String endUrl =  "products/$id";
    final url = Uri.parse(AppConfig.baseUrl + endUrl);
    log("Fetching product details for ID: $id");
    log(url.toString());
    try{
      issingleProductLoading= true;
      notifyListeners();
      
     final response= await http.get(url);
     if(response.statusCode==200){
     singleProductList =  AllproductModel.fromJson(jsonDecode(response.body));
     log(response.body);
    
    
    }
    }  
    catch(e){

    }
    issingleProductLoading=false;
    notifyListeners();

   
    
  }

  


}