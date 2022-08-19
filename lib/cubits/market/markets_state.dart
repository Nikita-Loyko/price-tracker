part of 'markets_cubit.dart';

abstract class MarketsState extends Equatable {
  const MarketsState();
}

class MarketsInitial extends MarketsState {
  @override
  List<Object> get props => [];
}

class MarketSelected extends MarketsState {
  final String id;

  const MarketSelected(this.id);

  @override
  List<Object> get props => [id];
}
