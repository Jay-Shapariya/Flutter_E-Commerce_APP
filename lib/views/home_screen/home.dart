import 'package:ecommerce_app/consts/consts.dart';
import 'package:ecommerce_app/controllers/home_controller.dart';
import 'package:ecommerce_app/views/cart_screen/cart_screen.dart';
import 'package:ecommerce_app/views/category_screen/category_screen.dart';
import 'package:ecommerce_app/views/home_screen/home_screen.dart';
import 'package:ecommerce_app/views/profile_screen/profile_screen.dart';
import 'package:ecommerce_app/views/widgets_common/exit_dialog.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(
          icon: Image.asset(
            icHome,
            width: 26,
          ),
          label: home),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCategories,
            width: 26,
          ),
          label: category),
      BottomNavigationBarItem(
          icon: Image.asset(
            icCart,
            width: 26,
          ),
          label: cart),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProfile,
            width: 26,
          ),
          label: account),
    ];
    var navBody = [
      const HomeScreen(),
      const CategoryScreen(),
      const CartScreen(),
      const  ProfileScreen(),
    ];
    return WillPopScope(
      onWillPop: () async{
        showDialog(context: context,
        barrierDismissible: false, 
        builder: (context)=>exitDialog(context));
        return false;
      },
      child: Scaffold(
        
        body: Column(
          children: [
            Obx(
              () => Expanded(
                child: navBody.elementAt(controller.curruntNavIndex.value),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.curruntNavIndex.value,
            items: navbarItem,
            backgroundColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: amberColor,
            selectedLabelStyle: const TextStyle(fontFamily: semibold),
            onTap: (value) {
              controller.curruntNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
