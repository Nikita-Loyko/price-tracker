import 'dart:async';
import 'dart:convert';

import 'package:price_tracker/data/network/active_symbols_response.dart';
import 'package:price_tracker/data/network/ticks_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceTrackerService {
  final String _messageTypeActiveSymbols = "active_symbols";
  final String _messageTypeTicks = "tick";
  final String _messageTypeForget = "forget";

  final String _url = "wss://ws.binaryws.com/websockets/v3?app_id=1089";

  final String _activeSymbolsRequestPayload =
      '{"active_symbols": "brief","product_type": "basic"}';

  String _getTicksPayload(String symbolId) =>
      '{"ticks": "$symbolId","subscribe": 1}';

  String _getForgetPayload(String subscriptionId) =>
      '{"forget": "$subscriptionId"}';

  late final WebSocketChannel _channel;

  final _activeSymbolsResponseController =
      StreamController<ActiveSymbolsResponse>();

  Stream<ActiveSymbolsResponse> get activeSymbolsResponseStream =>
      _activeSymbolsResponseController.stream;

  final _ticksResponseController = StreamController<TicksResponse>();

  Stream<TicksResponse> get ticksResponseStream =>
      _ticksResponseController.stream;

  String? _latestSubscriptionId;
  bool _blockedByForget = false;

  PriceTrackerService() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));

    _channel.stream.listen((event) {
      Map<String, dynamic> message = jsonDecode(event);
      var messageType = message["msg_type"];

      if (messageType == _messageTypeActiveSymbols && !_blockedByForget) {
        var activeSymbolsResponse = ActiveSymbolsResponse.fromJson(message);
        _activeSymbolsResponseController.sink.add(activeSymbolsResponse);
      } else if (messageType == _messageTypeTicks && !_blockedByForget) {
        var ticksResponse = TicksResponse.fromJson(message);
        _latestSubscriptionId = ticksResponse.subscription?.id;
        _ticksResponseController.sink.add(ticksResponse);
      } else if (messageType == _messageTypeForget) {
        _blockedByForget = false;
      }
    });
  }

  void requestActiveSymbols() {
    _channel.sink.add(_activeSymbolsRequestPayload);
  }

  void requestTicks(String symbolId) {
    _channel.sink.add(_getTicksPayload(symbolId));
  }

  void forget() {
    if (_latestSubscriptionId != null) {
      _blockedByForget = true;
      _channel.sink.add(_getForgetPayload(_latestSubscriptionId!));
    }
  }

  void close() {
    _channel.sink.close();
  }
}
