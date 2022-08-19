import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/price_tracker_repository.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  final PriceTrackerRepository _repository;

  double? _lastPrice;

  PriceCubit(this._repository) : super(PriceInitial()) {
    _repository.prices.listen((event) {
      var color = Colors.grey;

      if (_lastPrice != null) {
        if (event.bid > _lastPrice!) {
          color = Colors.green;
        } else if (event.bid < _lastPrice!) {
          color = Colors.red;
        }
      }

      _lastPrice = event.bid;

      emit(PriceLoaded(color, event.bid));
    });
  }

  void stopUpdating() {
    emit(PriceCancel());
    _lastPrice = null;
    _repository.forget();
  }

  void requestPrices(String symbolId) {
    emit(PriceLoading());
    _lastPrice = null;
    _repository.forget();
    _repository.requestPrices(symbolId);
  }
}
