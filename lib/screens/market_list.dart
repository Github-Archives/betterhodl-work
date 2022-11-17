// ! right now i'm calling events from the UI
// !  Ui needs to call events to get the new state!!
import 'package:betterhodl_flutter/core/components/app_loading.dart';
import 'package:betterhodl_flutter/screens/coin_detail.dart';
import 'package:betterhodl_flutter/screens/market_list_card.dart';
// import 'package:betterhodl_flutter/view_models/market_coins_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/src/client.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../core/bloc/coin_bloc.dart';
import '../core/bloc/coin_event.dart';

class MarketList extends StatelessWidget {
  const MarketList({super.key});

  // const MarketList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MarketCoinsViewModel coinBloc =
    //     context.watch<MarketCoinsViewModel>(); // this is where the data is coming from
    // context.read<CoinBloc>().add(FetchCoins());

    CoinBloc coinBloc =
        context.watch<CoinBloc>(); // this is where the data is coming from
    // Michael had me add the line below.. may come in handy later
    // context.read<CoinBloc>().add(const FetchCoins());
    // context.read<CoinBloc>().add(const LivePricingUpdate());
    // context.read<CoinBloc>().add(const ToggleLivePricing());

    // print('coinBloc');
    // print(coinBloc.state);
    return Scaffold(
        appBar: AppBar(
          title: const Text('BetterHodl'),
          actions: [
            IconButton(
                onPressed: () {
                  // coinBloc.toggleLivePricing();
                  // coinBloc.add(const FetchCoins());
                  coinBloc.add(const ToggleLivePricing());
                },
                icon: const Icon(Icons.add_alert))
          ],
        ),
        body: Center(child: buildUI(coinBloc)));
  }

  // buildUI(MarketCoinsViewModel marketCoinsViewModel) {
  buildUI(CoinBloc coinBloc) {
    if (coinBloc.loading) {
      return const AppLoading();
    }
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
                      coinBloc.sortOrder =
                          coinBloc.sortOrder == SortOrders.marketCapDesc
                              ? SortOrders.marketCapAsc
                              : SortOrders.marketCapDesc;
                      coinBloc.sort();
                    })))
      ]),
      Expanded(
          child: ListView.builder(
              // keep ListView...
              itemCount: coinBloc.marketCoins.length,
              itemBuilder: (context, index) {
                final marketCoin = coinBloc.marketCoins[
                    index]; // holding all the coins.. we will replace this with the state coins..
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
