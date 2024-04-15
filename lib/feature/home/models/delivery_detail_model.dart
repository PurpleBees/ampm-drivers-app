class DeliveryDetailModel {
  final String trackingNo;
  final String consigneeName;
  final String dropOffAddress;
  final String status;
  final String createdAt;
  final int noPackages;
  final int id;
  String? deliveredAt;
  String? remarks;

  DeliveryDetailModel({
    required this.trackingNo,
    required this.consigneeName,
    required this.dropOffAddress,
    required this.status,
    required this.noPackages,
    required this.id,
    required this.createdAt,
    this.deliveredAt,
    this.remarks,
  });

  DeliveryDetailModel.fromMap(Map<String, dynamic> map)
      : trackingNo = map['tracking_no'],
        consigneeName = map['consignee_name'],
        dropOffAddress = map['dropoff_address'],
        noPackages = map['packages'],
        id = map['id'],
        status = map['status'],
        createdAt = map['created_at'],
        deliveredAt = map['delivered_at'],
        remarks = map['notes'];

  @override
  String toString() =>
      'DeliveryDetailModel : {trackingNo : $trackingNo, timeStamp : $createdAt}';
}
