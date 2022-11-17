import 'dart:ffi';
import 'dart:io';

import 'package:betterhodl_flutter/core/network/api_status.dart';
import 'package:betterhodl_flutter/core/network/rest_service.dart';
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rest_service_test.mocks.dart';

class TestDomainObject {
  final String? value1;
  final Int? value2;
  TestDomainObject(this.value1, this.value2);
}

String decoder(String json) {
  return 'blah';
}

@GenerateMocks([http.Client])
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
  group('MarketService', () {
    test('handles non-200 response', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://nexient.com')))
          .thenAnswer((_) async => http.Response('', 403));
      RestService restService = RestService<MarketCoin>(client);
      var response = await restService.get('https://nexient.com', decoder);
      if (response is Failure) {
        Failure failure = response;
        expect(failure.code, 403);
      } else {
        fail('Expected failure');
      }
    });
    test('handles failure from SocketException', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://nexient.com')))
          .thenThrow(const SocketException('hey'));
      RestService restService = RestService<MarketCoin>(client);
      var response = await restService.get('https://nexient.com', decoder);
      if (response is Failure) {
        Failure failure = response;
        expect(failure.code, 101);
        expect(failure.error, 'No internet connection');
      } else {
        fail('Expected failure');
      }
    });
    test('handles 200 response with data', () async {
      final client = MockClient();
      when(client.get(Uri.parse('https://nexient.com')))
          .thenAnswer((_) async => http.Response(marketJson, 200));
      RestService restService = RestService<MarketCoin>(client);
      var response =
          await restService.get('https://nexient.com', marketCoinsFromJson);
      if (response is Success) {
        List<MarketCoin> coins = response.response;
        MarketCoin coin = coins[0];
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
        MarketCoin coin2 = coins[1];
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
      } else {
        fail('Expected Success response');
      }
    });
    test('Network exception produce message correct', () {
      var networkException = NetworkException('test', 777);
      expect(networkException.code, 777);
      expect(networkException.message, 'test');
      expect(networkException.toString(), 'test: response code: 777');
    });
  });
}
