import 'package:price_tracker/data/network/active_symbols_response.dart';
import 'package:price_tracker/data/network/price_tracker_service.dart';

import 'package:price_tracker/data/model/price.dart';
import 'package:price_tracker/data/model/market.dart';
import 'package:price_tracker/data/model/symbol.dart';

class PriceTrackerRepository {
  final PriceTrackerService _service;

  PriceTrackerRepository(this._service);

  void loadMarkets() {
    _service.requestActiveSymbols();
  }

  void requestPrices(String symbolId) {
    _service.requestTicks(symbolId);
  }

  void forget() {
    _service.forget();
  }

  Stream<List<Market>> get markets {
    return _service.activeSymbolsResponseStream.map((activeSymbolsResponse) {
      final marketIds = activeSymbolsResponse.activeSymbols
              ?.map((actSym) => actSym.market ?? "")
              .toSet()
              .toList() ??
          <String>[];

      final markets = marketIds.map((id) {
        final activeSymbolsByMarket = activeSymbolsResponse.activeSymbols
                ?.where((actSym) => actSym.market == id) ??
            <ActiveSymbol>[];

        return Market(
            activeSymbolsByMarket.first.market ?? "",
            activeSymbolsByMarket.first.marketDisplayName ?? "",
            activeSymbolsByMarket
                .map((actSym) =>
                    Symbol(actSym.symbol ?? "", actSym.displayName ?? ""))
                .toList());
      });

      return markets.toList();
    });
  }

  Stream<Price> get prices {
    return _service.ticksResponseStream.map((event) => Price(
        event.tick?.ask?.toDouble() ?? 0,
        event.tick?.bid?.toDouble() ?? 0,
        event.subscription?.id ?? ""));
  }
}
