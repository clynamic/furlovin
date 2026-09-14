import 'package:app_links/app_links.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/app/app.dart';
import 'package:furlovin/client/client.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/settings/settings.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setLogLevel(LogLevel.debug);
  Logs(printers: const [ConsoleLogPrinter()]).connect();
  runApp(const ProviderScope(retry: retryFailure, child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final GoRouter router = buildRouter(ref.read(identityStoreProvider));

  @override
  Widget build(BuildContext context) {
    final Appearance appearance = ref.watch(appearanceProvider);
    return DynamicColorBuilder(
      builder: (light, dark) => MaterialApp.router(
        title: 'furlovin',
        scrollBehavior: const DraggableScrollBehavior(),
        themeMode: appearance.mode,
        theme: buildTheme(
          Brightness.light,
          accent: appearance.dynamicAccent ? light?.primary : null,
        ),
        darkTheme: buildTheme(
          Brightness.dark,
          accent: appearance.dynamicAccent ? dark?.primary : null,
          black: appearance.black,
        ),
        routerConfig: router,
        builder: (context, child) => LinkListener(
          links: AppLinks().uriLinkStream,
          navigator: rootNavigator,
          child: child!,
        ),
      ),
    );
  }
}
