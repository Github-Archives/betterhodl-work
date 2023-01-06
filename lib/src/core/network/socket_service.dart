import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  late WebSocketChannel channel;

  SocketService();

  connectAndListen(
      {required Uri uri,
      required Function callback,
      required Function errorCallBack}) {
    channel = WebSocketChannel.connect(uri);
    channel.stream.listen((event) => callback(event),
        onError: (error) => errorCallBack(error));
  }

  stopListening() {
    channel.sink.close();
  }
}
