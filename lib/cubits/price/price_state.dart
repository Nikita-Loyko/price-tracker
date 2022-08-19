part of 'price_cubit.dart';

abstract class PriceState extends Equatable {
  const PriceState();
}

class PriceInitial extends PriceState {
  @override
  List<Object> get props => [];
}

class PriceCancel extends PriceState {
  @override
  List<Object> get props => [];
}

class PriceLoading extends PriceState {
  @override
  List<Object> get props => [];
}

class PriceLoaded extends PriceState {
  final Color color;
  final double value;

  const PriceLoaded(this.color, this.value);

  @override
  List<Object> get props => [color, value];
}
