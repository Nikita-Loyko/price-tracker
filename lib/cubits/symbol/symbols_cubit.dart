import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/model/symbol.dart';
import 'package:price_tracker/data/price_tracker_repository.dart';

part 'symbols_state.dart';

class SymbolCubit extends Cubit<SymbolsState> {
  List<Symbol> _symbols = [];

  SymbolCubit() : super(SymbolsInitial());

  void setSymbols(List<Symbol> symbols) {
    _symbols = symbols;
    emit(SymbolsChanged(null, symbols));
  }

  void select(String value) async {
    emit(SymbolsChanged(value, _symbols));
  }
}
