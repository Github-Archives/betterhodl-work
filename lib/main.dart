import 'package:betterhodl_flutter/src/core/bloc/coin_bloc.dart';
import 'package:betterhodl_flutter/src/core/bloc/coin_event.dart';
import 'package:betterhodl_flutter/src/core/network/socket_service.dart';
import 'package:betterhodl_flutter/src/screens/market_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

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
