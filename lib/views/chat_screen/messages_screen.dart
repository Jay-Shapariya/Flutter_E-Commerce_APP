import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/views/chat_screen/chat_screen.dart';
import 'package:ecommerce_app/views/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            "My Messages".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      backgroundColor: whiteColor,
      body: StreamBuilder(
        stream: FirestoreServices.getAllChatMessages(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No messages yet!"
                .text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Get.to(() => const ChatScreen(), arguments: [
                              data[index]['friend_name'].toString(),
                              data[index]['toId']
                            ]);
                          },
                          leading: const CircleAvatar(
                            backgroundColor: amberColor,
                            child: Icon(
                              Icons.person,
                              color: whiteColor,
                            ),
                          ),
                          title: "${data[index]['friend_name']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          subtitle: "${data[index]['last_msg']}".text.make(),
                        ),
                      );
                    },
                  ))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
