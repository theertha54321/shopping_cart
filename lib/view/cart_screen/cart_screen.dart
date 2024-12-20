import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
import 'package:shopping_cart_may/controller/cart_controller.dart';
import 'package:shopping_cart_may/main.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    await  context.read<CartController>().getAllItem();
    },);
    // setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartScreenState = context.watch<CartController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    title: cartScreenState.cartItems[index]["name"],
                    desc: cartScreenState.cartItems[index]["price"].toString(),
                    qty: cartScreenState.cartItems[index]["qty"].toString(),
                    image:cartScreenState.cartItems[index]["image"],
                    onIncrement: () {
                      context.read<CartController>().incrementQty(cartScreenState.cartItems[index]["qty"], cartScreenState.cartItems[index]["id"]);
                    },
                    onDecrement: () {
                      context.read<CartController>().decrementQty(cartScreenState.cartItems[index]["qty"], cartScreenState.cartItems[index]["id"]);
                    },
                    onRemove: () {
                      context.read<CartController>().removeAnItem(cartScreenState.cartItems[index]["id"]);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: cartScreenState.cartItems.length)),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.grey),
                    height: 60,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text("Total :"),Text("${cartScreenState.totalPrice.toStringAsFixed(2)}"),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                           Razorpay razorpay = Razorpay();
                            var options = {
                            'key': 'rzp_test_1DP5mmOlF5G5ag',
                  'amount': cartScreenState.totalPrice * 100,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': false, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com'
                  },
                  'external': {
                    'wallets': ['paytm']
                  }
                };
                razorpay.on(
                  Razorpay.EVENT_PAYMENT_ERROR,
                  handlePaymentErrorResponse,
                );
                razorpay.on(
                  Razorpay.EVENT_PAYMENT_SUCCESS,
                  handlePaymentSuccessResponse,
                );
                razorpay.on(
                  Razorpay.EVENT_EXTERNAL_WALLET,
                  handleExternalWalletSelected,
                );
                razorpay.open(options);
              
                        }, child: Text("Checkout"))
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    // PaymentFailureResponse contains three values:
    // 1. Error Code
    // 2. Error Description
    // 3. Metadata
    showAlertDialog(
      context,
      'Payment Failed',
      'Code: ${response.code}\n'
          'Description: ${response.message}\n'
          'Metadata: ${response.error.toString()}',
    );
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    // PaymentSuccessResponse contains three values:
    // 1. Order ID
    // 2. Payment ID
    // 3. Signature
    showAlertDialog(
      context,
      'Payment Successful',
      'Payment ID: ${response.paymentId}',
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
      context,
      'External Wallet Selected',
      '${response.walletName}',
    );
  }
void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }
}
