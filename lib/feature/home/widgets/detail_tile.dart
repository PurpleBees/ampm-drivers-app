import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import '../models/delivery_detail_model.dart';

class DetailTile extends StatelessWidget {
  const DetailTile({
    super.key,
    required this.detailModel,
    this.onTap,
  });

  final DeliveryDetailModel detailModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(detailModel.consigneeName, style: const TextStyle(fontSize: 20.0),),
            Text(detailModel.dropOffAddress, style: const TextStyle(fontSize: 13.0),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tracking # ${detailModel.trackingNo}', style: const TextStyle(fontSize: 13.0),),
                Text('Packages: ${detailModel.noPackages}', style: const TextStyle(fontSize: 13.0),),
              ],
            ),
          ],
        ),
        trailing: const Icon(CupertinoIcons.forward),
      ),
    );
  }
}