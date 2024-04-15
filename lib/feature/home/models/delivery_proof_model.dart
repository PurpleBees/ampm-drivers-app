class DeliveryProofModel {
  final String timeStamp;
  final int runSheetId;
  final String imgUrl;

  DeliveryProofModel({
    required this.timeStamp,
    required this.runSheetId,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() => {
        'created_at': timeStamp,
        'runsheet_id': runSheetId,
        'image_url': imgUrl,
      };
}
