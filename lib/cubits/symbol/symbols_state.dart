part of 'symbols_cubit.dart';

abstract class SymbolsState extends Equatable {
  const SymbolsState();
}

class SymbolsInitial extends SymbolsState {
  @override
  List<Object> get props => [];
}

class SymbolsChanged extends SymbolsState {
  final String? id;
  final List<Symbol> symbols;

  const SymbolsChanged(this.id, this.symbols);

  @override
  List<Object?> get props => [id, symbols];
}
