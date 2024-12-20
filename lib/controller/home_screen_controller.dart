import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';
import 'package:shopping_cart_may/models/all_products_model.dart';

class HomeScreenController with ChangeNotifier{

   bool isLoading = false;
   bool isProductLoading = false;
   int selectedCategoryIndex = 0; 
   List categories = [];
   List<AllproductModel> productList = [];
   

  Future<void> getCategories() async{
    final url = Uri.parse(AppConfig.baseUrl + "products/categories");
    try{
      isLoading= true;
      notifyListeners();
     final response= await http.get(url);
     if(response.statusCode==200){
     
     categories = jsonDecode(response.body);
     categories.insert(0, "ALL"); // to add "ALL" category to category list
     log(response.body);
    }
    }  
    catch(e){

    }
    isLoading=false;
    notifyListeners();
  }

 
  
  Future<void> getProducts({String? category}) async{
    String endUrl = 
    category == null ? "products" : "products/category/$category";
    final url = Uri.parse(AppConfig.baseUrl + endUrl);
    log(url.toString());
    try{
      isProductLoading= true;
      notifyListeners();
      
     final response= await http.get(url);
     if(response.statusCode==200){
     productList =  allproductModelFromJson(response.body);
    
    
    }
    }  
    catch(e){

    }
    isProductLoading=false;
    notifyListeners();
    
  }



  



   Future<void> onCategorySelection( {required int clickedIndex}) async{
    selectedCategoryIndex=clickedIndex;
    log(selectedCategoryIndex.toString());
    getProducts(category: selectedCategoryIndex==0 ? null : categories[selectedCategoryIndex]);
    notifyListeners();

  }
  
}


