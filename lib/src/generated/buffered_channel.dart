import 'channel.dart';

abstract class BufferedChannel<Value> extends Channel<Value> {
  Value? get value;
}
