import 'package:price_tracker/data/model/symbol.dart';

class Market {
  final String id;
  final String name;
  final List<Symbol> symbols;

  Market(this.id, this.name, this.symbols);
}
