import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:betterhodl_flutter/screens/market_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

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
void main() {
  testWidgets('MarketListCard renders MarketCoin correctly',
      (WidgetTester tester) async {
    const testKey = Key('K');
    await mockNetworkImagesFor(() async => await tester.pumpWidget(MaterialApp(
        key: testKey, home: MarketListCard(marketCoin: marketCoin))));
    final symbolFinder = find.text('btc');
    expect(symbolFinder, findsOneWidget);
  });
}
