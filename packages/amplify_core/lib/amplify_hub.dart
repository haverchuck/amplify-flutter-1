import 'dart:async';

class AmplifyHub {

  StreamSubscription subscription;
  List<StreamController> platformStreams = [];
  StreamController hub;

  AmplifyHub() {
    hub = StreamController.broadcast(
      onListen: listened,
      onCancel: cancelPlatformStreams);
  }

  cancelPlatformStreams() {
    platformStreams.forEach((element) {
      element.close();
    });
  }

  listened() {
    print('listened');
  }


  StreamSubscription listen(dynamic listener) {
    subscription = hub.stream.listen(listener);
    return subscription;
  }

  void cancel() {
    subscription.cancel();
  }

  void addChannel(StreamController sc) async  {
    hub.addStream(sc.stream);
    platformStreams.add(sc);
  }
}