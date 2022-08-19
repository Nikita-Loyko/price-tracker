import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_tracker/cubits/launch_screen/launch_screen_cubit.dart';
import 'package:price_tracker/cubits/market/markets_cubit.dart';
import 'package:price_tracker/cubits/price/price_cubit.dart';
import 'package:price_tracker/cubits/symbol/symbols_cubit.dart';
import 'package:price_tracker/data/model/market.dart';
import 'package:price_tracker/data/model/symbol.dart';

class PriceTrackerHome extends StatefulWidget {
  const PriceTrackerHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PriceTrackerHome> createState() => _PriceTrackerHomeState();
}

class _PriceTrackerHomeState extends State<PriceTrackerHome> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LaunchScreenCubit, LaunchScreenState>(
        builder: (context, state) {
      if (state is LaunchScreenMarketsLoaded) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                BlocBuilder<MarketsCubit, MarketsState>(
                  builder: (context, marketState) {
                    if (marketState is MarketSelected) {
                      return buildMarketsDropDown(
                          state.markets, marketState.id);
                    } else {
                      return buildMarketsDropDown(state.markets, null);
                    }
                  },
                ),
                BlocBuilder<SymbolCubit, SymbolsState>(
                  builder: (context, symbolState) {
                    if (symbolState is SymbolsChanged) {
                      return buildSymbolsDropDown(
                          symbolState.symbols, symbolState.id);
                    } else {
                      return buildSymbolsDropDown(null, null);
                    }
                  },
                ),
                Expanded(
                  child: Center(
                    child: BlocBuilder<PriceCubit, PriceState>(
                      builder: (context, state) {
                        if (state is PriceLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is PriceLoaded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Price:",
                                style: TextStyle(
                                  fontSize: 36.0,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(width: 16.0),
                              Text(
                                state.value.toString(),
                                style: TextStyle(
                                  color: state.color,
                                  fontSize: 36.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return buildInitialIndicator();
      }
    });
  }

  DropdownButton buildMarketsDropDown(List<Market> items, value) {
    return DropdownButton<String>(
      items: items
          .map((e) => DropdownMenuItem<String>(
                value: e.id,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (value) {
        BlocProvider.of<MarketsCubit>(context).select(value ?? "");
        BlocProvider.of<SymbolCubit>(context)
            .setSymbols(items.where((item) => item.id == value).first.symbols);
        BlocProvider.of<PriceCubit>(context).stopUpdating();
      },
      isExpanded: true,
      hint: const Text("Select a Market"),
      value: value == null
          ? null
          : items.where((item) => item.id == value).first.id,
    );
  }

  DropdownButton buildSymbolsDropDown(List<Symbol>? items, value) {
    return DropdownButton<String>(
      items: items
          ?.map((e) => DropdownMenuItem<String>(
                value: e.id,
                child: Text(e.name),
              ))
          .toList(),
      onChanged: (value) {
        BlocProvider.of<SymbolCubit>(context).select(value ?? "");
        BlocProvider.of<PriceCubit>(context).requestPrices(value ?? "");
      },
      isExpanded: true,
      hint: const Text("Select an Asset"),
      value: value == null
          ? null
          : items?.where((item) => item.id == value).first.id,
    );
  }

  Container buildInitialIndicator() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
