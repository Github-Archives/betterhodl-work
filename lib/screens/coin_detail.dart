// ! right now i'm calling events from the UI
// !  Ui needs to call events to get the new state!!
import 'package:betterhodl_flutter/domain/models/market_coin.dart';
import 'package:flutter/material.dart';

import 'screen_utils.dart';

const divider = Divider(height: 10, thickness: 1, indent: 10, endIndent: 10);

class CoinDetail extends StatelessWidget {
  final MarketCoin marketCoin;
  const CoinDetail(this.marketCoin, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(marketCoin.name)),
        body: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 2.0,
                      spreadRadius: 2.0,
                      color: Colors.black26)
                ]),
            child: Column(
              children: [
                DetailRow(
                    title: 'Market Cap Rank',
                    data: '#${marketCoin.marketCapRank.toString()}'),
                DetailRow(
                    title: 'Market Cap',
                    data: formatCompactCurrency(marketCoin.marketCap)),
                DetailRow(
                    title: '24H High',
                    data: formatCurrency(marketCoin.high24h)),
                DetailRow(
                    title: '24H Low', data: formatCurrency(marketCoin.low24h)),
                AllTime(
                    title: 'All-Time High',
                    price: formatCurrency(marketCoin.ath),
                    percentage: formatPercent(marketCoin.athChangePercentage),
                    date: formatDate(marketCoin.athDate)),
                AllTime(
                    title: 'All-Time Low',
                    price: formatCurrency(marketCoin.atl),
                    percentage: formatPercent(marketCoin.atlChangePercentage),
                    date: formatDate(marketCoin.atlDate))
              ],
            )));
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String data;
  const DetailRow({required this.title, required this.data, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
            flex: 50,
            child: Padding(
                padding: const EdgeInsets.all(8.0), child: Text(title))),
        Expanded(
            flex: 50,
            child:
                Container(alignment: Alignment.centerRight, child: Text(data)))
      ]),
      divider
    ]);
  }
}

class AllTime extends StatelessWidget {
  final String title;
  final String price;
  final String percentage;
  final String date;

  const AllTime(
      {required this.title,
      required this.price,
      required this.percentage,
      required this.date,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          flex: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ),
        Expanded(
          flex: 50,
          child: Container(
              alignment: Alignment.centerRight,
              child:
                  Column(children: [Text('$price - $percentage'), Text(date)])),
        )
      ]),
      divider
    ]);
  }
}
