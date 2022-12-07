import 'dart:ffi';

import 'package:betterhodl_flutter/constants.dart';
import 'package:betterhodl_flutter/core/bloc/coin_bloc.dart';
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:betterhodl_flutter/screens/market_list.dart';
import 'package:betterhodl_flutter/view_models/market_coins_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'market_list_test.mocks.dart';

var marketCoin = MarketCoin(
    id: 'bitcoin',
    symbol: 'btc',
    name: 'Bitcoin',
    image:
        'https://assets.coingecko.com/coins/images/8029/large/1_0YusgngOrriVg4ZYx4wOFQ.png?1553483622',
    currentPrice: 21000.00,
    marketCap: 60000000000.00,
    marketCapRank: 1,
    high24h: 21500.00,
    low24h: 20500.00,
    priceChange24h: 1000.00,
    priceChangePercentage24h: 10.0,
    ath: 69000.00,
    athChangePercentage: 69.23,
    athDate: DateTime.now(),
    atl: 300.00,
    atlChangePercentage: -234.00,
    atlDate: DateTime.now());

//class MockMarketListViewModel extends Mock implements MarketCoinsViewModel {}

@GenerateMocks([CoinBloc])
void main() {
  testWidgets('MarketList sort pressed', (WidgetTester tester) async {
    var mockViewModel = MockMarketCoinsViewModel();
    when(mockViewModel.sortOrder).thenReturn(SortOrders.marketCapAsc);
    when(mockViewModel.marketCoins).thenReturn([]);
    when(mockViewModel.sort()).thenReturn(Void);

    const testKey = Key('K');

    final widgetUnderTest = ChangeNotifierProvider<MarketCoinsViewModel>(
        create: (_) => mockViewModel,
        builder: (context, child) {
          return const MaterialApp(key: testKey, home: MarketList());
        });

    await tester.pumpWidget(widgetUnderTest);

    final Finder marketCapButton =
        find.byKey(const ValueKey('market_list_market_cap_button'));

    await tester.tap(marketCapButton);
    await tester.pump();

    verify(mockViewModel.sort()).called(1);
  });
}
