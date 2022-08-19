part of 'launch_screen_cubit.dart';

abstract class LaunchScreenState extends Equatable {
  const LaunchScreenState();
}

class LaunchScreenInitial extends LaunchScreenState {
  @override
  List<Object> get props => [];
}

class LaunchScreenMarketsLoaded extends LaunchScreenState {
  final List<Market> markets;

  const LaunchScreenMarketsLoaded(this.markets);

  @override
  List<Object> get props => [markets];
}
