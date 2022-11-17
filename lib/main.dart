import 'package:betterhodl_flutter/core/network/socket_service.dart';
import 'package:betterhodl_flutter/screens/market_list.dart';
// import 'package:betterhodl_flutter/view_models/market_coins_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'core/bloc/coin_bloc.dart';
import 'core/bloc/coin_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final coinBloc =
      CoinBloc(client: http.Client(), socketService: SocketService());
  MyApp({Key? key}) : super(key: key);

  // TODO: utilize BlocProvider
  @override
  Widget build(BuildContext context) {
    // coinBloc.getMarketCoins();
    coinBloc.add(const FetchCoins());
    // need to use .add
    return BlocProvider(
      create: (context) =>
          CoinBloc(client: http.Client(), socketService: SocketService()),
      child: MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => coinBloc)],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.dark(),
            home: const MarketList(),
          )),
    );
  }
}

// !ORIGINAL:
// import 'package:betterhodl_flutter/core/network/socket_service.dart';
// import 'package:betterhodl_flutter/screens/market_list.dart';
// import 'package:betterhodl_flutter/view_models/market_coins_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final marketCoinViewModels =
//       MarketCoinsViewModel(http.Client(), SocketService());
//   MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     marketCoinViewModels.getMarketCoins();
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => marketCoinViewModels)
//         ],
//         child: MaterialApp(
//           title: 'Flutter Demo',
//           theme: ThemeData.dark(),
//           home: const MarketList(),
//         ));
//   }
// }


