import 'package:ampm_app/const/app_text.dart';
import 'package:ampm_app/const/delivery_status.dart';
import 'package:ampm_app/feature/home/controllers/home_controller.dart';
import 'package:ampm_app/feature/home/screens/delivery_detail_screen.dart';
import 'package:ampm_app/feature/home/widgets/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/delivery_detail_model.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/detail_tile.dart';
import 'delivery_update_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
        appBar: AppBar(
          title: Obx(() => Text(
                controller.title.value,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 23,
                      fontWeight: FontWeight.normal,
                    ),
              )),
          iconTheme:
              IconThemeData(color: const Color(0XFF171717).withOpacity(0.71)),
        ),
        drawer: Obx(() => CustomDrawer(
          firstName: controller.firstName.value,
          lastName: controller.lastName.value,
          items: [
            DrawerItem(
              title: AppText.nextDeliveriesTitle,
              icon: Icons.local_shipping_outlined,
              onTap: () {
                controller.changeTitle(AppText.nextDeliveriesTitle);
              },
            ),
            DrawerItem(
              title: AppText.completed,
              icon: Icons.done_all,
              onTap: () {
                controller.changeTitle(AppText.completed);
              },
            ),
            DrawerItem(
              title: AppText.logout,
              icon: Icons.logout,
              onTap: () => controller.logout(),
            ),
          ],
        )),
        body: Obx(
          () => FutureBuilder(
            future: controller.title.value == AppText.nextDeliveriesTitle
                ? controller.getNextDeliveriesData()
                : controller.getCompletedDeliveriesData(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>?> asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final data = asyncSnapshot.data;
                if (data == null || data.isEmpty) {
                  return const Center(child: Text('No data found'));
                } else {
                  return ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      final DeliveryDetailModel detailModel =
                          DeliveryDetailModel.fromMap(data[index]);
                      return DetailTile(
                          detailModel: detailModel,
                          onTap: () {
                            if (detailModel.status ==
                                DeliveryStatus.outForDelivery.name) {
                              Get.to(() =>
                                  DeliveryUpdateScreen(detail: detailModel));
                            }else{
                              Get.to(() => DeliveryDetailScreen(detail: detailModel,));
                            }
                          });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        indent: 20.0,
                        endIndent: 20.0,
                      );
                    },
                    itemCount: data.length,
                  );
                }
              }
            },
          ),
        ));
  }
}
