import 'package:betterhodl_flutter/src/core/bloc/coin_state.dart';
import 'package:betterhodl_flutter/src/screens/coin_detail.dart';
import 'package:betterhodl_flutter/src/screens/market_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/bloc/coin_bloc.dart';
import '../core/bloc/coin_event.dart';

class MarketList extends StatelessWidget {
  const MarketList({super.key});

  @override
  Widget build(BuildContext context) {
    CoinBloc coinBloc = context.read<CoinBloc>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('BetterHodl'),
          actions: [
            IconButton(
                onPressed: () {
                  coinBloc.add(const ToggleLivePricing());
                },
                icon: const Icon(Icons.add_alert))
          ],
        ),
        body: BlocBuilder<CoinBloc, CoinState>(
            builder: (context, state) =>
                Center(child: buildUI(coinBloc, state))));
  }

  buildUI(CoinBloc coinBloc, CoinState coinState) {
    return Column(children: [
      Row(children: [
        const Expanded(flex: 10, child: Text('Rank')),
        const Expanded(
            flex: 9,
            child:
                Align(alignment: Alignment.centerRight, child: Text('Coin'))),
        const Expanded(
            flex: 32,
            child:
                Align(alignment: Alignment.centerRight, child: Text('Price'))),
        const Expanded(
            flex: 20,
            child: Align(alignment: Alignment.centerRight, child: Text('24H'))),
        Expanded(
            flex: 30,
            child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    key: const ValueKey('market_list_market_cap_button'),
                    child: const Text('Market Cap'),
                    onPressed: () {
                      coinBloc.add(const SortCoins());
                    })))
      ]),
      Expanded(
          child: ListView.builder(
              itemCount: coinState.coins.length,
              itemBuilder: (context, index) {
                final marketCoin = coinState.coins[index];
                return GestureDetector(
                    child: MarketListCard(marketCoin: marketCoin),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoinDetail(marketCoin)));
                    });
              }))
    ]);
  }
}
