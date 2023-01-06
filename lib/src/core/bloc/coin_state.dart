import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../domain/models/market_coin.dart';

@immutable
class CoinState extends Equatable {
  final Map<String, MarketCoin> marketCoinMap; // our giant map of coins
  final bool isLivePricingEnabled;
  final Object? error;
  final SortOrders sortOrder;

  List<MarketCoin> get coins {
    var coinsList = marketCoinMap.values.toList();
    switch (sortOrder) {
      case SortOrders.marketCapDesc:
        coinsList.sort((a, b) => a.marketCapRank.compareTo(b.marketCapRank));
        break;
      case SortOrders.marketCapAsc:
        coinsList.sort((a, b) => b.marketCapRank.compareTo(a.marketCapRank));
        break;
      default:
    }
    return coinsList;
  }

  const CoinState({
    required this.marketCoinMap,
    required this.isLivePricingEnabled,
    required this.error,
    required this.sortOrder,
  });

  // factory constructor
  const CoinState.emptyState({
    this.marketCoinMap = const {},
    this.isLivePricingEnabled = false,
    this.sortOrder = SortOrders.marketCapDesc,
  }) : error = null;

  // this is for Equatable
  @override
  List<Object?> get props =>
      [marketCoinMap, isLivePricingEnabled, error, sortOrder];
}
