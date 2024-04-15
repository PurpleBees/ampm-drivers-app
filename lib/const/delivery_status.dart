enum DeliveryStatus{
  outForDelivery(name: 'Out for Delivery'),
  delivered(name: 'Delivered'),
  failed(name: 'Failed'),
  rejected(name: 'Rejected');

  const DeliveryStatus({required this.name});
  final String name;
}