// TODO: In screens the view_model is being represented and available to widget tree.. this will change to know that its connected

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

// So after we write our first bloc here, then how will we access it in our UI?
//  Answer: with BlocProvider

// I will eventually be using BlocProvider instead of ChangeNotifier
class CoinBloc extends Bloc<CoinEvent, CoinState> with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  bool _livePricingEnabled = false;

  List<MarketCoin> _marketCoins = [];
  List<MarketCoin> get marketCoins => _marketCoins;
  Map<String, MarketCoin> marketCoinMap = {};

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
            // isLivePricingEnabled: false,
            isLoading: true)) {
    // On is inherited from bloc… registering an event handler to talk to the bloc
    on<FetchCoins>((event, emit) async {
      final marketCoinsMap = await getMarketCoins();
      print('Here in FetchCoins!!');
      // debugPrint('marketCoinsMap: $marketCoinsMap');
      emit(CoinState(
          sortOrder: SortOrders.marketCapDesc,
          marketCoinMap: marketCoinMap,
          isLivePricingEnabled: state.isLivePricingEnabled,
          error: null,
          // isLivePricingEnabled: true,
          isLoading: false));
    });

    on<SortCoins>(
      (event, emit) => emit(CoinState(
          sortOrder: state.sortOrder == SortOrders.marketCapDesc
              ? SortOrders.marketCapAsc
              : SortOrders.marketCapDesc,
          marketCoinMap: state.marketCoinMap,
          isLivePricingEnabled: state.isLivePricingEnabled,
          error: state.error,
          isLoading: state.isLoading)),
    );

    on<ToggleLivePricing>((event, emit) {
      // var toggleLivePricingx = toggleLivePricing();
      print('Here in ToggleLivePricing!!');
      toggleLivePricing();
      emit(CoinState(
          // sortOrder: SortOrders.marketCapDesc,
          sortOrder: state.sortOrder,
          marketCoinMap: state.marketCoinMap,
          isLivePricingEnabled: !state.isLivePricingEnabled,
          error: state.error,
          isLoading: state.isLoading));
    });

    on<LivePricingUpdate>((event, emit) {
      var marketCoinMap = updateMarketCoin(event.priceData);
      print(event.priceData);
      print('Here in LivePricingUpdate!!');
      emit(CoinState(
          sortOrder: SortOrders.marketCapDesc,
          marketCoinMap: marketCoinMap,
          isLivePricingEnabled: state.isLivePricingEnabled,
          error: state.error,
          isLoading: state.isLoading));
    });
  }

  // CoinBloc(this.client, this.socketService)
  //     : super(const CoinState.emptyState()) {
  //   on<FetchCoins>((event, emit) {
  //     // right now i'm calling events from the UI
  //     //  Ui needs to call events to get the new state!!

  //     // functions working inside block
  //     //   need to have the events stream coming in

  //     print('FetchCoins');
  //     // print('event: $event');
  //     // print('emit: $emit');
  //     // TODO:
  //     // 1. perform logic to get the coins (wether it's calling the API/etc.. get the data we want.. alittle tricky)
  //     // 2. want to emit the state
  //     // 3. FE do something with that state (probably a BlocBuilder)
  //     // return ['Fuck you'];
  //   });

// ! all of these should be private
  setLoading(bool loading) {
    _loading = loading;
    // market_coins_view_model.dart was extending ChangeNotifier for this...
    notifyListeners();
  }

  sort() {
    switch (sortOrder) {
      case SortOrders.marketCapDesc:
        _marketCoins.sort((a, b) => a.marketCapRank.compareTo(b.marketCapRank));
        break;
      case SortOrders.marketCapAsc:
        _marketCoins.sort((a, b) => b.marketCapRank.compareTo(a.marketCapRank));
        break;
      default:
    }
    // market_coins_view_model.dart was extending ChangeNotifier for this...
    notifyListeners();
  }

  toggleLivePricing() {
    if (_livePricingEnabled) {
      // print('true');
      stopLivePrices();
    } else {
      // print('false');
      listenForLivePrices();
      // getPriceData();
    }
    _livePricingEnabled =
        !_livePricingEnabled; // this will go into state object.. not here
  }

  getMarketCoins() async {
    setLoading(true);
    RestService restService = RestService(client);
    var response = await restService.get(marketUrl, marketCoinsFromJson);
    if (response is Success) {
      _marketCoins = response.response;
      for (var marketCoin in _marketCoins) {
        marketCoinMap[marketCoin.name.toLowerCase()] = marketCoin;
      }
    }
    setLoading(false);
  }

  listenForLivePrices() {
    var query = _getLivePriceQuery();
    socketService.connectAndListen(
        uri: Uri.parse(
            query), // ? is this the same as the socketUri in the test?
        callback: livePriceUpdate,
        errorCallBack: livePriceError);
  }

  stopLivePrices() {
    socketService.stopListening();
  }

  livePriceUpdate(dynamic event) {
    updateMarketCoin(json.decode(event));
  }

  livePriceError(dynamic error) {
    // handle this
  }

  updateMarketCoin(Map<String, dynamic> priceData) {
    priceData.forEach((key, value) {
      marketCoinMap[key]?.currentPrice = double.parse(value);
    });
    notifyListeners();
  }

  String _getLivePriceQuery() {
    var buffer = StringBuffer(livePriceWss);
    var first = true;
    for (var marketCoin in _marketCoins) {
      if (!first) {
        buffer.write(',');
      }
      buffer.write(marketCoin.name.toLowerCase());
      first = false;
    }
    return buffer.toString();
  }
}
