import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../domain/models/market_coin.dart';

@immutable
class CoinState extends Equatable {
  final Map<String, MarketCoin> marketCoinMap; // our giant map of coins
  final bool isLoading;
  final bool isLivePricingEnabled;
  final Object? error;
  final SortOrders sortOrder;

  // final bool _livePricingEnabled;

  List<MarketCoin> get coins {
    // TODO: implement sort order in here
    var coinsList = marketCoinMap.values.toList();
    return coinsList;
  }

  const CoinState({
    required this.marketCoinMap,
    required this.isLoading,
    required this.isLivePricingEnabled,
    required this.error,
    required this.sortOrder,
    // required bool livePricingEnabled, // maybe get rid of one of these
    // _livePricingEnabled this._livePricingEnabled,
  });

  // factory constructor
  // defining the default values here (a function)
  const CoinState.emptyState({
    this.marketCoinMap = const {}, // empty map
    this.isLoading = false,
    this.isLivePricingEnabled = false,
    this.sortOrder = SortOrders.marketCapDesc,

    // this._livePricingEnabled = false;
  }) : error = null;

  // this is for Equatable
  @override
  List<Object?> get props =>
      [marketCoinMap, isLoading, isLivePricingEnabled, error, sortOrder];
}
