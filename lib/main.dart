import 'package:betterhodl_flutter/core/network/socket_service.dart';
import 'package:betterhodl_flutter/screens/market_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'core/bloc/coin_bloc.dart';
import 'core/bloc/coin_event.dart';
import 'core/bloc/coin_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CoinBloc(client: http.Client(), socketService: SocketService())
            ..add(const FetchCoins()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: const MarketList(),
      ),
    );
  }
}
