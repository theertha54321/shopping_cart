import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controller/cart_controller.dart';
import 'package:shopping_cart_may/controller/product_details_screen_controller.dart';
import 'package:shopping_cart_may/view/cart_screen/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
 final int id;
  const ProductDetailsScreen({super.key,required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}
class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
     
      await context.read<ProductDetailsScreenController>().getSingleProducts(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productDetailScreenState = context.watch<ProductDetailsScreenController>();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Discover",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
        ),
        actions: [
          Stack(
            children: [
              Icon(
                Icons.notifications_none,
                color: Colors.black,
                size: 40,
              ),
              Positioned(
                right: 5,
                top: 5,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.black,
                  child: Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: productDetailScreenState.issingleProductLoading == true ?
      Center(
        child: CircularProgressIndicator(),
      )
      :
      
      
      Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    alignment: Alignment.topRight,
                    height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              productDetailScreenState.singleProductList?.image.toString() ?? ""))),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(6, 10),
                                blurRadius: 10,
                                color: Colors.black.withOpacity(.5))
                          ]),
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.favorite_outline,
                        size: 30,
                      ),
                    ),
                  ),
                  Text(
                    productDetailScreenState.singleProductList?.title.toString() ?? "",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${productDetailScreenState.singleProductList?.rating?.rate}/5 Rating",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    productDetailScreenState.singleProductList?.description.toString() ?? "",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      "RS ${productDetailScreenState.singleProductList?.price}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
                SizedBox(width: 50),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      
                      if(productDetailScreenState.singleProductList?.id != null){
                      context.read<CartController>().addItems(
                        context: context,
                        name:productDetailScreenState.singleProductList?.title ?? "" , 
                        des: productDetailScreenState.singleProductList?.description ?? "", 
                        productId: productDetailScreenState.singleProductList!.id!, 
                        imagurl:productDetailScreenState.singleProductList?.image ?? "" , 
                        price: productDetailScreenState.singleProductList?.price ?? 0.0).then((value) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ));
                        },);
                    }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_mall_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
