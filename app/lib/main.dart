import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'services/services.dart';
import 'views/splash.dart'; // <--- Importamos la pantalla Splash

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TintaDeLunaApp());
}

class TintaDeLunaApp extends StatelessWidget {
  const TintaDeLunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLService.client,
      child: MaterialApp(
        title: 'Tinta de Luna',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFCF9F4),
          fontFamily: 'Plus Jakarta Sans',
        ),
        home: const SplashView(), // <--- Pantalla Principal
      ),
    );
  }
}
