import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/order_screen/order_details.dart';

import 'package:ecommerce_app/views/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "My Orders".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      backgroundColor: whiteColor,
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No orders yet!"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  leading: "${index + 1}"
                      .text
                      .fontFamily(bold)
                      .color(darkFontGrey)
                      .xl
                      .make(),
                  title: data[index]['order_code']
                      .toString()
                      .text
                      .color(amberColor)
                      .fontFamily(semibold)
                      .make(),
                  subtitle: data[index]['total_ammount']
                      .toString()
                      .numCurrency
                      .text
                      .fontFamily(bold)
                      .make(),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: () {
                      
                      Get.to(() => OrderDetails(
                            data: data[index],
                          ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
