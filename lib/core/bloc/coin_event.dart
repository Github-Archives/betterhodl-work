import 'package:flutter/material.dart';

@immutable
abstract class CoinEvent {
  const CoinEvent();
}

@immutable
class FetchCoins extends CoinEvent {
  const FetchCoins();
}

@immutable
class SortCoins extends CoinEvent {
  const SortCoins();
}

@immutable
class LivePricingUpdate extends CoinEvent {
  final priceData;

  const LivePricingUpdate(this.priceData);

  Map<String, dynamic> get getPriceData => priceData;
}

@immutable
class ToggleLivePricing extends CoinEvent {
  const ToggleLivePricing();
}
