import 'package:betterhodl_flutter/core/bloc/coin_bloc.dart';
import 'package:betterhodl_flutter/core/network/socket_service.dart';
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
// import 'package:betterhodl_flutter/view_models/market_coins_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'market_coin_view_models_test.mocks.dart';

@GenerateMocks([http.Client, SocketService])
void main() {
  const marketJson = '''[
  {
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 23338,
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

  const livePriceData =
      '{"bitcoin":"20520.22","cardano":"0.470882","theta fuel":"0.878248"}';
  const marketCoinUri =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
  const socketUri = 'wss://ws.coincap.io/prices?assets=bitcoin,theta fuel';
  group('market coin view models', () {
    test('that correct request is made to http client', () async {
      final client = MockClient();
      final socketService = MockSocketService();
      // var marketCoinsViewModel = MarketCoinsViewModel(client, socketService);
      var marketCoinsViewModel = CoinBloc(client, socketService);
      when(client.get(Uri.parse(marketCoinUri)))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      when(socketService.connectAndListen(
              uri: Uri.parse(socketUri),
              callback: marketCoinsViewModel.livePriceUpdate,
              errorCallBack: marketCoinsViewModel.livePriceError))
          .thenAnswer((_) {});
      await marketCoinsViewModel.getMarketCoins();
      verify(client.get(Uri.parse(marketCoinUri)));
    });
    test('that json is decoded into MarketCoin objects', () async {
      final client = MockClient();
      final socketService = MockSocketService();
      // var marketCoinsViewModel = MarketCoinsViewModel(client, socketService);
      var marketCoinsViewModel = CoinBloc(client, socketService);
      when(client.get(Uri.parse(marketCoinUri)))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      when(socketService.connectAndListen(
              uri: Uri.parse(socketUri),
              callback: marketCoinsViewModel.livePriceUpdate,
              errorCallBack: marketCoinsViewModel.livePriceError))
          .thenAnswer((_) {});
      await marketCoinsViewModel.getMarketCoins();
      verify(client.get(Uri.parse(marketCoinUri)));
      MarketCoin coin = marketCoinsViewModel.marketCoins[0];
      expect(coin.id, 'bitcoin');
      expect(coin.symbol, 'btc');
      expect(coin.name, 'Bitcoin');
      expect(coin.image,
          'https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579');
      expect(coin.currentPrice, 23338);
      expect(coin.marketCap, 445841127198);
      expect(coin.marketCapRank, 1);
      expect(coin.high24h, 27811);
      expect(coin.low24h, 22726);
      expect(coin.priceChange24h, -4473.47338182243);
      expect(coin.priceChangePercentage24h, -16.08514);
      MarketCoin coin2 = marketCoinsViewModel.marketCoins[1];
      expect(coin2.id, 'theta-fuel');
      expect(coin2.symbol, 'tfuel');
      expect(coin2.name, 'Theta Fuel');
      expect(coin2.image,
          'https://assets.coingecko.com/coins/images/8029/large/1_0YusgngOrriVg4ZYx4wOFQ.png?1553483622');
      expect(coin2.currentPrice, 0.0445775);
      expect(coin2.marketCap, 1886178774);
      expect(coin2.marketCapRank, 31);
      expect(coin2.high24h, 0.04801865);
      expect(coin2.low24h, 0.04353184);
      expect(coin2.priceChange24h, 0.00077699);
      expect(coin2.priceChangePercentage24h, 1.77392);
    });
    test('that correct request is made to socket client', () async {
      final client = MockClient();
      final socketService = MockSocketService();
      // var marketCoinsViewModel = MarketCoinsViewModel(client, socketService);
      var marketCoinsViewModel = CoinBloc(client, socketService);
      when(client.get(Uri.parse(marketCoinUri)))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      when(socketService.connectAndListen(
              uri: Uri.parse(socketUri),
              callback: marketCoinsViewModel.livePriceUpdate,
              errorCallBack: marketCoinsViewModel.livePriceError))
          .thenAnswer((_) {});
      await marketCoinsViewModel.getMarketCoins();
      marketCoinsViewModel.toggleLivePricing();
      verify(socketService.connectAndListen(
          uri: Uri.parse(socketUri),
          callback: marketCoinsViewModel.livePriceUpdate,
          errorCallBack: marketCoinsViewModel.livePriceError));
    });
    test('that the marketCoinMap is built correctly', () async {
      final client = MockClient();
      final socketService = MockSocketService();
      // var marketCoinsViewModel = MarketCoinsViewModel(client, socketService);
      var marketCoinsViewModel = CoinBloc(client, socketService);
      when(client.get(Uri.parse(marketCoinUri)))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      when(socketService.connectAndListen(
              uri: Uri.parse(socketUri),
              callback: marketCoinsViewModel.livePriceUpdate,
              errorCallBack: marketCoinsViewModel.livePriceError))
          .thenAnswer((_) {});
      await marketCoinsViewModel.getMarketCoins();
      expect(marketCoinsViewModel.marketCoinMap['bitcoin'] != null, true);
      expect(marketCoinsViewModel.marketCoinMap['theta fuel'] != null, true);
    });
    test(
        'that the marketCoin list is updated when live price callback is called',
        () async {
      final client = MockClient();
      final socketService = MockSocketService();
      // var marketCoinsViewModel = MarketCoinsViewModel(client, socketService);
      var marketCoinsViewModel = CoinBloc(client, socketService);
      when(client.get(Uri.parse(marketCoinUri)))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      when(socketService.connectAndListen(
              uri: Uri.parse(socketUri),
              callback: marketCoinsViewModel.livePriceUpdate,
              errorCallBack: marketCoinsViewModel.livePriceError))
          .thenAnswer((_) {});
      await marketCoinsViewModel.getMarketCoins();
      marketCoinsViewModel.livePriceUpdate(livePriceData);
      expect(marketCoinsViewModel.marketCoinMap['bitcoin']?.currentPrice,
          20520.22);
      expect(marketCoinsViewModel.marketCoinMap['theta fuel']?.currentPrice,
          0.878248);
    });
  });
}
