import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/consts/lists.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/controllers/profile_controller.dart';
import 'package:ecommerce_app/services/firestore_services.dart';

import 'package:ecommerce_app/views/auth_screen/login_screen.dart';
import 'package:ecommerce_app/views/chat_screen/messages_screen.dart';
import 'package:ecommerce_app/views/order_screen/order_screen.dart';
import 'package:ecommerce_app/views/profile_screen/components/details_card.dart';
import 'package:ecommerce_app/views/profile_screen/edit_profile.dart';
import 'package:ecommerce_app/views/widgets_common/bg_widget.dart';
import 'package:ecommerce_app/views/widgets_common/loading_indicator.dart';
import 'package:ecommerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(amberColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: const Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.edit,
                            color: whiteColor,
                          )).onTap(() {
                        controller.nameController.text = data['name'];

                        Get.to(EditProfile(
                          data: data,
                        ));
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] == ""
                              ? Image.asset(
                                  imgProfile,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                              : Image.network(
                                  data['imageUrl'],
                                  width: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),
                          10.widthBox,
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              "${data['email']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                            ],
                          )),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                color: whiteColor,
                              )),
                              onPressed: () async {
                                await Get.put(AuthController())
                                    .signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              child: "Log out"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make())
                        ],
                      ),
                    ),
                    20.heightBox,
                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(!snapshot.hasData){
                          return Center(child: loadingIndicator(),);
                        }
                        else{
                          var countData = snapshot.data;
                          return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: countData[0].toString(),
                                width: context.screenWidth / 3.4,
                                title: "in your cart"),
                            detailsCard(
                                count: countData[1].toString(),
                                width: context.screenWidth / 3.4,
                                title: "in your wishlist"),
                            detailsCard(
                                count: countData[2].toString(),
                                width: context.screenWidth / 3.4,
                                title: "your orders"),
                          ],
                        );
                        }
                        
                      },
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(
                    //         count: data['cart_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "in your cart"),
                    //     detailsCard(
                    //         count: data['wishlist_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "in your wishlist"),
                    //     detailsCard(
                    //         count: data['order_count'],
                    //         width: context.screenWidth / 3.4,
                    //         title: "your orders"),
                    //   ],
                    // ),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrderScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                Get.to(() => const MessageScreen());
                                break;
                            }
                          },
                          title: profileButtonList[index]
                              .text
                              .color(darkFontGrey)
                              .fontFamily(semibold)
                              .make(),
                          leading: Image.asset(
                            profileButtonIcon[index],
                            width: 22,
                          ),
                        );
                      },
                    )
                        .box
                        .white
                        .shadowSm
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .make()
                        .box
                        .color(const Color.fromARGB(255, 255, 150, 0))
                        .make()
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
