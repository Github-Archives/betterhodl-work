// TODO: Everything remains the same except the view model.. convert to bloc
// TODO: Create bloc folder under core
// TODO: Move functionality from view_models to bloc

// TODO: In screens the view_model is being represented and available to widget tree.. this will change to know that its connected

// import 'dart:convert';

// import 'package:betterhodl_flutter/core/network/api_status.dart';
// import 'package:betterhodl_flutter/core/network/rest_service.dart';
// import 'package:betterhodl_flutter/core/network/socket_service.dart';
// import 'package:betterhodl_flutter/domain/models/market_coin.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../constants.dart';

// class MarketCoinsViewModel extends ChangeNotifier {
//   bool _loading = false;
//   bool get loading => _loading;
//   bool _livePricingEnabled = false;
//   List<MarketCoin> _marketCoins = [];
//   List<MarketCoin> get marketCoins => _marketCoins;
//   Map<String, MarketCoin> marketCoinMap = {};
//   final http.Client client;
//   final SocketService socketService;
//   var sortOrder = SortOrders.marketCapDesc;
//   static const marketUrl =
//       'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';
//   static const livePriceWss = 'wss://ws.coincap.io/prices?assets=';

//   MarketCoinsViewModel(this.client, this.socketService);

//   setLoading(bool loading) {
//     _loading = loading;
//     notifyListeners();
//   }

//   sort() {
//     switch (sortOrder) {
//       case SortOrders.marketCapDesc:
//         _marketCoins.sort((a, b) => a.marketCapRank.compareTo(b.marketCapRank));
//         break;
//       case SortOrders.marketCapAsc:
//         _marketCoins.sort((a, b) => b.marketCapRank.compareTo(a.marketCapRank));
//         break;
//       default:
//     }
//     notifyListeners();
//   }

//   toggleLivePricing() {
//     if (_livePricingEnabled) {
//       stopLivePrices();
//     } else {
//       listenForLivePrices();
//     }
//     _livePricingEnabled = !_livePricingEnabled;
//   }

//   getMarketCoins() async {
//     setLoading(true);
//     RestService restService = RestService(client);
//     var response = await restService.get(marketUrl, marketCoinsFromJson);
//     if (response is Success) {
//       _marketCoins = response.response;
//       for (var marketCoin in _marketCoins) {
//         marketCoinMap[marketCoin.name.toLowerCase()] = marketCoin;
//       }
//     }
//     setLoading(false);
//   }

//   listenForLivePrices() {
//     var query = _getLivePriceQuery();
//     socketService.connectAndListen(
//         uri: Uri.parse(query),
//         callback: livePriceUpdate,
//         errorCallBack: livePriceError);
//   }

//   stopLivePrices() {
//     socketService.stopListening();
//   }

//   livePriceUpdate(dynamic event) {
//     updateMarketCoin(json.decode(event));
//   }

//   livePriceError(dynamic error) {
//     // handle this
//   }

//   updateMarketCoin(Map<String, dynamic> priceData) {
//     priceData.forEach((key, value) {
//       marketCoinMap[key]?.currentPrice = double.parse(value);
//     });
//     notifyListeners();
//   }

//   String _getLivePriceQuery() {
//     var buffer = StringBuffer(livePriceWss);
//     var first = true;
//     for (var marketCoin in _marketCoins) {
//       if (!first) {
//         buffer.write(',');
//       }
//       buffer.write(marketCoin.name.toLowerCase());
//       first = false;
//     }
//     return buffer.toString();
//   }
// }
