import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import 'coin_event.dart';
import 'coin_state.dart';

import 'package:betterhodl_flutter/core/network/api_status.dart';
import 'package:betterhodl_flutter/core/network/rest_service.dart';
import 'package:betterhodl_flutter/core/network/socket_service.dart';
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:http/http.dart' as http;

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final http.Client client;
  final SocketService socketService;

  var sortOrder = SortOrders.marketCapDesc;

  static const marketUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
  static const livePriceWss = 'wss://ws.coincap.io/prices?assets=';

  CoinBloc({required this.socketService, required this.client})
      : super(const CoinState(
          sortOrder: SortOrders.marketCapDesc,
          marketCoinMap: {},
          isLivePricingEnabled: false,
          error: null,
        )) {
    on<FetchCoins>((event, emit) async {
      final marketCoinMap = await getMarketCoins();
      emit(CoinState(
        sortOrder: SortOrders.marketCapDesc,
        marketCoinMap: marketCoinMap,
        isLivePricingEnabled: state.isLivePricingEnabled,
        error: null,
      ));
    });

    on<SortCoins>(
      (event, emit) => emit(CoinState(
        sortOrder: state.sortOrder == SortOrders.marketCapDesc
            ? SortOrders.marketCapAsc
            : SortOrders.marketCapDesc,
        marketCoinMap: state.marketCoinMap,
        isLivePricingEnabled: state.isLivePricingEnabled,
        error: state.error,
      )),
    );

    on<ToggleLivePricing>((event, emit) {
      toggleLivePricing(state);
      emit(CoinState(
        sortOrder: state.sortOrder,
        marketCoinMap: state.marketCoinMap,
        isLivePricingEnabled: !state.isLivePricingEnabled,
        error: state.error,
      ));
    });

    on<LivePricingUpdate>((event, emit) {
      var marketCoinMap = updateMarketCoin(event.priceData);
      emit(CoinState(
        sortOrder: SortOrders.marketCapDesc,
        marketCoinMap: marketCoinMap,
        isLivePricingEnabled: state.isLivePricingEnabled,
        error: state.error,
      ));
    });
  }

  toggleLivePricing(CoinState coinState) {
    if (coinState.isLivePricingEnabled) {
      stopLivePrices();
    } else {
      listenForLivePrices();
    }
  }

  Future<Map<String, MarketCoin>> getMarketCoins() async {
    RestService restService = RestService(client);
    var response = await restService.get(marketUrl, marketCoinsFromJson);
    if (response is Success) {
      var marketCoins = response.response;
      Map<String, MarketCoin> marketCoinMap = {};
      for (var marketCoin in marketCoins) {
        marketCoinMap[marketCoin.name.toLowerCase()] = marketCoin;
      }
      return marketCoinMap;
    }
    return {};
  }

  listenForLivePrices() {
    var query = _getLivePriceQuery();
    socketService.connectAndListen(
        uri: Uri.parse(query),
        callback: livePriceUpdate,
        errorCallBack: livePriceError);
  }

  stopLivePrices() {
    socketService.stopListening();
  }

  livePriceUpdate(dynamic event) {
    add(LivePricingUpdate(event));
  }

  livePriceError(dynamic error) {
    // handle this
  }

  Map<String, MarketCoin> updateMarketCoin(String priceData) {
    var mapStringDynamicDecoded = json.decode(priceData);
    Map<String, MarketCoin> marketCoinMapCopy = Map.from(state.marketCoinMap);
    mapStringDynamicDecoded.forEach((key, value) {
      if (marketCoinMapCopy.containsKey(key)) {
        marketCoinMapCopy[key] =
            marketCoinMapCopy[key]!.copyWith(currentPrice: double.parse(value));
      }
    });
    return marketCoinMapCopy;
  }

  String _getLivePriceQuery() {
    var buffer = StringBuffer(livePriceWss);
    var first = true;
    for (var marketCoin in state.coins) {
      if (!first) {
        buffer.write(',');
      }
      buffer.write(marketCoin.name.toLowerCase());
      first = false;
    }
    return buffer.toString();
  }
}
