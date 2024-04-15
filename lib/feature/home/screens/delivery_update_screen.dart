import 'dart:io';
import 'dart:ui';

import 'package:ampm_app/const/app_colors.dart';
import 'package:ampm_app/const/app_config.dart';
import 'package:ampm_app/const/delivery_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../const/app_text.dart';
import '../controllers/delivery_update_controller.dart';
import '../models/delivery_detail_model.dart';
import '../widgets/custom_time_button.dart';
import '../widgets/delivery_status_menu.dart';
import 'home_screen.dart';

class DeliveryUpdateScreen extends StatelessWidget {
  const DeliveryUpdateScreen({super.key, required this.detail});

  final DeliveryDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryUpdateController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        /// app bar
        appBar: AppBar(
          title: const Text('Delivery Update'),
          leading: IconButton(
              onPressed: () {
                if (!controller.isDelivered.value) {
                  Get.back();
                } else {
                  Get.offAll(() => const HomeScreen());
                }
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// delivery details
                    Text(
                      'Tracking # ${detail.trackingNo}',
                      style: const TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      detail.consigneeName,
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      detail.dropOffAddress,
                      style: const TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      'Packages: ${detail.noPackages}',
                      style: const TextStyle(fontSize: 13.0),
                    ),
                    Obx(
                      () => SizedBox(
                        height: !controller.isDelivered.value ? 15.0 : 0.0,
                      ),
                    ),

                    ///Remarks
                    Obx(
                      () => !controller.isDelivered.value
                          ? TextField(
                              controller: controller.remarkController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2.0,
                                    color: Color(0XFFE76E20),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: 'Enter Remarks',
                                hintStyle: const TextStyle(fontSize: 12.0),
                              ),
                            )
                          : Text(
                              'Remarks: ${controller.remarkController.text.toString()}',
                              style: const TextStyle(fontSize: 13.0),
                            ),
                    ),
                    Obx(
                      () => SizedBox(
                        height: !controller.isDelivered.value ? 15.0 : 0.0,
                      ),
                    ),

                    ///delivery status, date and time
                    Obx(
                      () => !controller.isDelivered.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 140.0,
                                  child: DeliveryStatusDDMenu(
                                      onChanged:
                                          controller.changeDeliveryStatus),
                                ),
                                // Obx(
                                //   () => CustomTimeButton(
                                //     icon: Icons.calendar_month,
                                //     title: AppText.selectDate,
                                //     subtitle: controller.currentDate.value,
                                //     onTap: () => controller.selectDate(),
                                //   ),
                                // ),
                                Obx(
                                  () => CustomTimeButton(
                                    icon: Icons.access_time,
                                    title: AppText.selectTime,
                                    subtitle: controller.currentTime.value,
                                    onTap: () => controller.selectTime(),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status: ${controller.deliveryStatus.value}',
                                  style: const TextStyle(fontSize: 13.0),
                                ),
                                Text(
                                  'Delivered at: ${controller.currentDate.value} ${controller.currentTime.value}',
                                  style: const TextStyle(fontSize: 13.0),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    /// update button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isDelivered.value
                              ? (controller.imageFiles.isEmpty
                                  ? null
                                  : () {
                                      controller.updateDeliveryImages(detail);
                                    })
                              : () {
                                  controller.updateDelivery(detail);
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: const Color(0XFFFFFFFF)),
                          child: Text(controller.isDelivered.value
                              ? AppText.upload
                              : AppText.update),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10.0,
                    // ),

                    /// add photo button and photos
                    Obx(() {
                      if (controller.pickedImagePath.value.isEmpty ||
                          controller.deliveryStatus.value !=
                              DeliveryStatus.delivered.name) {
                        return const SizedBox();
                      } else {
                        return Container(
                          width: double.infinity,
                          height: 300.0,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: List<Widget>.generate(
                                    controller.imageFiles.length,
                                    (index) => ImageViewer(
                                      imageProvider: FileImage(controller.imageFiles[index]),
                                      isDeletable: true,
                                      onTapDelete: () => controller.imageFiles
                                          .removeAt(index),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Obx(
                      () => (controller.deliveryStatus.value ==
                                  DeliveryStatus.delivered.name &&
                              controller.isDelivered.value)
                          ? ElevatedButton(
                              onPressed: controller.imageFiles.length < AppConfig.maxAllowableImages
                                  ? () async {
                                      await controller
                                          .pickImage(ImageSource.camera);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: const Color(0XFFFFFFFF)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    AppText.addPhoto,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              Obx(
                () => controller.isLoaded.value
                    ? Positioned(
                        // Position it at the center of the screen
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Colors.white.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.imageProvider,
    this.isDeletable = true,
    this.onTapDelete,
  });

  final ImageProvider imageProvider;
  final Function()? onTapDelete;
  final bool isDeletable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              image: imageProvider,
              fit: BoxFit.cover,
              width: 200.0,
            ),
          ),
        ),
        if(isDeletable)Positioned(
          top: 0.0,
          right: 0.0,
          child: InkWell(
            onTap: onTapDelete,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.2),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
