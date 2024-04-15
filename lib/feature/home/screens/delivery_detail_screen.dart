import 'package:ampm_app/const/app_config.dart';
import 'package:ampm_app/const/delivery_status.dart';
import 'package:ampm_app/feature/home/controllers/delivery_detail_controller.dart';
import 'package:ampm_app/feature/home/models/delivery_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../const/app_colors.dart';
import '../../../const/app_text.dart';
import 'delivery_update_screen.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final DeliveryDetailModel detail;

  const DeliveryDetailScreen({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(DeliveryDetailController(detail.id, detail.trackingNo));
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppText.deliveryDetails),
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
        
                  ///Remarks
                  Text(
                    'Remarks: ${detail.remarks ?? ''}',
                    style: const TextStyle(fontSize: 13.0),
                  ),
        
                  ///delivery status, date and time
                  Text(
                    'Status: ${detail.status}',
                    style: const TextStyle(fontSize: 13.0),
                  ),
                  Text(
                    'Delivered at: ${DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(detail.deliveredAt ?? ''))}',
                    style: const TextStyle(fontSize: 13.0),
                  ),
        
                  const SizedBox(
                    height: 15.0,
                  ),
        
                  ///upload button
                  if (detail.status == DeliveryStatus.delivered.name)
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (controller.imageProviders.any(
                                    (ImageProvider imageProvider) =>
                                        imageProvider.runtimeType == FileImage))
                                ? () {
                                    controller.updateDeliveryImages(detail);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: const Color(0XFFFFFFFF)),
                            child: const Text(
                              AppText.upload,
                            ),
                          ),
                        )),
                  Obx(
                    () => (!controller.isLoading.value &&
                            detail.status == DeliveryStatus.delivered.name &&
                            controller.imageProviders.isNotEmpty)
                        ? Container(
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
                                      controller.imageProviders.length,
                                      (index) => ImageViewer(
                                        imageProvider:
                                            controller.imageProviders[index],
                                        onTapDelete: () =>
                                            controller.removeImage(index),
                                        isDeletable: controller
                                                .imageProviders[index]
                                                .runtimeType ==
                                            FileImage,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
        
                  if (detail.status == DeliveryStatus.delivered.name)
                    Obx(() => ElevatedButton(
                          onPressed: controller.imageProviders.length <
                                  AppConfig.maxAllowableImages
                              ? () {
                                  controller.pickImage(ImageSource.camera);
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
                        )),
                ],
              ),
            ),
            Obx(() => controller.isLoading.value
                ? Positioned(
                    // Position it at the center of the screen
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white.withOpacity(1.0),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
