import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:furlovin/app/app.dart';
import 'package:furlovin/identity/identity.dart';
import 'package:furlovin/logs/logs.dart';
import 'package:furlovin/shared/shared.dart';
import 'package:furlovin/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setLogLevel(LogLevel.debug);
  Logs(printers: const [ConsoleLogPrinter()]).connect();
  runApp(const ProviderScope(child: App()));
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
    return MaterialApp.router(
      title: 'furlovin',
      scrollBehavior: const DraggableScrollBehavior(),
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      routerConfig: router,
    );
  }
}
