import 'package:flutter/material.dart';

abstract class CoinEvent {
  const CoinEvent();
}

class FetchCoins extends CoinEvent {
  const FetchCoins();
}

class SortCoins extends CoinEvent {
  const SortCoins();
}

class LivePricingUpdate extends CoinEvent {
  final String priceData;
  const LivePricingUpdate(this.priceData);
}

class ToggleLivePricing extends CoinEvent {
  const ToggleLivePricing();
}
