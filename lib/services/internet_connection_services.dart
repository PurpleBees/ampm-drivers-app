import 'dart:async';
import 'package:flutter/material.dart' show VoidCallback;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionServices {
  StreamSubscription<InternetConnectionStatus>? _internetConnectionListener;

  void init({VoidCallback? onConnect, VoidCallback? onDisconnect}) {
    _internetConnectionListener =
        InternetConnectionChecker().onStatusChange.listen(
              (InternetConnectionStatus status) {
            switch (status) {
              case InternetConnectionStatus.connected:
                onConnect?.call();
              case InternetConnectionStatus.disconnected:
                onDisconnect?.call();
            }
          },
        );
  }

  Future<bool> hasConnection()async{
    return await InternetConnectionChecker().hasConnection;
  }

  void close()async{
    await _internetConnectionListener?.cancel();
  }
}