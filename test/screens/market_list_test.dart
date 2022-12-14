import 'dart:ffi';

import 'package:betterhodl_flutter/constants.dart';
import 'package:betterhodl_flutter/core/bloc/coin_bloc.dart';
import 'package:betterhodl_flutter/core/bloc/coin_event.dart';
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:betterhodl_flutter/screens/market_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../blocs/market_coins_bloc_test.mocks.dart';
import 'market_list_test.mocks.dart';

import 'package:betterhodl_flutter/core/network/socket_service.dart';
import 'package:http/http.dart' as http;

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

const marketCoinUri =
    'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';

//class MockMarketListViewModel extends Mock implements MarketCoinsViewModel {}

@GenerateMocks([CoinBloc])
void main() {
  const marketJson = '''[
  {
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 23338.00,
    "market_cap": 445841127198,
    "market_cap_rank": 1,
    "high_24h": 27811,
    "low_24h": 22726,
    "price_change_24h": -4473.47338182243,
    "price_change_percentage_24h": -16.08514,
    "ath": 69045,
    "ath_change_percentage": -72.05881,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 28350.39313,
    "atl_date": "2013-07-06T00:00:00.000Z"},
  {
    "id":"theta-fuel",
    "symbol":"tfuel",
    "name":"Theta Fuel",
    "image":"https://assets.coingecko.com/coins/images/8029/large/1_0YusgngOrriVg4ZYx4wOFQ.png?1553483622",
    "current_price":0.0445775,
    "market_cap":1886178774,
    "market_cap_rank":31,
    "fully_diluted_valuation":null,
    "total_volume":12405517,
    "high_24h":0.04801865,
    "low_24h":0.04353184,
    "price_change_24h":0.00077699,
    "price_change_percentage_24h":1.77392,
    "market_cap_change_24h":49552231,
    "market_cap_change_percentage_24h":2.698,
    "circulating_supply":0.0,
    "total_supply":5301200000.0,
    "max_supply":null,"ath":0.68159,
    "ath_change_percentage":-93.38616,
    "ath_date":"2021-06-09T06:50:55.818Z",
    "atl":0.00090804,
    "atl_change_percentage":4864.46391,
    "atl_date":"2020-03-13T02:30:37.972Z",
    "roi":null,
    "last_updated":"2022-06-16T19:53:23.628Z"}]''';

  final client = MockClient();
  final socketService = MockSocketService();
  when(client.get(Uri.parse(marketCoinUri)))
      .thenAnswer((_) async => http.Response(marketJson, 200));
  testWidgets('MarketList rendering', (WidgetTester tester) async {
    Widget makeTestableWidget() => MaterialApp(
            home: BlocProvider(
          create: (context) =>
              CoinBloc(client: client, socketService: socketService)
                ..add(const FetchCoins()),
          child: const MarketList(),
        ));

    await mockNetworkImagesFor(
        () async => await tester.pumpWidget(makeTestableWidget()));

    await mockNetworkImagesFor(() => tester.pumpAndSettle());

    // headings
    expect(find.text('Rank'), findsOneWidget);
    expect(find.text('Coin'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('24H'), findsOneWidget);
    expect(find.text('Market Cap'), findsOneWidget);

    // verify rendering of data
    expect(find.text('1'), findsOneWidget);
    expect(find.text('btc'), findsOneWidget);
    expect(find.text('\$23,338.00'), findsOneWidget);
    expect(find.text('-16.09%'), findsOneWidget);
    expect(find.text('\$446B'), findsOneWidget);
    expect(find.text('31'), findsOneWidget);
    expect(find.text('tfuel'), findsOneWidget);
    expect(find.text('\$0.044578'), findsOneWidget);
    expect(find.text('1.77%'), findsOneWidget);
    expect(find.text('\$1.89B'), findsOneWidget);
  });

  // testWidgets('MarketList tap row', (WidgetTester tester) async {
  //   final client = MockClient();
  //   when(client.get(Uri.parse(marketCoinUri)))
  //       .thenAnswer((_) async => http.Response(marketJson, 200));

  //   Widget makeTestableWidget() => MaterialApp(
  //           home: BlocProvider(
  //         create: (context) =>
  //             CoinBloc(client: client, socketService: socketService)
  //               ..add(const FetchCoins()),
  //         child: const MarketList(),
  //       ));

  //   await mockNetworkImagesFor(
  //       () async => await tester.pumpWidget(makeTestableWidget()));

  //   await mockNetworkImagesFor(() => tester.pumpAndSettle());

  //   final Finder bitCoinRow = find.byKey(const ValueKey('btc-[<0>]'));

  //   await tester.tap(bitCoinRow);

  //   await tester.pumpAndSettle();

  //   expect(find.text('24H'), findsOneWidget);
  // });
}
