import 'channel.dart';

abstract class StatefulChannel<Value> extends Channel<Value> {
  Value get value;
}
