import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:yaru/theme.dart';
import 'package:yesan_weather/smart_system_view.dart';

final log = Logger(printer: PrettyPrinter(methodCount: 1));
final materialAppNavigatorKeyProvider =
    Provider((ref) => GlobalKey<NavigatorState>());
final getUrlProvider = FutureProvider<String>((ref) async {
  return await channel.invokeMethod('getAppUrl');
});

const channel = MethodChannel('com.smart.cctv');

void main() async {
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
        home: ref.watch(getUrlProvider).maybeWhen(
              data: (v) => SmartSystemView(baseUrl: v),
              orElse: () => const SizedBox.shrink(),
            ),
      );
    });
  }
}
