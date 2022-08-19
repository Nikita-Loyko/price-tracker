import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/data/model/market.dart';
import 'package:price_tracker/data/price_tracker_repository.dart';

part 'launch_screen_state.dart';

class LaunchScreenCubit extends Cubit<LaunchScreenState> {
  final PriceTrackerRepository _repository;

  LaunchScreenCubit(this._repository) : super(LaunchScreenInitial()) {
    loadMarkets();
  }

  void loadMarkets() {
    _repository.markets.listen((markets) {
      emit(LaunchScreenMarketsLoaded(markets));
    });
    _repository.loadMarkets();
  }
}
