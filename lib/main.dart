import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:yaru/theme.dart';
import 'package:yesan_weather/yesan_view.dart';


final log = Logger();
final materialAppNavigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StoreApp()));
}

class StoreApp extends ConsumerWidget {
  const StoreApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return YaruTheme(builder: (context, yaru, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: ref.watch(materialAppNavigatorKeyProvider),
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: const YesanView(),
      );
    });
  }
}
