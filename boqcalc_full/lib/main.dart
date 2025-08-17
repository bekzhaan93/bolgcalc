import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/boq_provider.dart';
import 'screens/home_screen.dart';
import 'screens/new_row_screen.dart';
import 'screens/rows_screen.dart';
import 'screens/summary_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = BoqProvider();
  await provider.load();
  runApp(BoqCalcApp(provider: provider));
}

class BoqCalcApp extends StatelessWidget {
  final BoqProvider provider;
  const BoqCalcApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'BoQCalc — ведомость работ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ru'), Locale('en')],
        routes: {
          '/': (context) => const HomeScreen(),
          NewRowScreen.route: (context) => const NewRowScreen(),
          RowsScreen.route: (context) => const RowsScreen(),
          SummaryScreen.route: (context) => const SummaryScreen(),
        },
      ),
    );
  }
}
