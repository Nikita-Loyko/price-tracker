import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/cubits/launch_screen/launch_screen_cubit.dart';
import 'package:price_tracker/cubits/market/markets_cubit.dart';
import 'package:price_tracker/cubits/price/price_cubit.dart';
import 'package:price_tracker/cubits/symbol/symbols_cubit.dart';
import 'package:price_tracker/data/network/price_tracker_service.dart';
import 'package:price_tracker/data/price_tracker_repository.dart';
import 'package:price_tracker/pages/price_tracker_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PriceTrackerService _service = PriceTrackerService();

  @override
  Widget build(BuildContext context) {
    final PriceTrackerRepository repository = PriceTrackerRepository(_service);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LaunchScreenCubit(repository)),
        BlocProvider(create: (context) => PriceCubit(repository)),
        BlocProvider(create: (context) => MarketsCubit()),
        BlocProvider(create: (context) => SymbolCubit()),
      ],
      child: MaterialApp(
        title: 'Price Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PriceTrackerHome(title: 'Price Tracker'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _service.close();
  }
}
