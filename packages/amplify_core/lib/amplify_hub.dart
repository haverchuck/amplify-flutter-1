import 'dart:async';


class AmplifyHub {

  StreamSubscription subscription;
  List<StreamSubscription> platformStreams = [];
  StreamController hub;

  AmplifyHub() {
    hub = StreamController.broadcast(
      onListen: listened,
      onCancel: cancelPlatformStreams);
  }

  listened() {}

  cancelPlatformStreams() {
    platformStreams.forEach((el) {
      el.cancel();
    });
  }


  StreamSubscription listen(dynamic listener, {dynamic onError}) {
    subscription = hub.stream.listen(listener, onError: onError);
    return subscription;
  }

  void addChannel(StreamController sc) async  {
    StreamSubscription subscription = sc.stream.listen((msg) {
      hub.add(msg);
    });
    platformStreams.add(subscription);
  }
}